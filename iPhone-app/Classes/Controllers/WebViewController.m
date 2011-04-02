//
//  WebViewController.m
//  WebCamera
//
//  Created by Shayne Sweeney on 5/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"
#import "Base64.h"
#import "UIImage+Resize.h"
#import "NSString+ContainsString.h"
#import "GTMNSDictionary+URLArguments.h"

@implementation WebViewController


@synthesize divID = divID_;
@synthesize inputID = inputID_;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		webView_ = nil;
		imagePickerController_ = nil;
		targetWidth_ = 0;
		targetHeight_ = 0;
		divID_ = nil;
		inputID_ = nil;
	}
	return self;
}

- (void)dealloc {
	[divID_ release];
	[inputID_ release];
	[webView_ release];
	[imagePickerController_ release];
	[super dealloc];
}


- (void)loadView {
	self.view = self.webView;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[webView_ loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://10.20.80.103:9393/webcamera.html"]]];
}

- (UIWebView *)webView {
	if (!webView_) {
		webView_ = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
		
		webView_.delegate = self;
	}
	return webView_;
}

- (UIImagePickerController *)imagePickerController {
	if (!imagePickerController_) {
		imagePickerController_ = [[UIImagePickerController alloc] init];
		
		imagePickerController_.delegate = self;
		imagePickerController_.allowsEditing = YES;
	}
	return imagePickerController_;
}

- (void)choosePhoto {
	UIActionSheet *actionSheet;
	
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Source" 
																							delegate:self 
																		 cancelButtonTitle:@"Cancel" 
																destructiveButtonTitle:nil 
																		 otherButtonTitles:@"Camera", @"Photo Library", nil];
	} else {
		actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Source" 
																							delegate:self 
																		 cancelButtonTitle:@"Cancel" 
																destructiveButtonTitle:nil 
																		 otherButtonTitles:@"Photo Library", nil];		
	}
	
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	UIImagePickerControllerSourceType sourceType;
	
	if ([actionSheet numberOfButtons] == 2)
		buttonIndex++;
	
	switch (buttonIndex) {
		case 0:
			sourceType = UIImagePickerControllerSourceTypeCamera;
			break;
		case 1:
			sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
			break;
		default:
			return;
	}
	
	self.imagePickerController.sourceType = sourceType;
	[self presentModalViewController:imagePickerController_ animated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSString *string = [[request URL] absoluteString];
	
	if ([string containsString:@"webcamera:choose_photo" options:(NSCaseInsensitiveSearch|NSAnchoredSearch)]) {
		NSArray *components = [string componentsSeparatedByString:@"?"];
		NSString *argString = [components objectAtIndex:1];
		NSDictionary *arguments = [NSDictionary gtm_dictionaryWithHttpArgumentsString:argString];
		
		targetWidth_ = [[arguments objectForKey:@"width"] floatValue];
		targetHeight_ = [[arguments objectForKey:@"height"] floatValue];
		
		self.divID = [arguments objectForKey:@"div_id"];
		self.inputID = [arguments objectForKey:@"input_id"];
		
		[self choosePhoto];
		return NO;
	}
	return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissModalViewControllerAnimated:YES];
	[self performSelectorInBackground:@selector(processImageWithInfo:) withObject:info];
}

- (void)processImageWithInfo:(NSDictionary *)info {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
	
	UIImage *resizedImage;
	
	if (targetHeight_ > 0 && targetWidth_ <= 0) {
		resizedImage = [image imageByScalingToHeight:targetHeight_];
	} else if (targetWidth_ > 0 && targetHeight_ <= 0) {
		resizedImage = [image imageByScalingToWidth:targetWidth_];
	} else {
		resizedImage = [image imageByScalingToSize:CGSizeMake(targetWidth_, targetHeight_)];
	}
	
	NSData *imageData = UIImagePNGRepresentation(resizedImage);
	
	[webView_ performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) 
														 withObject:[NSString stringWithFormat:@"setPhoto('%@', '%@', '%@')", divID_, inputID_, [Base64 encode:imageData]]
													waitUntilDone:YES];
	
	[pool release];
}

@end

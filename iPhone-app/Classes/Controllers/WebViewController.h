//
//  WebViewController.h
//  WebCamera
//
//  Created by Shayne Sweeney on 5/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController <UIWebViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate> {
	UIWebView *webView_;
	UIImagePickerController *imagePickerController_;
	CGFloat targetHeight_;
	CGFloat targetWidth_;
	NSString *divID_;
	NSString *inputID_;
}

@property (nonatomic, readonly) UIWebView *webView;
@property (nonatomic, readonly) UIImagePickerController *imagePickerController;
@property (nonatomic, copy) NSString *divID;
@property (nonatomic, copy) NSString *inputID;

@end

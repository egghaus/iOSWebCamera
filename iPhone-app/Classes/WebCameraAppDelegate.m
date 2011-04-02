//
//  WebCameraAppDelegate.m
//  WebCamera
//
//  Created by Shayne Sweeney on 5/25/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "WebCameraAppDelegate.h"
#import "WebViewController.h"


@implementation WebCameraAppDelegate

@synthesize window = window_;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	webController_ = [[WebViewController alloc] initWithNibName:nil bundle:nil];
	[window_ addSubview:webController_.view];
	[window_ makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
	[webController_ release];
	[window_ release];
	[super dealloc];
}

@end

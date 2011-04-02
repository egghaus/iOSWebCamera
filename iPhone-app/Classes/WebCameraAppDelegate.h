//
//  WebCameraAppDelegate.h
//  WebCamera
//
//  Created by Shayne Sweeney on 5/25/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WebViewController;


@interface WebCameraAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window_;
	WebViewController *webController_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end


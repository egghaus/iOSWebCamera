//
//  UIImage+Resize.m
//  WebCamera
//
//  Created by Shayne Sweeney on 5/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (UIImage *)imageByScalingToWidth:(CGFloat)targetWidth {
	CGFloat width = self.size.width;
	CGFloat height = self.size.height;
	CGFloat targetHeight = round(height / (width / targetWidth));
	return [self imageByScalingToSize:CGSizeMake(targetWidth, targetHeight)];
}

- (UIImage *)imageByScalingToHeight:(CGFloat)targetHeight {
	CGFloat width = self.size.width;
	CGFloat height = self.size.height;
	CGFloat targetWidth = round(width / (height / targetHeight));
	return [self imageByScalingToSize:CGSizeMake(targetWidth, targetHeight)];
}

- (UIImage *)imageByScalingToSize:(CGSize)targetSize {
	NSInteger targetWidth = targetSize.width;
	NSInteger targetHeight = targetSize.height;
	
	CGImageRef imageRef = [self CGImage];
	// color space of the bitmap: RGB, GRAY, CMYK, etc...
	CGColorSpaceRef colorSpaceRef = CGImageGetColorSpace(imageRef);
	// how is the bitmap data stored? do we have an alpha channel? how is that stored?
	CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
	// I guess there's weirdness with kCGImageAlphaNone and CGBitmapContextCreate
	// only certain alpha values are supported with RGB 8 bit
	if (bitmapInfo == kCGImageAlphaNone)
		bitmapInfo = kCGImageAlphaNoneSkipLast;
	
	// swap width and height if orientation is left or right
	if (self.imageOrientation == UIImageOrientationLeft || self.imageOrientation == UIImageOrientationRight)
		targetWidth = targetHeight, targetHeight = targetWidth;
	
	// Build a bitmap context of the target size
	CGContextRef bitmapRef = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceRef, bitmapInfo);
	
	if (self.imageOrientation == UIImageOrientationLeft) {
		CGContextRotateCTM(bitmapRef, M_PI/2);
		CGContextTranslateCTM(bitmapRef, -targetWidth, 0);
	} else if (self.imageOrientation == UIImageOrientationRight) {
		CGContextRotateCTM(bitmapRef, -M_PI/2);
		CGContextTranslateCTM(bitmapRef, 0, -targetHeight);
	} else if (self.imageOrientation == UIImageOrientationUp) {
		// nada
	} else if (self.imageOrientation == UIImageOrientationDown) {
		CGContextRotateCTM(bitmapRef, -M_PI);
		CGContextTranslateCTM(bitmapRef, targetWidth, targetHeight);
	}
	
	// Draw into the context (this scales the image)
	CGContextDrawImage(bitmapRef, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
	
	// Get an image from the context and a UIImage
	CGImageRef resizedImageRef = CGBitmapContextCreateImage(bitmapRef);
	UIImage *resizedImage = [UIImage imageWithCGImage:resizedImageRef];
	
	CGContextRelease(bitmapRef);
	CGImageRelease(resizedImageRef);
	
	return resizedImage;
}

@end

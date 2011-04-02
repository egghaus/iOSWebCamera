//
//  UIImage+Resize.h
//  WebCamera
//
//  Created by Shayne Sweeney on 5/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


@interface UIImage (Resize)

- (UIImage *)imageByScalingToWidth:(CGFloat)targetWidth;
- (UIImage *)imageByScalingToHeight:(CGFloat)targetHeight;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;

@end

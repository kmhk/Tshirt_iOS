//
//  UIImage+tintImage.m
//  LionTee
//
//  Created by baijin on 10/17/14.
//  Copyright (c) 2014 Bai. All rights reserved.
//

#import "UIImage+tintImage.h"

@implementation UIImage (tintImage)

- (UIImage *) tintImageWithColor: (UIColor *) color
{
    CGRect contextRect;
    contextRect.origin.x = 0.0f;
    contextRect.origin.y = 0.0f;
    contextRect.size = [self size];
    // Retrieve source image and begin image context
    CGSize itemImageSize = [self size];
    CGPoint itemImagePosition;
    itemImagePosition.x = ceilf((contextRect.size.width - itemImageSize.width) / 2);
    itemImagePosition.y = ceilf((contextRect.size.height - itemImageSize.height) );
	
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(contextRect.size, NO, [[UIScreen mainScreen] scale]); //Retina support
    else
        UIGraphicsBeginImageContext(contextRect.size);
	
    CGContextRef c = UIGraphicsGetCurrentContext();
    // Setup shadow
    // Setup transparency layer and clip to mask
    CGContextBeginTransparencyLayer(c, NULL);
    CGContextScaleCTM(c, 1.0, -1.0);
    CGContextClipToMask(c, CGRectMake(itemImagePosition.x, -itemImagePosition.y, itemImageSize.width, -itemImageSize.height), [self CGImage]);
	
    // Fill and end the transparency layer
    color = [color colorWithAlphaComponent:1.0];
	
    CGContextSetFillColorWithColor(c, color.CGColor);
	
    contextRect.size.height = -contextRect.size.height;
    CGContextFillRect(c, contextRect);
    CGContextEndTransparencyLayer(c);
	
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return img;
}

- (UIImage *)imageWithMappingImage:(UIImage *)img
{
	UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextTranslateCTM(context, 0, self.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
	
	CGContextClipToMask(context, rect, self.CGImage);
	CGContextDrawImage(context, rect, self.CGImage);
	
	CGContextSetBlendMode(context, kCGBlendModeNormal);
	//[color1 setFill];
	CGContextDrawImage(context, rect, img.CGImage);
	//CGContextFillRect(context, rect);
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

- (UIImage *)imageWithColor:(UIColor *)color1
{
	UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextTranslateCTM(context, 0, self.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
	
	CGContextClipToMask(context, rect, self.CGImage);
	CGContextDrawImage(context, rect, self.CGImage);
	
	CGContextSetBlendMode(context, kCGBlendModeOverlay);
	[color1 setFill];
	CGContextFillRect(context, rect);
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}


@end

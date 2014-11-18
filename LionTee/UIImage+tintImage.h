//
//  UIImage+tintImage.h
//  LionTee
//
//  Created by baijin on 10/17/14.
//  Copyright (c) 2014 Bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (tintImage)

- (UIImage *) tintImageWithColor: (UIColor *) color;
- (UIImage *)imageWithColor:(UIColor *)color1;
- (UIImage *)maskImage:(UIImage *)image withMask:(UIImage *)maskImage;
- (UIImage *)imageWithMappingImage:(UIImage *)img;

@end

//
//  AppDelegate.h
//  LionTee
//
//  Created by baijin on 10/16/14.
//  Copyright (c) 2014 Bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *printType;
@property (strong, nonatomic) NSString *tshirtImageName;
@property (strong, nonatomic) NSString *tshirtType;
@property (strong, nonatomic) NSString *tshirtColor;

@property (nonatomic) int price;
@property (nonatomic) int smallNumber;
@property (nonatomic) int mediumNumber;
@property (nonatomic) int largeNumber;
@property (nonatomic) int xLargeNumber;
@property (nonatomic) int xxLargeNumber;
@property (nonatomic) int xxxLargeNumber;


@end

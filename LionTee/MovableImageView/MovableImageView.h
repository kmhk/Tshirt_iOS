//
//  MovableImageView.h
//  LionTee
//
//  Created by baijin on 10/17/14.
//  Copyright (c) 2014 Bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MovableImageView;

@protocol MovableImageViewDelegate <NSObject>

- (void)setCurrentImageView:(MovableImageView *)imgView;
- (void)showCurrentImageView:(MovableImageView *)imgView;
@end


@interface MovableImageView : UIImageView
{
	CGPoint						_start;
}

@property (nonatomic) id<MovableImageViewDelegate> delegate;
@property(nonatomic , strong) UIImage * originalImag;
@property (nonatomic, assign) NSInteger  filterNumber;
@property (nonatomic, assign) BOOL isMovalbleFlag;

@end

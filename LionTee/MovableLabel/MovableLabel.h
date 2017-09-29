//
//  MovableLabel.h
//  Panly
//
//  Created by baijin on 7/19/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MovableLabel;

@protocol MovableLabelDelegate <NSObject>

- (void)setCurrentTextLabel:(MovableLabel *)label;
- (void)showCurrentTextLabel:(MovableLabel *)label;

@end



@interface MovableLabel : UILabel
{
	CGPoint						_start;
}

@property (nonatomic) id<MovableLabelDelegate> delegate;

@end

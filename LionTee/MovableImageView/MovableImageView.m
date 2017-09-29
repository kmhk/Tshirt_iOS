//
//  MovableImageView.m
//  LionTee
//
//  Created by baijin on 10/17/14.
//  Copyright (c) 2014 Bai. All rights reserved.
//

#import "MovableImageView.h"

@implementation MovableImageView

@synthesize originalImag, filterNumber,isMovalbleFlag;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.userInteractionEnabled = YES;
		
		UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
		[doubleTap setNumberOfTapsRequired:2];
		[self addGestureRecognizer:doubleTap];
        
        UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTap:)];
        [oneTap setNumberOfTapsRequired:1];
        [self addGestureRecognizer:oneTap];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		self.userInteractionEnabled = YES;
	}
	return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)doubleTap:(UITapGestureRecognizer *)gesture
{
	[self.delegate setCurrentImageView:self];
}


- (void)oneTap:(UITapGestureRecognizer *)gesture
{
    [self.delegate showCurrentImageView:self];
}

#pragma mark - drag action

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.isMovalbleFlag) {
        return;
    }
	UITouch *touch = [[event allTouches] anyObject];
	_start = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (!self.isMovalbleFlag) {
        return;
    }
    
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint location = [touch locationInView:self];
	
	CGRect rtParent = [self superview].frame;
	
	CGFloat x = self.frame.origin.x + (location.x - _start.x);
	if (x < 0) {
		x = 0;
	} else if (x + self.frame.size.width > rtParent.size.width) {
		x = rtParent.size.width - self.frame.size.width;
	}
	
	CGFloat y = self.frame.origin.y + (location.y - _start.y);
	if (y < 0) {
		y = 0;
	} else if (y + self.frame.size.height > rtParent.size.height) {
		y = rtParent.size.height - self.frame.size.height;
	}
	
	[self setFrame:CGRectMake(x, y, self.frame.size.width, self.frame.size.height)];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.isMovalbleFlag) {
        return;
    }
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint location = [touch locationInView:self];
	
	if (CGPointEqualToPoint(_start, location)) {
		[self becomeFirstResponder];
		return;
	}
	
	CGRect rtParent = [self superview].frame;
	
	CGFloat x = self.frame.origin.x + (location.x - _start.x);
	if (x < 0) {
		x = 0;
	} else if (x + self.frame.size.width > rtParent.size.width) {
		x = rtParent.size.width - self.frame.size.width;
	}
	
	CGFloat y = self.frame.origin.y + (location.y - _start.y);
	if (y < 0) {
		y = 0;
	} else if (y + self.frame.size.height > rtParent.size.height) {
		y = rtParent.size.height - self.frame.size.height;
	}
	
	[self setFrame:CGRectMake(x, y, self.frame.size.width, self.frame.size.height)];
}


@end

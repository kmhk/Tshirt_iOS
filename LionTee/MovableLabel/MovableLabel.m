//
//  MovableLabel.m
//  Panly
//
//  Created by baijin on 7/19/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "MovableLabel.h"

@implementation MovableLabel

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		
		//UIPinchGestureRecognizer *twoFingerPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerPinch:)];
		//[self addGestureRecognizer:twoFingerPinch];
       self.numberOfLines  = 0;
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


- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer
{
    //NSLog(@"Pinch scale: %f", recognizer.scale);
    CGAffineTransform transform = CGAffineTransformMakeScale(recognizer.scale, recognizer.scale);
	// you can implement any int/float value in context of what scale you want to zoom in or out
    self.transform = transform;
}

- (void)doubleTap:(UITapGestureRecognizer *)gesture
{
	[self.delegate setCurrentTextLabel:self];
}


- (void)oneTap:(UITapGestureRecognizer *)gesture
{
    [self.delegate showCurrentTextLabel:self];
}

#pragma mark - drag action

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [[event allTouches] anyObject];
	_start = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
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

//
//  CheckoutViewController.h
//  LionTee
//
//  Created by iii on 03/12/14.
//  Copyright (c) 2014 Bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckoutViewController : UIViewController
{
    IBOutlet UIButton *smallNumberButton;
    IBOutlet UIButton *mediumNumberButton;
    IBOutlet UIButton *largeNumberButton;
    
    IBOutlet UIButton *xLargeNumberButton;
    IBOutlet UIButton *xxLargeNumberButton;
    IBOutlet UIButton *xxxLargeNumberButton;
}

-(void)updateNumbers;

-(IBAction)smallMinusAction:(id)sender;
-(IBAction)smallPlusAction:(id)sender;

-(IBAction)mediumMinusAction:(id)sender;
-(IBAction)mediumPlusAction:(id)sender;

-(IBAction)largeMinusAction:(id)sender;
-(IBAction)largePlusAction:(id)sender;

-(IBAction)xLargeMinusAction:(id)sender;
-(IBAction)xLargePlusAction:(id)sender;

-(IBAction)xxLargeMinusAction:(id)sender;
-(IBAction)xxLargePlusAction:(id)sender;

-(IBAction)xxxLargeMinusAction:(id)sender;
-(IBAction)xxxLargePlusAction:(id)sender;


@end

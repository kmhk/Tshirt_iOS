//
//  OrderConfirmationViewController.h
//  LionTee
//
//  Created by Sam Gabbay on 11/13/14.
//  Copyright (c) 2014 Bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderConfirmationViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextView *addressLabel;
@property (nonatomic, strong) IBOutlet UILabel *totalPrice;

-(IBAction)popBack:(id)sender;
-(IBAction)mailTo:(id)sender;
@end

//
//  ShippinngEditViewController.h
//  StripeExample
//
//  Created by wang on 11/6/14.
//  Copyright (c) 2014 Stripe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShippinngEditViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UIScrollView * scrollView;
    IBOutlet UILabel * alertLabel;
    IBOutlet UITextField  * firstName;
    IBOutlet UITextField  * lastName;
    IBOutlet UITextField * street1;
    IBOutlet UITextField * street2;
    IBOutlet UITextField * city;
    IBOutlet UITextField * state;
    IBOutlet UITextField * zip;
    IBOutlet UITextField * country;
    IBOutlet UITextField * phone;
    
    UITextField * currentTextField;
}
@end

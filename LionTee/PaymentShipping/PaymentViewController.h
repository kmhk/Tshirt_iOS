//
//  PaymentViewController.h
//  Stripe
//
//  Created by Alex MacCaw on 3/4/13.
//
//

#import <UIKit/UIKit.h>

@interface PaymentViewController : UIViewController {
    
    NSString *fullAddress;
    NSString *phoneNumber;
    
}


@property (nonatomic) NSDecimalNumber *amount;
@property (nonatomic) UIViewController * parent;
- (IBAction)save:(id)sender;

@end

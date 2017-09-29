//
//  CheckoutViewController.h
//  LionTee
//
//  Created by iii on 03/12/14.
//  Copyright (c) 2014 Bai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKPayment+STPTestKeys.h"
#import "PTKView.h"
#import "Stripe.h"
#import <AddressBook/AddressBook.h>


#define NY_RATE 1.0875
@protocol CheckOutDelegate <NSObject>

- (void)createBackendChargeWithToken:(STPToken *)token withTotalPrice:(NSString *)totalPrice
                          completion:(void (^)(PKPaymentAuthorizationStatus))completion;

-(void)setFullAddress:(NSString *)address;
-(void)setCheckOutView:(UIView *)view;
@end

@interface CheckoutViewController : UIViewController<UITextFieldDelegate, UIScrollViewDelegate, PKPaymentAuthorizationViewControllerDelegate>

{

    NSString *fullName;
    NSString *fullAddress;
    NSString *phoneNumber;
    NSString *emailAddress;
    NSString *addressStringPass;
    
    IBOutlet UIButton *smallNumberButton;
    IBOutlet UIButton *mediumNumberButton;
    IBOutlet UIButton *largeNumberButton;
    
    IBOutlet UIButton *xLargeNumberButton;
    IBOutlet UIButton *xxLargeNumberButton;
    IBOutlet UIButton *xxxLargeNumberButton;
    
    
    IBOutlet UIView * purchaseView;
    IBOutlet UILabel * priceLabel;
    
    IBOutlet UIView * cardNumberView;
    IBOutlet UITextField * nameField;
    IBOutlet UITextField * streetField;
    IBOutlet UITextField * streetField2;
    IBOutlet UITextField * cityField;
    IBOutlet UITextField * stateField;
    IBOutlet UITextField * phoneField;
    IBOutlet UITextField * zipField;
    
    IBOutlet UIButton * purchaseButton;
    
    IBOutlet UIImageView * validImageView;
    PTKView *paymentView;
    
    // uiscrollview
    
    IBOutlet UIScrollView * checkoutScrollView;
    IBOutlet UIView * contentView;
    
    BOOL keyboardHideFlag;
    
    float currentTotalPrice;
    
    BOOL isNY;
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

-(IBAction)onCompletePurchase:(id)sender;
-(IBAction)applePay;




@property (nonatomic, strong) id<CheckOutDelegate> delegate;

@end

//
//  CheckoutViewController.m
//  LionTee
//
//  Created by iii on 03/12/14.
//  Copyright (c) 2014 Bai. All rights reserved.
//

#import "CheckoutViewController.h"
#import "MBProgressHUD.h"
#import "Stripe+ApplePay.h"

#define YOUR_APPLE_MERCHANT_ID @"merchant.samgabbay.liontee"

@interface CheckoutViewController ()<PTKViewDelegate>

@end

@implementation CheckoutViewController

@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    isNY = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:nil];

    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationItem.backBarButtonItem setTitle:@"lll"];
      [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
   
    [purchaseButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [purchaseButton.layer setBorderWidth:1.5f];
    [purchaseButton.layer setCornerRadius:5];
    
    
    CGRect  rect = CGRectMake(0, 0, cardNumberView.frame.size.width, cardNumberView.frame.size.height);
    
    paymentView = [[PTKView alloc] initWithFrame:rect];
    paymentView.delegate = self;
    [cardNumberView addSubview:paymentView];
    
    [checkoutScrollView setScrollEnabled:YES];
    
    [checkoutScrollView setContentSize:CGSizeMake(contentView.frame.size.width, contentView.frame.size.height-64)];
    [contentView setFrame:CGRectMake(0, -64, contentView.frame.size.width, contentView.frame.size.height)];
    
    //PlaceHolder color change
    
        [nameField setValue:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.50f] forKeyPath:@"_placeholderLabel.textColor"];
        [streetField setValue:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.50f] forKeyPath:@"_placeholderLabel.textColor"];
        [streetField2 setValue:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.50f] forKeyPath:@"_placeholderLabel.textColor"];
        [cityField setValue:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.50f] forKeyPath:@"_placeholderLabel.textColor"];
        [stateField setValue:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.50f] forKeyPath:@"_placeholderLabel.textColor"];
        [phoneField setValue:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.50f] forKeyPath:@"_placeholderLabel.textColor"];
        [zipField setValue:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.50f] forKeyPath:@"_placeholderLabel.textColor"];

}

-(IBAction)applePay {
    
    // for Apple Pay
    PKPaymentRequest *request = [Stripe paymentRequestWithMerchantIdentifier:YOUR_APPLE_MERCHANT_ID];
    UIViewController *paymentController;
        
        paymentController = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
        ((PKPaymentAuthorizationViewController *)paymentController).delegate = self;
    
        [self presentViewController:paymentController animated:YES completion:nil];
    
        NSString *priceString = priceLabel.text;
    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:priceString forKey:@"APPLEPAYPRICE"];
        [defaults synchronize];
    

    
    
}


-(void)viewDidAppear:(BOOL)animated{
    
   
    [super viewDidAppear:animated];
    [self updateNumbers];
}


// PTKPayment Delegate

- (void)paymentView:(PTKView *)paymentView withCard:(PTKCard *)card isValid:(BOOL)valid {
    // Enable save button if the Checkout is valid
    if (valid) {
        [validImageView setImage:[UIImage imageNamed:@"checked_circle"]];
    }else{
        [validImageView setImage:[UIImage imageNamed:@"empty_circle"]];
    }
}

-(void)updateNumbers{
    AppDelegate* MyAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [smallNumberButton setTitle:[NSString stringWithFormat:@"%d",MyAppDelegate.smallNumber] forState:UIControlStateNormal];
    [mediumNumberButton setTitle:[NSString stringWithFormat:@"%d",MyAppDelegate.mediumNumber] forState:UIControlStateNormal];
    [largeNumberButton setTitle:[NSString stringWithFormat:@"%d",MyAppDelegate.largeNumber] forState:UIControlStateNormal];
    
    [xLargeNumberButton setTitle:[NSString stringWithFormat:@"%d",MyAppDelegate.xLargeNumber] forState:UIControlStateNormal];
    [xxLargeNumberButton setTitle:[NSString stringWithFormat:@"%d",MyAppDelegate.xxLargeNumber] forState:UIControlStateNormal];
    [xxxLargeNumberButton setTitle:[NSString stringWithFormat:@"%d",MyAppDelegate.xxxLargeNumber] forState:UIControlStateNormal];
    
    if (MyAppDelegate.smallNumber == 0 &&
        MyAppDelegate.mediumNumber == 0 &&
        MyAppDelegate.largeNumber == 0 &&
        MyAppDelegate.xLargeNumber == 0 &&
        MyAppDelegate.xxLargeNumber == 0 &&
        MyAppDelegate.xxxLargeNumber == 0) {
        MyAppDelegate.smallNumber = 1;
        // we can not allow to order NONE tshirt, so by default we set 1 small tshirt for all of the times.
        [smallNumberButton setTitle:[NSString stringWithFormat:@"%d",MyAppDelegate.smallNumber] forState:UIControlStateNormal];
    }
    
    NSInteger count = MyAppDelegate.smallNumber + MyAppDelegate.mediumNumber + MyAppDelegate.largeNumber + MyAppDelegate.xLargeNumber + MyAppDelegate.xxLargeNumber + MyAppDelegate.xxxLargeNumber;
    float price = MyAppDelegate.price/100.00;
    
    currentTotalPrice  = price * count;
    float tempPrice = currentTotalPrice;
    if (isNY) {
        tempPrice = currentTotalPrice * NY_RATE;
    }
    
    NSString *priceTitle = [NSString stringWithFormat:@"$%.2f",tempPrice];
    
    [priceLabel setText:priceTitle];
    
}

-(IBAction)smallMinusAction:(id)sender{
    AppDelegate* MyAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    MyAppDelegate.smallNumber--;
    if (MyAppDelegate.smallNumber) {
        MyAppDelegate.smallNumber = 1;
    }
    [self updateNumbers];
}

-(IBAction)smallPlusAction:(id)sender{
    AppDelegate* MyAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    MyAppDelegate.smallNumber++;
    [self updateNumbers];
}

-(IBAction)mediumMinusAction:(id)sender{
    AppDelegate* MyAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    MyAppDelegate.mediumNumber--;
    if (MyAppDelegate.mediumNumber) {
        MyAppDelegate.mediumNumber = 1;
    }
    [self updateNumbers];
}

-(IBAction)mediumPlusAction:(id)sender{
    AppDelegate* MyAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    MyAppDelegate.mediumNumber++;
    [self updateNumbers];
}

-(IBAction)largeMinusAction:(id)sender{
    AppDelegate* MyAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    MyAppDelegate.largeNumber--;
    if (MyAppDelegate.largeNumber) {
        MyAppDelegate.largeNumber = 1;
    }
    [self updateNumbers];
}

-(IBAction)largePlusAction:(id)sender{
    AppDelegate* MyAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    MyAppDelegate.largeNumber++;
    [self updateNumbers];
}

-(IBAction)xLargeMinusAction:(id)sender{
    AppDelegate* MyAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    MyAppDelegate.xLargeNumber--;
    if (MyAppDelegate.xLargeNumber) {
        MyAppDelegate.xLargeNumber = 1;
    }
    [self updateNumbers];
}

-(IBAction)xLargePlusAction:(id)sender{
    AppDelegate* MyAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    MyAppDelegate.xLargeNumber++;
    [self updateNumbers];
}

-(IBAction)xxLargeMinusAction:(id)sender{
    AppDelegate* MyAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    MyAppDelegate.xxLargeNumber--;
    if (MyAppDelegate.xxLargeNumber) {
        MyAppDelegate.xxLargeNumber = 1;
    }
    [self updateNumbers];
}

-(IBAction)xxLargePlusAction:(id)sender{
    AppDelegate* MyAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    MyAppDelegate.xxLargeNumber++;
    [self updateNumbers];
}

-(IBAction)xxxLargeMinusAction:(id)sender{
    AppDelegate* MyAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    MyAppDelegate.xxxLargeNumber--;
    if (MyAppDelegate.xxxLargeNumber) {
        MyAppDelegate.xxxLargeNumber = 1;
    }
    [self updateNumbers];
}

-(IBAction)xxxLargePlusAction:(id)sender{
    AppDelegate* MyAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    MyAppDelegate.xxxLargeNumber++;
    [self updateNumbers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/////////////////    UItextField Placeholder color  change

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self showWillKeyboard:textField];
    return  YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    return  YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self hideWillKeyboard];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == stateField) {
        
        NSString * tempStr = @"";
        
        if (![string isEqualToString:@""]) {
            tempStr =   [NSString stringWithFormat:@"%@%@", textField.text, string];
        }
        
        if ([tempStr isEqualToString:@"NY"]) {
            
            if (!isNY) {
                isNY = YES;
                float tempPrice = currentTotalPrice * NY_RATE;
                [priceLabel setText:[NSString stringWithFormat:@"$%.2f",tempPrice]];
            }
        }else
        {
            if (isNY) {
                isNY = NO;
                float tempPrice = currentTotalPrice;
                [priceLabel setText:[NSString stringWithFormat:@"$%.2f",tempPrice]];
            }
           
        }
        
        if ([string isEqual:@""]) {
            return YES;
        }
        
        if(textField.text.length >= 2)
            return NO;
    }
    
    return  YES;
}



-(IBAction)onCompletePurchase:(id)sender
{   
        
        if (![paymentView isValid]) {
            
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invalid Credit Card Information"
                                                              message:@"Please Insert Correct Data!"
                                                             delegate:nil
                                                    cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                    otherButtonTitles:nil];
            [message show];
            
            return;
        }
        if (![Stripe defaultPublishableKey]) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Publishable Key"
                                                              message:@"Please specify a Stripe Publishable Key in Constants.m"
                                                             delegate:nil
                                                    cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                    otherButtonTitles:nil];
            [message show];
            return;
        }
       MBProgressHUD * hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  
    hud.labelText = @"Paying";
        STPCard *card = [[STPCard alloc] init];
        card.number = paymentView.card.number;
        card.expMonth = paymentView.card.expMonth;
        card.expYear = paymentView.card.expYear;
        card.cvc = paymentView.card.cvc;
        [Stripe createTokenWithCard:card
                         completion:^(STPToken *token, NSError *error) {
                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                            
                             if (error) {
                                   return;
                             } else {

                                 NSString * addressStr;
                                 addressStr = [NSString stringWithFormat:@"%@ , %@\n%@, %@ %@\n%@", streetField.text,  streetField2.text, cityField.text, stateField.text, phoneField.text , zipField.text];
                                 
                                 [delegate setFullAddress:addressStr];
                                 [delegate setCheckOutView:self.view];
                                 [delegate createBackendChargeWithToken:token withTotalPrice:priceLabel.text  completion:^(PKPaymentAuthorizationStatus status) {
                                     
                                     if (status == PKPaymentAuthorizationStatusFailure) {
                                         UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Failsure"
                                                                                           message:@"Backend Charging is not working!"
                                                                                          delegate:nil
                                                                                 cancelButtonTitle:@"OK"
                                                                                 otherButtonTitles:nil];
                                         [message show];
                                     }else
                                     {
                                        
                                     }
                                 }];
                                 
                             }
                         }];
}


-(void)showWillKeyboard:(UITextField *)textField
{
    
    
   CGFloat y =  purchaseView.frame.origin.y - 64;
    
    [UIView animateWithDuration:0.7 animations:^(void){
        [self.navigationController.navigationBar setHidden:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        [checkoutScrollView setContentOffset:CGPointMake(0, y)];}];
}


-(void)hideWillKeyboard
{
    
    [UIView animateWithDuration:0.7 animations:^(void){
        
        keyboardHideFlag = YES;
        
        [self.navigationController.navigationBar setHidden:NO];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [checkoutScrollView setContentOffset:CGPointMake(0, -64)];} completion:^(BOOL finished){keyboardHideFlag = NO; }
     ];
    
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    /*
     We'll implement this method below in 'Creating a single-use token'.
     Note that we've also been given a block that takes a
     PKPaymentAuthorizationStatus. We'll call this function with either
     PKPaymentAuthorizationStatusSuccess or PKPaymentAuthorizationStatusFailure
     after all of our asynchronous code is finished executing. This is how the
     PKPaymentAuthorizationViewController knows when and how to update its UI.
     */
    [self handlePaymentAuthorizationWithPayment:payment completion:completion];
    
    
    ABMultiValueRef emails = ABRecordCopyValue([payment shippingAddress], kABPersonEmailProperty);
    
    for (CFIndex index = 0; index < ABMultiValueGetCount(emails); index++)
    {
        NSArray *emailAddresses = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(emails);
        NSString * result = [emailAddresses description];
        NSString *openString = [result stringByReplacingOccurrencesOfString:@"(" withString:@""];
        NSString *closeString = [openString stringByReplacingOccurrencesOfString:@")" withString:@""];
        NSString *quoteString = [closeString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSString *quotesString = [quoteString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *spaceString = [quotesString stringByReplacingOccurrencesOfString:@" " withString:@""];
        emailAddress = spaceString;
        NSLog(@"Email: %@", spaceString);
        
    }
    
    ABMultiValueRef phones = ABRecordCopyValue([payment shippingAddress], kABPersonPhoneProperty);
    
    
    for (CFIndex index = 0; index < ABMultiValueGetCount(emails); index++)
    {
        NSArray *phoneNumbers = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phones);
        NSString * result = [phoneNumbers description];
        NSString *openString = [result stringByReplacingOccurrencesOfString:@"(" withString:@""];
        NSString *closeString = [openString stringByReplacingOccurrencesOfString:@")" withString:@""];
        NSString *quoteString = [closeString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSString *quotesString = [quoteString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *extraSpace = [quotesString stringByReplacingOccurrencesOfString:@"    " withString:@""];
        phoneNumber = extraSpace;
        NSLog(@"Phone Number: %@", extraSpace);
        
    }
    
    ABMultiValueRef addresses = ABRecordCopyValue([payment shippingAddress], kABPersonAddressProperty);
    
    for (CFIndex index = 0; index < ABMultiValueGetCount(addresses); index++)
    {
        CFDictionaryRef properties = ABMultiValueCopyValueAtIndex(addresses, index);
        NSString *street = [(__bridge NSString *)(CFDictionaryGetValue(properties, kABPersonAddressStreetKey)) copy];
        NSString *city = [(__bridge NSString *)(CFDictionaryGetValue(properties, kABPersonAddressCityKey)) copy];
        NSString *state = [(__bridge NSString *)(CFDictionaryGetValue(properties, kABPersonAddressStateKey)) copy];
        NSString *postalCode = [(__bridge NSString *)(CFDictionaryGetValue(properties, kABPersonAddressZIPKey)) copy];
        NSString *country = [(__bridge NSString *)(CFDictionaryGetValue(properties, kABPersonAddressCountryKey)) copy];
        fullAddress = [NSString stringWithFormat:@"%@\n%@, %@ %@\n%@", street, city, state, postalCode, country];
        NSLog(@"Address: %@", fullAddress);
        
    }
    
    NSString *name = (__bridge_transfer NSString *)(ABRecordCopyCompositeName([payment shippingAddress]));
    NSLog(@"Name: %@", name);
    fullName = name;
    
    //NSLog(@"City: %@", [shippingAddress valueForKey:@"City"]);
    
    
}



- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self createDirectoryToFtp];
    
}

- (void)handlePaymentAuthorizationWithPayment:(PKPayment *)payment
                                   completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    [Stripe createTokenWithPayment:payment
                        completion:^(STPToken *token, NSError *error) {
                            if (error) {
                                completion(PKPaymentAuthorizationStatusFailure);
                                return;
                            }
                            /*
                             We'll implement this below in "Sending the token to your server".
                             Notice that we're passing the completion block through.
                             See the above comment in didAuthorizePayment to learn why.
                             
                            
                            [delegate createBackendChargeWithToken:token withTotalPrice:priceLabel.text  completion:^(PKPaymentAuthorizationStatus status) {
                                
                                if (status == PKPaymentAuthorizationStatusFailure) {
                                    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Failsure"
                                                                                      message:@"Backend Charging is not working!"
                                                                                     delegate:nil
                                                                            cancelButtonTitle:@"OK"
                                                                            otherButtonTitles:nil];
                                    [message show];
                                }else
                                {
                                    NSLog(@"Payment Success");
                                    
                                }
                            }
                            */
                            
                            [delegate createBackendChargeWithToken:token withTotalPrice:priceLabel.text completion:^(PKPaymentAuthorizationStatus status) {
                                if (status == PKPaymentAuthorizationStatusFailure) {
                                    NSLog(@"Payment Failure");
                                }
                                else {
                                    completion(PKPaymentAuthorizationStatusSuccess);
                                    

                                    NSLog(@"Payment Success");
                                }
                            }];
                            
                            
                            ABMultiValueRef addresses = ABRecordCopyValue([payment shippingAddress], kABPersonAddressProperty);
                            
                            for (CFIndex index = 0; index < ABMultiValueGetCount(addresses); index++)
                            {
                                CFDictionaryRef properties = ABMultiValueCopyValueAtIndex(addresses, index);
                                NSString *street = [(__bridge NSString *)(CFDictionaryGetValue(properties, kABPersonAddressStreetKey)) copy];
                                NSString *city = [(__bridge NSString *)(CFDictionaryGetValue(properties, kABPersonAddressCityKey)) copy];
                                NSString *state = [(__bridge NSString *)(CFDictionaryGetValue(properties, kABPersonAddressStateKey)) copy];
                                NSString *postalCode = [(__bridge NSString *)(CFDictionaryGetValue(properties, kABPersonAddressZIPKey)) copy];
                                NSString *country = [(__bridge NSString *)(CFDictionaryGetValue(properties, kABPersonAddressCountryKey)) copy];
                                fullAddress = [NSString stringWithFormat:@"%@\n%@, %@\n%@\n%@", street, city, state, postalCode, country];
                                
                                addressStringPass = [NSString stringWithFormat:@"%@\n%@, %@ %@", street, city, state, postalCode];
                                
                                
                            }
                            
                            NSLog(@"handlePaymentAuthorizationWithPayment");
                            
                            
                            
                        }];
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint  point = scrollView.contentOffset;
    if (keyboardHideFlag) {
        return;
    }
    if (point.y <0) {
        [self.navigationController.navigationBar setHidden:NO];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    if (point.y>0) {
        [self.navigationController.navigationBar setHidden:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
}
@end

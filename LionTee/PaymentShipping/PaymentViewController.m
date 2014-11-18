//
//  PaymentViewController.m
//
//  Created by Alex MacCaw on 2/14/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import "Stripe.h"
#import "MBProgressHUD.h"
#import "PaymentViewController.h"
#import "PTKView.h"
#import "STPTestPaymentSummaryViewController.h"
#import "PKPayment+STPTestKeys.h"
#import "ShippingManager.h"
#import "MainViewController.h"
@interface PaymentViewController () <PTKViewDelegate, PaymentSummaryViewDelegate>
@property (weak, nonatomic) PTKView *paymentView;
@property (nonatomic) ShippingManager *shippingManager;
@end

@implementation PaymentViewController
@synthesize parent;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Checkout";
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    // Setup save button

    NSString *title = [NSString stringWithFormat:@""];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(textFieldShouldReturn:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
 //   saveButton.enabled = YES;
    [saveButton setTintColor:[UIColor redColor]];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = saveButton;

    // Setup checkout
    PTKView *paymentView = [[PTKView alloc] initWithFrame:CGRectMake(15, 20, 290, 55)];
    paymentView.delegate = self;
    self.paymentView = paymentView;
    [self.view addSubview:paymentView];
    
    STPTestPaymentSummaryViewController *summary = [[STPTestPaymentSummaryViewController alloc] initWithPaymentRequest];
    summary.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:summary];
    [navController.navigationBar setHidden:NO];
    [self addChildViewController:navController];
    navController.view.frame = CGRectMake(0, 80,self.view.frame.size.width, self.view.frame.size.height - 90);
    [self.view addSubview:navController.view];
}



- (void)paymentView:(PTKView *)paymentView withCard:(PTKCard *)card isValid:(BOOL)valid {
    // Enable save button if the Checkout is valid
    self.navigationItem.rightBarButtonItem.enabled = valid;
}

- (void)cancel:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)handlePaymentWithPayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion  {
    if (![self.paymentView isValid]) {
        
        completion(PKPaymentAuthorizationStatusFailure);
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invalid Credit Card Information"
                                                          message:@"Please Insert Correct Data!"
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                otherButtonTitles:nil];
        [message show];
        
        return;
    }
    if (![Stripe defaultPublishableKey]) {
        completion(PKPaymentAuthorizationStatusFailure);
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Publishable Key"
                                                          message:@"Please specify a Stripe Publishable Key in Constants.m"
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                otherButtonTitles:nil];
        [message show];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    STPCard *card = [[STPCard alloc] init];
    card.number = self.paymentView.card.number;
    card.expMonth = self.paymentView.card.expMonth;
    card.expYear = self.paymentView.card.expYear;
    card.cvc = self.paymentView.card.cvc;
    [Stripe createTokenWithCard:card
                     completion:^(STPToken *token, NSError *error) {
                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                     //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                         if (error) {
                             completion(PKPaymentAuthorizationStatusFailure);
                             return;
                         } else {
                             MainViewController * temp = (MainViewController *)parent;
                             [temp createBackendChargeWithToken:token completion:^(PKPaymentAuthorizationStatus status) {
                                                                  
                                 if (status == PKPaymentAuthorizationStatusFailure) {
                                     
                                 }else
                                 {
                                     [self paymentCancelDelegate];
                                     // [self.delegate paymentCancelDelegate];
                                 }
                             }];

                         }
                     }];
}

- (void)hasError:(NSError *)error {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                      message:[error localizedDescription]
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                            otherButtonTitles:nil];
    [message show];
}

//- (void)hasToken:(STPToken *)token {
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    
//   [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//
//  
//    
//    // This passes the token off to our payment backend, which will then actually complete charging the card using your account's
////    [PFCloud callFunctionInBackground:@"charge"
////                       withParameters:chargeParams
////                                block:^(id object, NSError *error) {
////                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
////                                    if (error) {
////                                        [self hasError:error];
////                                        return;
////                                    }
////                                    [self.presentingViewController dismissViewControllerAnimated:YES
////                                                                                      completion:^{
////                                                                                          [[[UIAlertView alloc] initWithTitle:@"Payment Succeeded"
////                                                                                                                      message:nil
////                                                                                                                     delegate:nil
////                                                                                                            cancelButtonTitle:nil
////                                                                                                            otherButtonTitles:@"OK", nil] show];
////                                                                                      }];
////                                }];
//}

- (NSArray *)summaryItemsForShippingMethod:(PKShippingMethod *)shippingMethod {
    PKPaymentSummaryItem *foodItem = [PKPaymentSummaryItem summaryItemWithLabel:@"Premium Llama food" amount:self.amount];
    NSDecimalNumber *total = [foodItem.amount decimalNumberByAdding:shippingMethod.amount];
    PKPaymentSummaryItem *totalItem = [PKPaymentSummaryItem summaryItemWithLabel:@"Llama Food Services, Inc." amount:total];
    return @[foodItem, shippingMethod, totalItem];
}

//payment Delegate
-(void)paymentSaveDelegateWithShippingAddress:(ABRecordRef)address completion:(void (^)(PKPaymentAuthorizationStatus status, NSArray *shippingMethods, NSArray *summaryItems))completion {
    [self.shippingManager fetchShippingCostsForAddress:address
                                            completion:^(NSArray *shippingMethods, NSError *error) {
                                                if (error) {
                                                    completion(PKPaymentAuthorizationStatusFailure, nil, nil);
                                                    return;
                                                }
                                                completion(PKPaymentAuthorizationStatusSuccess,
                                                           shippingMethods,
                                                           [self summaryItemsForShippingMethod:shippingMethods.firstObject]);
                                            }];
}


-(void)paymentSaveDelegateWithShippingMethod:(PKShippingMethod *)shippingMethod
                                  completion:(void (^)(PKPaymentAuthorizationStatus, NSArray *summaryItems))completion {
    completion(PKPaymentAuthorizationStatusSuccess, [self summaryItemsForShippingMethod:shippingMethod]);
}

-(void)paymentSaveDelegate:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion
                       {
    [self handlePaymentWithPayment:payment completion:completion];
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
                               NSLog(@"fullAddress: %@", fullAddress);
                               
                               NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                               [defaults setObject:fullAddress forKey:@"STRIPEADDRESS"];
                               [defaults synchronize];

                               
                               
                           }
                           
                           ABMultiValueRef phones = ABRecordCopyValue([payment shippingAddress], kABPersonPhoneProperty);
                           
                           
                           for (CFIndex index = 0; index < ABMultiValueGetCount(phones); index++)
                           {
                               NSArray *phoneNumbers = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phones);
                               NSString * result = [phoneNumbers description];
                               phoneNumber = result;
                               NSLog(@"Phone Number: %@", result);
                               
                               
                               NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                               [defaults setObject:phoneNumber forKey:@"STRIPEPHONE"];
                               [defaults synchronize];
                               
                           }
                     
}

-(void)paymentCancelDelegate {
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (ShippingManager *)shippingManager {
    if (!_shippingManager) {
        _shippingManager = [ShippingManager new];
    }
    return _shippingManager;
}
@end

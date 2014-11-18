//
//  STPTestPaymentSummaryViewController.h
//  StripeExample
//
//  Created by Jack Flintermann on 9/8/14.
//  Copyright (c) 2014 Stripe. All rights reserved.
//

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000

#import <UIKit/UIKit.h>
#import <PassKit/PassKit.h>

@protocol PaymentSummaryViewDelegate <NSObject>

-(void)paymentSaveDelegate:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion;
-(void)paymentSaveDelegateWithShippingAddress:(ABRecordRef)address completion:(void (^)(PKPaymentAuthorizationStatus status, NSArray *shippingMethods, NSArray *summaryItems))completion;
-(void)paymentSaveDelegateWithShippingMethod:(PKShippingMethod *)shippingMethod
                                  completion:(void (^)(PKPaymentAuthorizationStatus, NSArray *summaryItems))completion;
-(void)paymentCancelDelegate;

@end

@interface STPTestPaymentSummaryViewController : UIViewController

- (instancetype)initWithPaymentRequest;
@property(nonatomic, assign)id<PaymentSummaryViewDelegate>delegate;

@end

#endif
//
//  Stripe+ApplePay.m
//  Stripe
//
//  Created by Jack Flintermann on 9/17/14.
//
//

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000// && defined(STRIPE_ENABLE_APPLEPAY)

#import "Stripe.h"
#import "Stripe+ApplePay.h"
#import "STPAPIConnection.h"
#import <PassKit/PassKit.h>
#import <AddressBook/AddressBook.h>

#import "MainViewController.h"

@implementation Stripe (ApplePay)

+ (BOOL)canSubmitPaymentRequest:(PKPaymentRequest *)paymentRequest {
    if (paymentRequest == nil) {
        return NO;
    }
    return [PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:paymentRequest.supportedNetworks];
}

+ (PKPaymentRequest *)paymentRequestWithMerchantIdentifier:(NSString *)merchantIdentifier {
    if (![PKPaymentRequest class]) {
        return nil;
    }
    PKPaymentRequest *paymentRequest = [PKPaymentRequest new];
    [paymentRequest setMerchantIdentifier:merchantIdentifier];
    [paymentRequest setSupportedNetworks:@[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa]];
    [paymentRequest setMerchantCapabilities:PKMerchantCapability3DS];
    [paymentRequest setCountryCode:@"US"];
    [paymentRequest setCurrencyCode:@"USD"];
    
    // What type of info you need (eg email, phone, address, etc);
    paymentRequest.requiredBillingAddressFields = PKAddressFieldAll;
    paymentRequest.requiredShippingAddressFields = PKAddressFieldAll;
    /*
    PKShippingMethod *method1 = [self shippingMethodWithLabel:@"UPS Next Day Air" amount:5.00f];
    PKShippingMethod *method2 = [self shippingMethodWithLabel:@"USPS Standard Mail" amount:0.00f];
    */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableString *string = [defaults objectForKey:@"PRICEKEY"];
    
    NSString *applePrice = [string stringByReplacingOccurrencesOfString:@"$" withString:@""];
    NSString *finalPrice = [applePrice stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSLog(@"Price Key: %@", finalPrice);

    float priceFloat = [applePrice floatValue];
    
    PKPaymentSummaryItem *lineItem1 = [self paymentSummaryItemWithLabel:@"Custom T-Shirt" amount:priceFloat];
    PKPaymentSummaryItem *total = [self paymentSummaryItemWithLabel:@"Lion Tee" amount:priceFloat];
    
    [paymentRequest setPaymentSummaryItems:@[lineItem1, total]];
    return paymentRequest;
}

+ (PKPaymentSummaryItem *)paymentSummaryItemWithLabel:(NSString *)label amount:(CGFloat)amount
{
    NSDecimalNumber *decimalAmount = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithFloat:amount] decimalValue]];
    return [PKPaymentSummaryItem summaryItemWithLabel:label amount:decimalAmount];
}

+ (PKShippingMethod *)shippingMethodWithLabel:(NSString *)label amount:(CGFloat)amount
{
    NSDecimalNumber *decimalAmount = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithFloat:amount] decimalValue]];
    return [PKShippingMethod summaryItemWithLabel:label amount:decimalAmount];
}

+ (void)createTokenWithPayment:(PKPayment *)payment
                    completion:(STPCompletionBlock)handler {
    [self createTokenWithPayment:payment
                  operationQueue:[NSOperationQueue mainQueue]
                      completion:handler];
}

+ (void)createTokenWithPayment:(PKPayment *)payment
                operationQueue:(NSOperationQueue *)queue
                    completion:(STPCompletionBlock)handler {
    
    if (handler == nil) {
        [NSException raise:@"RequiredParameter" format:@"'handler' is required to use the token that is created"];
    }
    
    NSURL *url = [self apiURL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSData *userAgentData = [NSJSONSerialization dataWithJSONObject:[self stripeUserAgentDetails]
                                                            options:0
                                                              error:nil];
    NSString *userAgentDetails = [[NSString alloc] initWithData:userAgentData
                                                       encoding:NSUTF8StringEncoding];
    [request setValue:userAgentDetails forHTTPHeaderField:@"X-Stripe-User-Agent"];
    [request setValue:[@"Bearer " stringByAppendingString:[self defaultPublishableKey]] forHTTPHeaderField:@"Authorization"];
    
    NSMutableCharacterSet *set = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [set removeCharactersInString:@"+="];
    NSString *paymentString = [[[NSString alloc] initWithData:payment.token.paymentData encoding:NSUTF8StringEncoding] stringByAddingPercentEncodingWithAllowedCharacters:set];
    __block NSString *payloadString = [@"pk_token=" stringByAppendingString:paymentString];
    
    if (payment.billingAddress) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        ABMultiValueRef addressValues = ABRecordCopyValue(payment.billingAddress, kABPersonAddressProperty);
        if (ABMultiValueGetCount(addressValues) > 0) {
            CFDictionaryRef dict = ABMultiValueCopyValueAtIndex(addressValues, 0);
            NSString *line1 = CFDictionaryGetValue(dict, kABPersonAddressStreetKey);
            if (line1) {
                params[@"address_line1"] = line1;
            }
            NSString *city = CFDictionaryGetValue(dict, kABPersonAddressCityKey);
            if (city) {
                params[@"address_city"] = city;
            }
            NSString *state = CFDictionaryGetValue(dict, kABPersonAddressStateKey);
            if (state) {
                params[@"address_state"] = state;
            }
            NSString *zip = CFDictionaryGetValue(dict, kABPersonAddressZIPKey);
            if (zip) {
                params[@"address_zip"] = zip;
            }
            NSString *country = CFDictionaryGetValue(dict, kABPersonAddressCountryKey);
            if (country) {
                params[@"address_country"] = country;
            }
            NSMutableCharacterSet *set = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
            [set removeCharactersInString:@"+="];
            [params enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
                NSString *param = [NSString stringWithFormat:@"&billing[%@]=%@", key, [obj stringByAddingPercentEncodingWithAllowedCharacters:set]];
                payloadString = [payloadString stringByAppendingString:param];
            }];
        }
    }
    
    request.HTTPBody = [payloadString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    [[[STPAPIConnection alloc] initWithRequest:request] runOnOperationQueue:queue
                                                                 completion:^(NSURLResponse *response, NSData *body, NSError *requestError) {
                                                                     [self handleTokenResponse:response body:body error:requestError completion:handler];
                                                                 }];
}

+ (BOOL) isSimulatorBuild {
#if TARGET_IPHONE_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

@end

#endif

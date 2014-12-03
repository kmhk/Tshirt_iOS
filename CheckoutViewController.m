//
//  CheckoutViewController.m
//  LionTee
//
//  Created by iii on 03/12/14.
//  Copyright (c) 2014 Bai. All rights reserved.
//

#import "CheckoutViewController.h"

@interface CheckoutViewController ()

@end

@implementation CheckoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateNumbers];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

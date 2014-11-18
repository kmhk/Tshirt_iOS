//
//  OrderConfirmationViewController.m
//  LionTee
//
//  Created by Sam Gabbay on 11/13/14.
//  Copyright (c) 2014 Bai. All rights reserved.
//

#import "OrderConfirmationViewController.h"

@interface OrderConfirmationViewController ()

@end

@implementation OrderConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(IBAction)popBack:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];

}

-(IBAction)mailTo:(id)sender {
    
    NSURL *mailURL = [NSURL URLWithString:@"mailto:LionTee@me.com"];
    
    [[UIApplication sharedApplication] openURL:mailURL];
    
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

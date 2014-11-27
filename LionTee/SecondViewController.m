//
//  SecondViewController.m
//  LionTee
//
//  Created by iii on 27/11/14.
//  Copyright (c) 2014 Bai. All rights reserved.
//

#import "SecondViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate* MyAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self.title = MyAppDelegate.tshirtType;
    [self.navigationController setNavigationBarHidden:NO];
    
    float price = MyAppDelegate.price/100.00;
    NSString *priceTitle = [NSString stringWithFormat:@"$%.2f",price];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:priceTitle forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 60, 30);
    button.layer.borderColor = [self.view tintColor].CGColor;
    button.layer.borderWidth = 1.0f;
    button.clipsToBounds = YES;
    button.layer.cornerRadius = 5;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self action:@selector(clickPayButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = rightButton;
}

-(void) clickPayButton:(id)sender{
    NSLog(@"Click pay button clicked");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    [super viewDidAppear:animated];
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

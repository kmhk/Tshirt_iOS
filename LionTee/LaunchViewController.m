//
//  LaunchViewController.m
//  LionTee
//
//  Created by wang on 11/11/14.
//  Copyright (c) 2014 Bai. All rights reserved.
//

#import "LaunchViewController.h"
#import "MainViewController.h"
@interface LaunchViewController ()

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    
    currentPage = 0;
    [super viewDidLoad];
    
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width * 2 , scrollView.frame.size.height)];
    
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapShirt:)];
    [scrollView addGestureRecognizer:gesture];
 //   [scrollView addSubview:<#(UIView *)#>]
    // Do any additional setup after loading the view.
    
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)onTapShirt:(id)sender
{
    
    MainViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    if (currentPage == 0) {
        controller.basePrice = 19.99;
        controller.isFull_Flag = YES;
    }else if (currentPage == 1)
    {
        controller.basePrice = 29.99;
        controller.isFull_Flag = NO;
    }
    
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView1
{
    currentPage  =  lroundf(scrollView.contentOffset.x/scrollView1.frame.size.width);
    
    if(currentPage == 0)
    {
        [self setBasicActive:YES];
    }else if(currentPage == 1)
    {
        [self setBasicActive:NO];
    }
}

-(IBAction)onBasic:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^(void){[scrollView setContentOffset:CGPointMake(0, 0)];}];
    [self setBasicActive:YES];
}
-(IBAction)onAllOver:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^(void){[scrollView setContentOffset:CGPointMake(scrollView.frame.size.width, 0)];}];
    
    [self setBasicActive:NO];
}


-(void)setBasicActive:(BOOL)flag
{
    if (flag) {
        pageController.currentPage = 0;
        [basicButton setImage:[UIImage imageNamed:@"basic_button_active"] forState:UIControlStateNormal];
        [allOverButton setImage:[UIImage imageNamed:@"allover_button_nonactive"] forState:UIControlStateNormal];
    }else{
        pageController.currentPage = 1;
        [basicButton setImage:[UIImage imageNamed:@"basic_button_nonactive"] forState:UIControlStateNormal];
        [allOverButton setImage:[UIImage imageNamed:@"allover_button_active"] forState:UIControlStateNormal];
    }
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

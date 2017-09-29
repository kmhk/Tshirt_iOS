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


+(NSArray *)sharedShirtColorList:(NSString *) styleName
{
    if (shirtColorList == nil) {
        shirtColorList = [[NSDictionary alloc] initWithObjectsAndKeys:
         [[NSArray alloc] initWithObjects:@"white" ,@" black", @"green", @"grey" , @"huntergreen" , @"navy" , @"orange" , @"pink" , @"royal", @"saphire" ,  @"yellow",nil] ,@"kids",
         [[NSArray alloc] initWithObjects:@"white" ,@"black", @"green",  @"grey" ,  @"navy" , @"orange" , @"purple" ,@"red", @"royal",  nil ] , @"mens",
         [[NSArray alloc] initWithObjects: @"grey" , @"black", @"blue", @"green", @"red",nil] , @"neck",
        [[NSArray alloc] initWithObjects: @"white" ,@"black",  @"grey" , @"navy" @"red",  nil], @"tank",
         [[NSArray alloc] initWithObjects: @"white", @"black",  @"grey" , @"huntergreen" , @"maroon", @"navy" ,  @"royal", nil] , @"hoodie",
         [[NSArray alloc] initWithObjects: @"white", @"black",  @"navy" ,  @"pink" , @"red", @"saphire" , nil] , @"women", nil];
    }
    
    return [NSArray arrayWithArray: [shirtColorList objectForKey:styleName]];
     
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
   
    AppDelegate* MyAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    MyAppDelegate.printType = BASIC_TSHIRT_TYPE;
    MyAppDelegate.price = 1799;
    MyAppDelegate.tshirtType = MENS_CREWNECK;
    MyAppDelegate.tshirtColor = @"";
    MyAppDelegate.tshirtImageName = @"mens";
    
    printCheckboxes = [NSArray arrayWithObjects:basicTshirtButton,alloverTshirtButton, nil];
    
    tshirtCheckboxes = [NSArray arrayWithObjects:kidsCrewneckTshirtButton,mensCrewneckTshirtButton,triBlendVNeckTshirtButton,
                       hoodiePulloverButton,mensTanktopButton,ladiesCrewneckTshirtButton, nil];
    
    basicTshirtButton.selected = YES;
    mensCrewneckTshirtButton.selected = YES;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
  

}

-(void)viewWillAppear:(BOOL)animated
{
      [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)viewDidAppear:(BOOL)animated
{
//    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [super viewDidAppear:animated];
}

-(IBAction)onPrintCheckboxClicked:(UIButton*)sender
{
    AppDelegate* MyAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    for(UIButton *checkbox in printCheckboxes)
        checkbox.selected = NO;
    
    if(sender.tag == 2){
        MyAppDelegate.printType = ALLOVER_TSHIRT_TYPE;
        alloverTshirtButton.selected = YES;
        MyAppDelegate.price = 2499;
    }else if(sender.tag == 1){
        MyAppDelegate.printType = BASIC_TSHIRT_TYPE;
        basicTshirtButton.selected = YES;
        MyAppDelegate.price = 1799;
    }
    
    float price = MyAppDelegate.price/100.;
    NSLog(@"onPrintCheckboxClicked – %@ – $%.2f – %ld",MyAppDelegate.printType,price,(long)sender.tag);
}

-(IBAction)onCheckboxClicked:(UIButton*)sender
{
    AppDelegate* MyAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    for(UIButton *checkbox in tshirtCheckboxes)
        checkbox.selected = NO;
    
    if(sender.tag == 10){
        MyAppDelegate.tshirtType = KIDS_CREWNECK;
        kidsCrewneckTshirtButton.selected = YES;
        MyAppDelegate.tshirtImageName = @"kids";
    }else if(sender.tag == 11){
        MyAppDelegate.tshirtType = MENS_CREWNECK;
        mensCrewneckTshirtButton.selected = YES;
         MyAppDelegate.tshirtImageName = @"mens";
    }else if(sender.tag == 12){
        MyAppDelegate.tshirtType = TRI_BLEND_VNECK;
        triBlendVNeckTshirtButton.selected = YES;
         MyAppDelegate.tshirtImageName = @"neck";
    }else if(sender.tag == 13){
        MyAppDelegate.tshirtType = MENS_TANKTOP;
        mensTanktopButton.selected = YES;
         MyAppDelegate.tshirtImageName = @"tank";
    }else if(sender.tag == 14){
        MyAppDelegate.tshirtType = HOODIE_PULLOVER;
        hoodiePulloverButton.selected = YES;
         MyAppDelegate.tshirtImageName = @"hoodle";
    }else if(sender.tag == 15){
        MyAppDelegate.tshirtType = LADIES_CREWNECK;
        ladiesCrewneckTshirtButton.selected = YES;
         MyAppDelegate.tshirtImageName = @"women";
    }
    
    NSLog(@"onCheckboxClicked – %@ – %ld",MyAppDelegate.tshirtType,(long)sender.tag);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

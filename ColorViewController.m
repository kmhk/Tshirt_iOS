//
//  ColorViewController.m
//  LionTee
//
//  Created by iii on 27/11/14.
//  Copyright (c) 2014 Bai. All rights reserved.
//

#import "ColorViewController.h"

@interface ColorViewController ()

@end

@implementation ColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Choose color";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setShirtColor:(NSString*)color
{
    NSLog(@"setShirtColor - %@",color);
    AppDelegate* MyAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    MyAppDelegate.tshirtColor = color;
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)selectAppleRedShirt:(id)selector { [self setShirtColor:@"apple_red_shirt"]; }
-(IBAction)selectAsphaltShirt:(id)selector { [self setShirtColor:@"asphalt_shirt"]; }
-(IBAction)selectBlackShirt:(id)selector { [self setShirtColor:@"black_shirt"]; }
-(IBAction)selectBrownShirt:(id)selector { [self setShirtColor:@"brown_shirt"]; }
-(IBAction)selectCreamShirt:(id)selector { [self setShirtColor:@"cream_shirt"]; }
-(IBAction)selectHeatherGreyShirt:(id)selector { [self setShirtColor:@"heather_grey_shirt"]; }
-(IBAction)selectHunterShirt:(id)selector { [self setShirtColor:@"hunter_green"]; }
-(IBAction)selectMidnightShirt:(id)selector { [self setShirtColor:@"midnight_shirt"]; }
-(IBAction)selectNavyShirt:(id)selector { [self setShirtColor:@"navy_shirt"]; }
-(IBAction)selectOrangeShirt:(id)selector { [self setShirtColor:@"orange_shirt"]; }
-(IBAction)selectPowderBlueShirt:(id)selector { [self setShirtColor:@"powder_blue_shirt"]; }
-(IBAction)selectPurpleShirt:(id)selector { [self setShirtColor:@"purple_shirt"]; }
-(IBAction)selectRoyalShirt:(id)selector { [self setShirtColor:@"royal_shirt"]; }
-(IBAction)selectSilverShirt:(id)selector { [self setShirtColor:@"silver_shirt"]; }
-(IBAction)selectTurqShirt:(id)selector { [self setShirtColor:@"turq_shirt"]; }

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

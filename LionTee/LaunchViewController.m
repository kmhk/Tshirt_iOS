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
    
    [super viewDidLoad];
    
    printType = BASIC_TSHIRT_TYPE;
    tshirtType = MENS_CREWNECK;
    
    printCheckboxes = [NSArray arrayWithObjects:basicTshirtButton,alloverTshirtButton, nil];
    
    tshirtCheckboxes = [NSArray arrayWithObjects:kidsCrewneckTshirtButton,mensCrewneckTshirtButton,triBlendVNeckTshirtButton,
                       hoodiePulloverButton,mensTanktopButton,ladiesCrewneckTshirtButton, nil];
    
    basicTshirtButton.selected = YES;
    mensCrewneckTshirtButton.selected = YES;
}

-(IBAction)onPrintCheckboxClicked:(UIButton*)sender
{
    for(UIButton *checkbox in printCheckboxes)
        checkbox.selected = NO;
    
    if(sender.tag == 2){
        printType = ALLOVER_TSHIRT_TYPE;
        alloverTshirtButton.selected = YES;
    }else if(sender.tag == 1){
        printType = BASIC_TSHIRT_TYPE;
        basicTshirtButton.selected = YES;
    }
    
    NSLog(@"onPrintCheckboxClicked – %@ – %ld",printType,(long)sender.tag);
}

-(IBAction)onCheckboxClicked:(UIButton*)sender
{
    for(UIButton *checkbox in tshirtCheckboxes)
        checkbox.selected = NO;
    
    if(sender.tag == 10){
        tshirtType = KIDS_CREWNECK;
        kidsCrewneckTshirtButton.selected = YES;
    }else if(sender.tag == 11){
        tshirtType = MENS_CREWNECK;
        mensCrewneckTshirtButton.selected = YES;
    }else if(sender.tag == 12){
        tshirtType = TRI_BLEND_VNECK;
        triBlendVNeckTshirtButton.selected = YES;
    }else if(sender.tag == 13){
        tshirtType = MENS_TANKTOP;
        mensTanktopButton.selected = YES;
    }else if(sender.tag == 14){
        tshirtType = HOODIE_PULLOVER;
        hoodiePulloverButton.selected = YES;
    }else if(sender.tag == 15){
        tshirtType = LADIES_CREWNECK;
        ladiesCrewneckTshirtButton.selected = YES;
    }
    
    NSLog(@"onCheckboxClicked – %@ – %ld",tshirtType,(long)sender.tag);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

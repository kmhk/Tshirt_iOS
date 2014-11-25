//
//  LaunchViewController.h
//  LionTee
//
//  Created by wang on 11/11/14.
//  Copyright (c) 2014 Bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaunchViewController : UIViewController<UIScrollViewDelegate>

{
    
    IBOutlet UIView * basicTshirt;
    IBOutlet UIButton * basicTshirtButton;
    
    IBOutlet UIView * alloverTshirt;
    IBOutlet UIButton * alloverTshirtButton;
    
    IBOutlet UIView * kidsCrewneckTshirt;
    IBOutlet UIButton * kidsCrewneckTshirtButton;
    
    IBOutlet UIView * mensCrewneckTshirt;
    IBOutlet UIButton * mensCrewneckTshirtButton;
    
    IBOutlet UIView * triBlendVNeckTshirt;
    IBOutlet UIButton * triBlendVNeckTshirtButton;
    
    IBOutlet UIView * hoodiePullover;
    IBOutlet UIButton * hoodiePulloverButton;
    
    IBOutlet UIView * mensTanktop;
    IBOutlet UIButton * mensTanktopButton;
    
    IBOutlet UIView * ladiesCrewneckTshirt;
    IBOutlet UIButton * ladiesCrewneckTshirtButton;
    
    NSString *printType;
    NSString *tshirtType;
    
    NSArray *printCheckboxes;
    NSArray *tshirtCheckboxes;
}

-(IBAction)onPrintCheckboxClicked:(id)sender;
-(IBAction)onCheckboxClicked:(id)sender;
@end

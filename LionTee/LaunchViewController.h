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
    
    IBOutlet UIScrollView * scrollView;
    IBOutlet UIButton * basicButton;
    IBOutlet UIButton * allOverButton;
    
    IBOutlet UIPageControl * pageController;
    
    NSUInteger currentPage;
    
    
}

-(IBAction)onBasic:(id)sender;
-(IBAction)onAllOver:(id)sender;
@end

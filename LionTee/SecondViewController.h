//
//  SecondViewController.h
//  LionTee
//
//  Created by iii on 27/11/14.
//  Copyright (c) 2014 Bai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectShapeViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+tintImage.h"

@interface SecondViewController : UIViewController
<
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
//InfColorPickerControllerDelegate,
UITextFieldDelegate,
//MovableLabelDelegate,
//MovableImageViewDelegate,
//PKPaymentAuthorizationViewControllerDelegate,
//ARFontPickerViewControllerDelegate,
UIScrollViewDelegate,
UIAlertViewDelegate,
//MBProgressHUDDelegate,
UIActionSheetDelegate,
UIPickerViewDataSource,
UIPickerViewDelegate,
SelectShapeDelegate
>{
    IBOutlet UIImageView *frontImage;
    IBOutlet UIImageView *backImage;
    IBOutlet UIScrollView *imagesScrollView;
    
    IBOutlet UIButton * fontPanelButton;
    IBOutlet UIButton * colorPanelButton;
    IBOutlet UIButton * removePanelButton;
    
    IBOutlet UISlider *fontSizeHorizontalSlider;
    
    NSInteger   _index;
    NSInteger   _colorIndex;
    IBOutlet UIPageControl  *_page;
}


-(void) clickPayButton:(id)sender;

@end

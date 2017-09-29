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
#import "MovableLabel.h"
#import "MovableImageView.h"
#import  "InfColorPicker.h"
#import  "ARFontPickerViewController.h"
#import "EditTextController.h"
#import "SelectShapeViewController.h"
#import "CheckoutViewController.h"


#import "BRRequestListDirectory.h"
#import "BRRequestCreateDirectory.h"
#import "BRRequestUpload.h"
#import "BRRequestDownload.h"
#import "BRRequestDelete.h"
#import "BRRequest+_UserData.h"

#import "MBProgressHUD.h"
@interface SecondViewController : UIViewController
<
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
InfColorPickerControllerDelegate,
UITextFieldDelegate,
MovableLabelDelegate,
MovableImageViewDelegate,
//PKPaymentAuthorizationViewControllerDelegate,
ARFontPickerViewControllerDelegate,
UIScrollViewDelegate,
UIAlertViewDelegate,
MBProgressHUDDelegate,
UIActionSheetDelegate,
UIPickerViewDataSource,
UIPickerViewDelegate,
SelectShapeDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
EditTextDelegate,
CheckOutDelegate,
BRRequestDelegate
>
{
    IBOutlet UIImageView *frontImage;
    IBOutlet UIImageView *backImage;
    IBOutlet UIScrollView *imagesScrollView;
    
    UIButton * priceButton;
    
    //Tab Bar Buttons
    IBOutlet UIButton * shapeButton;
    IBOutlet UIButton * shirtColorButton;
    
    IBOutlet UIView * addTextPanel;
    IBOutlet UIButton * fontPanelButton;
    IBOutlet UIButton * colorPanelButton;
    IBOutlet UIButton * removePanelButton;
    IBOutlet UISlider *fontSizeHorizontalSlider;
    
    
    
    NSInteger   _index;
    NSInteger   _colorIndex;
    IBOutlet UIPageControl  *_page;


    
   
    
    MovableLabel * curTextField;

    UIScrollView * frontImageScrollView;
    UIScrollView * backImageScrollView;
    MovableImageView *frontMovImgView;
    MovableImageView *backMovImgView;
     
    
    UIFont * curFont;
    NSString * curText;
    UIColor * curTextColor;
    
    BOOL isAllOverFlag;
    // For Filter
    
    IBOutlet UIView * filterPanel;
  IBOutlet   UICollectionView * filterCollectionView;
    
    IBOutlet UIView * containerView;
    
    NSString * fullAddress;
    
        MBProgressHUD                               *_hudProgress;
    
    // uploading to FTP
    BRRequestCreateDirectory					*_createDirectory;
    
    NSData										*_dataShirt1;
    BRRequestUpload								*_uploadShirt1;
    
    NSData										*_dataShirt2;
    BRRequestUpload								*_uploadShirt2;
    
    NSData										*_dataShirt3;
    BRRequestUpload								*_uploadShirt3;
    
    NSData										*_dataImage1;
    BRRequestUpload								*_uploadImage1;
    
    NSData										*_dataImage2;
    BRRequestUpload								*_uploadImage2;
    
    NSData										*_dataImage3;
    BRRequestUpload								*_uploadImage3;
    
    NSData										*_dataText;
    BRRequestUpload								*_uploadText;
    
   	NSData										*_dataShipping;
    BRRequestUpload								*_uploadShipping;

    NSInteger                                   _countUploading;
    NSInteger                                   _allUploading;
    
    	NSString									*_orderNumber;
    
    NSString  * currentShirtStyle;
    NSArray * currentColorList;
    
    UIView * checkoutView;
}

+(id)sharedSecondController;

-(void) clickPayButton:(id)sender;
-(IBAction)onAddText:(id)sender;
-(IBAction)onAddShape:(id)sender;

- (IBAction)onChangeTextFont:(id)sender;
- (IBAction)onChangeTextColor:(id)sender;
- (IBAction)onChangedFontSizeSlide:(id)sender;
- (IBAction)onRemoveText:(id)sender;

@property (nonatomic, strong)  MovableImageView * currentImageView;



@end

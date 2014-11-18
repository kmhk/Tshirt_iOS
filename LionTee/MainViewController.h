//
//  MainViewController.h
//  LionTee
//
//  Created by baijin on 10/16/14.
//  Copyright (c) 2014 Bai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PassKit/PassKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+tintImage.h"
#import "InfColorPickerController.h"
#import "MovableImageView.h"
#import "MovableLabel.h"
#import "ARFontPickerViewController.h"
#import <AddressBook/AddressBook.h>

#import "UIImage+tintImage.h"

#import <FTPKit/FTPKit.h>

#import "SelectShapeViewController.h"
#import "MBProgressHUD.h"

#import "Stripe.h"
@interface MainViewController : UIViewController
<
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
InfColorPickerControllerDelegate,
UITextFieldDelegate,
MovableLabelDelegate,
MovableImageViewDelegate,
PKPaymentAuthorizationViewControllerDelegate,
ARFontPickerViewControllerDelegate,
UIScrollViewDelegate,
UIAlertViewDelegate,
MBProgressHUDDelegate,
UIActionSheetDelegate,
UIPickerViewDataSource,
UIPickerViewDelegate,
SelectShapeDelegate
>
{
	//IBOutlet UIImageView						*_imgViewTShirt;
	__strong IBOutletCollection(UIImageView) NSArray		*_imgViewShirts;
    NSMutableArray * addImgs;
    
    NSString *myHostname;
    NSString *myUsername;
    NSString *myPassword;
    FTPClient *client;
	
	//UIScrollView								*_scrollViewContainer;
	//MovableImageView							*_lblImgView;
	
	BOOL										_isFullImage;
	
	IBOutletCollection(UIButton) NSArray		*_arrayColorBtn;
	
	IBOutlet UITextField						*_txtTitle;
	IBOutlet UISlider							*_sliderSize;
	
	IBOutlet UISlider							*_sliderImageSize;
	
	NSInteger									_index;
	NSInteger									_colorIndex;
	
	MovableLabel								*_curTextField;
	MovableImageView							*_curImageView;
	
	NSArray										*_ShirtColors;
	
	NSString									*_orderNumber;
	
    NSString                                    *fullAddress;
    NSString                                    *emailAddress;
    NSString                                    *phoneNumber;
    NSString                                    *fullName;
    
    NSInteger                                   _countUploading;
    NSInteger                                   _allUploading;
    
    NSString                                    *addressStringPass;
    
    MBProgressHUD                               *_hudProgress;
	
	IBOutlet UIPageControl						*_page;

    
    NSInteger movableImageViwScale;
    
    // color and Shape Button
    
    IBOutlet UIButton * colorButton;
    IBOutlet UIButton * shapeButton;
    
    
    // BasePriceButton
    
    IBOutlet UIButton * basePriceButton;
    IBOutlet UIButton * payButton;
    
   // IBOutlet UICollectionView * shapeCollection;
//    IBOutlet UIView * shapeTempView;
    
    
    // Size View
    IBOutlet UIView * sizeView;
    IBOutlet UIPickerView * sizePikcerView;
    
    NSArray * sizeArray;
    
    NSString * currentSize ;
    
    // Appel Payment View
    IBOutlet  UILabel * quantityLabel;
//    IBOutlet UILabel * priceLabel;
    IBOutlet UIView * applePayView ;
    
    
    IBOutlet UILabel * sizeLabel;
    
    // Edit Order
    
    IBOutlet UIView *editOrderView;
    IBOutlet UIPickerView * orderPickerView;
    
   // float basePrice ;
    
}

@property (atomic, strong) NSString *myPrice;
+ (void)sharedPrice;

@property (nonatomic, strong) IBOutlet UILabel *priceLabel;

- (IBAction)onAddText:(id)sender;
- (IBAction)onAddColor:(id)sender;
- (IBAction)onTakeImage:(id)sender;
- (IBAction)onSize:(id)sender;
- (IBAction)onPurchase:(id)sender;
- (IBAction)onAddShape:(id)sender;

- (IBAction)onBuyApplepay:(id)sender;
- (IBAction)onEditOrder:(id)sender;

- (void)createBackendChargeWithToken:(STPToken *)token
                          completion:(void (^)(PKPaymentAuthorizationStatus))completion;

- (void)sendShippingTo:(NSString *)shippingAddress;
- (void)onAddImageFromCamera;
- (void)onAddImageFromLibrary;

- (IBAction)onBack:(id)sender;
- (IBAction)onDone:(id)sender;
- (IBAction)onMainBack:(id)sender;
@property (nonatomic, assign) float basePrice;
@property (nonatomic, assign) BOOL isFull_Flag;
@end

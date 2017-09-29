//
//  SecondViewController.m
//  LionTee
//
//  Created by iii on 27/11/14.
//  Copyright (c) 2014 Bai. All rights reserved.
//

#import "SecondViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GPUImage.h"
#import "Stripe.h"
#import "PKPayment+STPTestKeys.h"
#import "CheckoutViewController.h"
#import "MBProgressHUD.h"
#import "LaunchViewController.h"
@interface SecondViewController ()

@end

@implementation SecondViewController

@synthesize currentImageView;

+(id)sharedSecondController
{
    if (!self) {
        return  [[SecondViewController alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // For Filter
        
    AppDelegate* MyAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    _index = 1;
    curText = @"";
    NSString *printType = MyAppDelegate.printType;
    NSString *isAllOver = ALLOVER_TSHIRT_TYPE;
    isAllOverFlag = [printType isEqualToString:isAllOver];
    
    currentShirtStyle = MyAppDelegate.tshirtImageName;
    
    currentColorList = [LaunchViewController sharedShirtColorList:currentShirtStyle];
      
    MyAppDelegate.tshirtColor = [currentColorList objectAtIndex:0];
    
   self.title = MyAppDelegate.tshirtType;
    
    self.navigationController.navigationBar.tintColor = [self.view tintColor];
    
    if (isAllOverFlag) {
        MyAppDelegate.price = 2499;
    }else{
        MyAppDelegate.price = 1799;
    }
    
    float price = MyAppDelegate.price/100.00;
    NSString *priceTitle = [NSString stringWithFormat:@"$%.2f",price];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    [button setTitle:priceTitle forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 60, 30);
    button.layer.borderColor = [self.view tintColor].CGColor;
    button.layer.borderWidth = 1.0f;
    button.layer.cornerRadius = 3;
    button.clipsToBounds = YES;
    
    fontPanelButton.layer.borderColor = [self.view tintColor].CGColor;
    fontPanelButton.layer.borderWidth = 1.0f;
    fontPanelButton.layer.cornerRadius = 3;
    
    colorPanelButton.layer.borderColor = [self.view tintColor].CGColor;
    colorPanelButton.layer.borderWidth = 1.0f;
    colorPanelButton.layer.cornerRadius = 3;
    
    removePanelButton.layer.borderColor = [UIColor redColor].CGColor;
    removePanelButton.layer.borderWidth = 1.0f;
    removePanelButton.layer.cornerRadius = 3;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self action:@selector(clickPayButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    priceButton = button;
    [self setImagesScrollView];
    
    _orderNumber = @"order_LionTee_123456";
    
    
    // about Tab bar
    
    if (isAllOverFlag) {
        [shapeButton setBackgroundImage:[UIImage imageNamed:@"star-icon_disable"] forState:UIControlStateNormal];
        [shapeButton setUserInteractionEnabled:NO];
        
        [shirtColorButton setBackgroundImage:[UIImage imageNamed:@"color-icon_disable"] forState:UIControlStateNormal];
        [shirtColorButton setUserInteractionEnabled:NO];
    }
    
    addTextPanel.frame = CGRectMake(0, containerView.frame.size.height, addTextPanel.frame.size.width, addTextPanel.frame.size.height);
}


-(void)viewWillAppear:(BOOL)animated
{
    
     AppDelegate* MyAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
//    self.navigationItem.title = MyAppDelegate.tshirtType;
   self.navigationController.navigationBar.tintColor = [self.view tintColor];
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    NSString *frontImageName = [NSString stringWithFormat:@"%@_%@_front.png",MyAppDelegate.tshirtColor, MyAppDelegate.tshirtImageName];
    [frontImage setImage:[UIImage imageNamed:frontImageName]];
    
    NSString *backImageName = [NSString stringWithFormat:@"%@_%@_back.png",MyAppDelegate.tshirtColor,MyAppDelegate.tshirtImageName];
    [backImage setImage:[UIImage imageNamed:backImageName]];
    
    
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)setImagesScrollView
{
    imagesScrollView.contentSize = CGSizeMake(imagesScrollView.frame.size.width * 2, imagesScrollView.frame.size.height);
    imagesScrollView.scrollEnabled = NO;
    
    frontImage.frame = CGRectMake(0, 0, imagesScrollView.frame.size.width, imagesScrollView.frame.size.height);
    backImage.frame = CGRectMake(imagesScrollView.frame.size.width, 0, imagesScrollView.frame.size.width, imagesScrollView.frame.size.height);
    
    UISwipeGestureRecognizer *gestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipShirtRight:)];
    gestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [imagesScrollView addGestureRecognizer:gestureLeft];
    
    UISwipeGestureRecognizer *gestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipShirtLeft:)];
    gestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    [imagesScrollView addGestureRecognizer:gestureRight];
    
    CGRect rect ;
    
    if(isAllOverFlag)
    {
        rect =  CGRectMake(0, 0, frontImage.frame.size.width, frontImage.frame.size.height);

    }else{
         rect = CGRectMake(frontImage.frame.size.width/6, frontImage.frame.size.height/6, backImage.frame.size.width * 2 / 3, backImage.frame.size.height * 5 /6);
    }
        
     frontImageScrollView  = [[UIScrollView alloc] initWithFrame:rect];
    [frontImage addSubview:frontImageScrollView];
    [frontImage setUserInteractionEnabled:YES];
    [frontImageScrollView setUserInteractionEnabled:YES];
    [frontImageScrollView setTag:100];

   
    backImageScrollView = [[UIScrollView alloc] initWithFrame:rect];
    [backImage addSubview:backImageScrollView];
    [backImage setUserInteractionEnabled:YES];
    [backImageScrollView setUserInteractionEnabled:YES];
    [backImageScrollView setTag:100];
    
    imagesScrollView.contentOffset = CGPointMake(0, 64);


    frontMovImgView = [[MovableImageView alloc] initWithFrame:CGRectZero];
    [frontMovImgView setContentMode:UIViewContentModeScaleAspectFill];
    frontMovImgView.delegate = self;
    frontMovImgView.userInteractionEnabled = YES;
    [frontMovImgView setTag:200];
    [frontMovImgView setHidden:YES];
    [frontImageScrollView addSubview:frontMovImgView];
    frontMovImgView.isMovalbleFlag = !isAllOverFlag;
    
    backMovImgView = [[MovableImageView alloc] initWithFrame:CGRectZero];
    [backMovImgView setContentMode:UIViewContentModeScaleAspectFill];
    backMovImgView.delegate = self;
    backMovImgView.userInteractionEnabled = YES;
    [backMovImgView setTag:200];
    [backMovImgView setHidden:YES];
    [backImageScrollView addSubview:backMovImgView];
    backMovImgView.isMovalbleFlag = !isAllOverFlag;
    
}

-(void) clickPayButton:(id)sender{
    NSLog(@"Click pay button clicked");
    [self performSegueWithIdentifier:@"checkoutSegue" sender:self];
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


-(void)viewWillDisappear:(BOOL)animated
{
    // self.title = @"Back";
}
-(IBAction)onTakeImage:(id)sender
{
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Take a Photo", @"Photo Library" ,nil];
    
    [actionSheet showInView:self.view];
}

- (void)onAddImageFromCamera
{
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.videoQuality = UIImagePickerControllerQualityTypeLow;
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //    pickerController.sourceType = uiimagepi
    pickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
    pickerController.allowsEditing = NO;
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];
}


- (void)onAddImageFromLibrary
{
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
    pickerController.allowsEditing = NO;
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];
    
}

#pragma mark - UIActionSheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0) {
        [self onAddImageFromCamera];
    }else if (buttonIndex == 1)
    {
        [self onAddImageFromLibrary];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];

    
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        if (!img) {
            img = [info objectForKey:UIImagePickerControllerOriginalImage];
        }

        if (_index == 1) {
            currentImageView = frontMovImgView;
        }else if(_index == 2)
        {
            currentImageView = backMovImgView;
        }
        
        currentImageView.originalImag = img;
        currentImageView.filterNumber = 0;
        
        if (!isAllOverFlag) {

            [currentImageView setHidden:NO];
            currentImageView.image = img;
            currentImageView.frame = CGRectMake(frontImageScrollView.frame.size.width/3, frontImageScrollView.frame.size.height / 3,  img.size.width / 6, img.size.height / 6);
            
        } else {
            
                AppDelegate* MyAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//                NSString *name = [NSString stringWithFormat:@"%@%ld.png", MyAppDelegate.tshirtColor, (long)_index+1];
            
            NSString * name ;
            if(_index == 1)
            {
                name = [NSString stringWithFormat:@"%@_front_mask.png",MyAppDelegate.tshirtImageName];
           
            }else if(_index == 2)
            {
            
                MyAppDelegate.price = MyAppDelegate.price + 500;
                
                NSString * pricetitle = [NSString stringWithFormat:@"%.2f",MyAppDelegate.price/100.0f];
                [priceButton setTitle:pricetitle forState:UIControlStateNormal];
                name = [NSString stringWithFormat:@"%@_back_mask.png",MyAppDelegate.tshirtImageName];
            }
            
                UIImage *imgOrigin = [UIImage imageNamed:name];
                UIImage * tempImage = [imgOrigin imageWithMappingImage:img];
                NSLog(@"HERE %@",name);
            
            UIImageView * tempImageView;
            if (_index == 1) {
                tempImageView = frontImage;
                
            }else if(_index ==2)
            {
                tempImageView = backImage;
            }
            
            tempImageView.image = tempImage;
            currentImageView.originalImag = tempImage;
            CGRect rect = CGRectMake(0, 0, tempImageView.frame.size.width, tempImageView.frame.size.height);
            currentImageView.image = tempImage;
            [currentImageView setHidden:NO];
            [currentImageView setFrame:rect];
            
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self showImageEditView];
    
}

///    Movalbele ImageView Delegate


-(void)setCurrentImageView:(MovableImageView *)imgView
{
    currentImageView = imgView;
    [self showImageEditView];
    [self onTakeImage:nil];
}

-(void)showCurrentImageView:(MovableImageView *)imgView
{
    currentImageView = imgView;
    [self showImageEditView];
}


- (void)showImageEditView
{
    [filterCollectionView reloadData];
        
    [UIView animateWithDuration:0.3
                     animations:^{
                         addTextPanel.frame = CGRectMake(0, containerView.frame.size.height, addTextPanel.frame.size.width, addTextPanel.frame.size.height);
                         filterPanel.frame = CGRectMake(0, containerView.frame.size.height - filterPanel.frame.size.height, filterPanel.frame.size.width, filterPanel.frame.size.height);
                     } completion:^(BOOL finished) {
                         
                     }];
}

#pragma mark - Gesture actions

- (void)onSwipShirtLeft:(id)sender
{
    _index --;
    if (_index < 1) {
        _index = 1;
    }
    
    _page.currentPage = _index - 1;
    [imagesScrollView setContentOffset:CGPointMake(imagesScrollView.frame.size.width * (_index - 1), 0) animated:YES];
}

- (void)onSwipShirtRight:(id)sender
{
    _index ++;
    if (_index > 2) {
        _index = 2;
    }
    
    _page.currentPage = _index - 1;
    [imagesScrollView setContentOffset:CGPointMake(imagesScrollView.frame.size.width * (_index - 1), 0) animated:YES];
}



///   Adding Text
- (IBAction)onAddText:(id)sender
{
    NSString *string = @"Hello";
    
    curText = string;
    
    UIFont *font = [UIFont systemFontOfSize:30];
    curFont = font;
    CGSize sz = [string sizeWithAttributes:@{NSFontAttributeName:font}];
    
    UIScrollView *scrollContainer;
    if (_index == 1 ) {
        scrollContainer = frontImageScrollView;
    }else if (_index == 2)
    {
        scrollContainer = backImageScrollView;
    }
    
   CGFloat x = (scrollContainer.frame.size.width - sz.width)/2.0f;
   CGFloat y = (scrollContainer.frame.size.height - sz.height)/3.0f;
    
    curTextField = [[MovableLabel alloc] initWithFrame:CGRectZero];
    [scrollContainer addSubview:curTextField];
    curTextField.userInteractionEnabled = YES;
    curTextField.delegate = self;

    curTextField.font = font;
    curTextField.text = string;
    curTextField.frame = CGRectMake(x, y, sz.width, sz.height);
    
    [self showTextEditView];
}


- (void)showTextEditView
{
    if (curTextField) {
        curText = curTextField.text;
        curTextColor = curTextField.textColor;
        curFont = curTextField.font;
        fontSizeHorizontalSlider.value = curTextField.font.pointSize;
    }
   
   
    [UIView animateWithDuration:0.3
                     animations:^{
                         addTextPanel.frame = CGRectMake(0, containerView.frame.size.height - addTextPanel.frame.size.height, addTextPanel.frame.size.width, addTextPanel.frame.size.height);
                         filterPanel.frame = CGRectMake(0, containerView.frame.size.height, filterPanel.frame.size.width, filterPanel.frame.size.height);
                     } completion:^(BOOL finished) {
                         
    }];
    
}


/////////////           Movable Label Delegate

-(void)setCurrentTextLabel:(MovableLabel *)label
{
    curTextField = label;
    [self showTextEditView];
    EditTextController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"EditTextController"];
    controller.delegate = self;
    controller.currentText = curTextField.text;
    
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)showCurrentTextLabel:(MovableLabel *)label
{
    curTextField = label;
    [self showTextEditView];
}


-(void)onEditTextFinish:(NSString *)str
{
    curText = str;
    curTextField.text = curText;
    [self changeLabelWithFont:curFont];
}

- (IBAction)onChangedFontSizeSlide:(id)sender
{
    if (curTextField) {
        UIFont *font = [UIFont fontWithName:[curFont fontName] size:fontSizeHorizontalSlider.value];

        [self changeLabelWithFont:font];
    }
}

- (IBAction)onChangeTextColor:(id)sender
{
   InfColorPickerController* picker = [InfColorPickerController colorPickerViewController];
    picker.delegate = self;
   
    [picker presentModallyOverViewController: self];
}

- (IBAction)onChangeTextFont:(id)sender
{
    ARFontPickerViewController *fontPicker = [[ARFontPickerViewController alloc] init];
    fontPicker.delegate = self;
    [self presentViewController:fontPicker animated:YES completion:nil];
}

- (IBAction)onRemoveText:(id)sender
{
    if (curTextField) {
        [curTextField removeFromSuperview];
    }
}

#pragma mark - InfColorPicker delegate

- (void) colorPickerControllerDidFinish: (InfColorPickerController*) picker
{
    if (curTextField) {
        [curTextField setTextColor:picker.resultColor];
        curTextColor = picker.resultColor;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ARFontPicker delegate

-(void)fontPickerViewController:(ARFontPickerViewController *)fontPicker didSelectFont:(NSString *)fontName
{
    [fontPicker dismissViewControllerAnimated:YES completion:nil];
    
    UIFont *font = [UIFont fontWithName:fontName size:fontSizeHorizontalSlider.value];
    [self changeLabelWithFont:font];
}


-(void)changeLabelWithFont:(UIFont *)font
{
    if (curTextField) {
        
        curFont = font;
        CGSize sz = [curText sizeWithAttributes:@{NSFontAttributeName:curFont}];
        
        UIScrollView *scrollContainer;
        if (index == 0 ) {
            scrollContainer = frontImageScrollView;
        }else
        {
            scrollContainer = backImageScrollView;
        }
        
        CGFloat limitWidth = scrollContainer.frame.size.width * 2 / 3;
        
        NSUInteger rowCount = ((int)sz.width)/ ((int)limitWidth) + 1;
        
        if (rowCount != 1) {
            sz.width = limitWidth;
        }
        
        CGFloat x, y ;
//        if (isAddFlag) {
//             x = (scrollContainer.frame.size.width - sz.width)/2.0f;
//             y = (scrollContainer.frame.size.height - sz.height * rowCount)/3.0f;
//        }else{
            x = curTextField.frame.origin.x;
            y = curTextField.frame.origin.y;
    //    }
        
        curTextField.font = curFont;
        curTextField.frame = CGRectMake(x, y, sz.width, sz.height * rowCount);
    }
}


// UICollection View Delegate



-(void)setCategoryEffect:(NSInteger)index forImageView:(UIImageView *)tempImageView forImage:(UIImage *)image forFlag:(BOOL)isCategory
{
    UIImage *filteredimage;
    NSString *filename =[NSString stringWithFormat:@"lookup_filter%ld.png",index];
    
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    
    GPUImagePicture *lookupImageSource = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:filename]];
    GPUImageLookupFilter *lookupFilter = [[GPUImageLookupFilter alloc] init];
    [stillImageSource addTarget:lookupFilter];
    [lookupImageSource addTarget:lookupFilter];
    [lookupFilter useNextFrameForImageCapture];
    [stillImageSource processImage];
    [lookupImageSource processImage];
    
    filteredimage = [lookupFilter imageFromCurrentFramebuffer];
    filteredimage =[[UIImage alloc] initWithCGImage:filteredimage.CGImage scale:filteredimage.scale orientation:image.imageOrientation];
    if (isCategory) {
        
    }
    [tempImageView setImage:filteredimage];
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSIndexPath * beforeIndexPath  = [NSIndexPath indexPathForRow:currentImageView.filterNumber inSection:0];
    currentImageView.filterNumber = indexPath.row;
    UICollectionViewCell * beforeCell = [filterCollectionView cellForItemAtIndexPath:beforeIndexPath];
    UICollectionViewCell * selectedCell = [filterCollectionView cellForItemAtIndexPath:indexPath];
    UIImageView * beforePreviewImageView = (UIImageView *) [beforeCell.contentView viewWithTag:456];
    [beforePreviewImageView setImage:[UIImage imageNamed:@"circle_nonactive"]];
    
    UIImageView * selectedPreviewImageView = (UIImageView *) [selectedCell.contentView viewWithTag:456];
    [selectedPreviewImageView setImage:[UIImage imageNamed:@"circle_active"]];
    
    if (indexPath.row == 0) {
        currentImageView.image = currentImageView.originalImag;
    }else{
        [self setCategoryEffect:indexPath.row forImageView:currentImageView forImage:currentImageView.originalImag forFlag:YES];
    }
    
    
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imagefilterCell" forIndexPath:indexPath];
    
    UIImageView *styleImageView = (UIImageView *)[cell.contentView viewWithTag:455];
    UIImageView *circleImageView = (UIImageView *)[cell.contentView viewWithTag:456];
    
    UIImage * circleImage ;
    
    if (currentImageView.filterNumber == indexPath.row) {
        circleImage = [UIImage imageNamed:@"circle_active"];
    }else{
        circleImage = [UIImage imageNamed:@"circle_nonactive"];
    }
    
    [circleImageView setImage:circleImage];
    
    UIImage *styleImage = currentImageView.originalImag;
    [styleImageView setImage:styleImage];
    if (indexPath.row == 0) {

    }else{
        [self setCategoryEffect:indexPath.row forImageView:styleImageView forImage:styleImage forFlag:NO];
    }
    
    return  cell;
    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(currentImageView.originalImag == nil || currentImageView == nil)
    {
        return 0;
    }
    
    return 13;
}



-(void)setFullAddress:(NSString *)address
{
    fullAddress = address;
}

-(void)setCheckOutView:(UIView *)view
{
    checkoutView = view;
}

- (void)createBackendChargeWithToken:(STPToken *)token withTotalPrice:(NSString *)totalPrice    completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    
    
    NSURL *url = [NSURL URLWithString:@"http://liontee.com/ApplePay/applepay.php"];
    
    NSString *removeMoney = [totalPrice stringByReplacingOccurrencesOfString:@"$" withString:@""];
    NSString *finalPrice = [removeMoney stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSString *end = [NSString stringWithFormat:@"stripeToken=%@", token.tokenId];
    NSString *begin = [NSString stringWithFormat:@"%@&stripePrice=%@", end, finalPrice];
//    NSString *desc = [NSString stringWithFormat:@"%@&stripeDesc=%@", begin, emailAddress];
    NSString *strings = [NSString stringWithFormat:@"%@?%@", url, begin];
    NSURL *newURL = [NSURL URLWithString:strings];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:newURL];
    request.HTTPMethod = @"POST";
    NSLog(@"New URL: %@", newURL);
    
    MBProgressHUD * hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Uploading";
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               if (error) {
                                   UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                                                     message:@"Please Try Again!"
                                                                                    delegate:nil
                                                                           cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                                           otherButtonTitles:nil];
                                   [message show];
                                   completion(PKPaymentAuthorizationStatusFailure);
                                   
                               } else {
                                   
                                   completion(PKPaymentAuthorizationStatusSuccess);                             NSLog(@"Created: %@", token.tokenId);
                                   [self createDirectoryToFtp];
                                   AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                               }
                               
                           }];
}

///   Uploading T-Shirt Images

#pragma mark - send Image to FTP

- (void)createDirectoryToFtp
{
    _countUploading = 1;
    _allUploading = 1;
    //ShowWaitView(YES, self.view);
    
    NSDate *date = [NSDate date];
    _orderNumber = [NSString stringWithFormat:@"order_lionshirt_%f", date.timeIntervalSince1970];
    
    _createDirectory = [[BRRequestCreateDirectory alloc] initWithDelegate:self];
    _createDirectory.path = [NSString stringWithFormat:@"/%@/", _orderNumber];
    _createDirectory.hostname = @"ftp.ipmapp.com";
    _createDirectory.username = @"nicoleaza";
    _createDirectory.password = @"Nicoleaza1!";
    [_createDirectory start];
}

- (void)sendRefImage:(MovableImageView *)imgRef index:(NSInteger)index title:(NSString *)title
{
    NSData *data = UIImagePNGRepresentation(imgRef.image);
    if (!data) {
        return;
    }
    
    _countUploading ++;
    _allUploading ++;
    
    NSString *path = [NSString stringWithFormat:@"/%@/%@", _orderNumber, title];
    
    switch (index) {
        case 0:
        {
            _dataShirt1 = [[NSData alloc] initWithData:data];
            _uploadShirt1 = [[BRRequestUpload alloc] initWithDelegate:self];
            
            //----- for anonymous login just leave the username and password nil
            _uploadShirt1.path = path;
            _uploadShirt1.hostname = @"ftp.ipmapp.com";
            _uploadShirt1.username = @"nicoleaza";
            _uploadShirt1.password = @"Nicoleaza1!";
            
            //----- we start the request
            [_uploadShirt1 start];
        }
            break;
            
        case 1:
        {
            _dataImage1 = [[NSData alloc] initWithData:data];
            _uploadImage1 = [[BRRequestUpload alloc] initWithDelegate:self];
            
            //----- for anonymous login just leave the username and password nil
            _uploadImage1.path = path;
            _uploadImage1.hostname = @"ftp.ipmapp.com";
            _uploadImage1.username = @"nicoleaza";
            _uploadImage1.password = @"Nicoleaza1!";
            
            //----- we start the request
            [_uploadImage1 start];
        }
            break;
            
        case 2:
        {
            _dataShirt2 = [[NSData alloc] initWithData:data];
            _uploadShirt2 = [[BRRequestUpload alloc] initWithDelegate:self];
            
            //----- for anonymous login just leave the username and password nil
            _uploadShirt2.path = path;
            _uploadShirt2.hostname = @"ftp.ipmapp.com";
            _uploadShirt2.username = @"nicoleaza";
            _uploadShirt2.password = @"Nicoleaza1!";
            
            //----- we start the request
            [_uploadShirt2 start];
        }
            break;
            
        case 3:
        {
            _dataImage2 = [[NSData alloc] initWithData:data];
            _uploadImage2 = [[BRRequestUpload alloc] initWithDelegate:self];
            
            //----- for anonymous login just leave the username and password nil
            _uploadImage2.path = path;
            _uploadImage2.hostname = @"ftp.ipmapp.com";
            _uploadImage2.username = @"nicoleaza";
            _uploadImage2.password = @"Nicoleaza1!";
            
            //----- we start the request
            [_uploadImage2 start];
        }
            break;
            
        case 4:
        {
            _dataShirt3 = [[NSData alloc] initWithData:data];
            _uploadShirt3 = [[BRRequestUpload alloc] initWithDelegate:self];
            
            //----- for anonymous login just leave the username and password nil
            _uploadShirt3.path = path;
            _uploadShirt3.hostname = @"ftp.ipmapp.com";
            _uploadShirt3.username = @"nicoleaza";
            _uploadShirt3.password = @"Nicoleaza1!";
            
            //----- we start the request
            [_uploadShirt3 start];
        }
            break;
            
        case 5:
        {
            _dataImage3 = [[NSData alloc] initWithData:data];
            _uploadImage3 = [[BRRequestUpload alloc] initWithDelegate:self];
            
            //----- for anonymous login just leave the username and password nil
            _uploadImage3.path = path;
            _uploadImage3.hostname = @"ftp.ipmapp.com";
            _uploadImage3.username = @"nicoleaza";
            _uploadImage3.password = @"Nicoleaza1!";
            
            //----- we start the request
            [_uploadImage3 start];
        }
            break;
    }
}

- (void)sendShirtImage:(UIImageView *)imgShirt index:(NSInteger)index title:(NSString *)title
{
    UIGraphicsBeginImageContext(imgShirt.bounds.size);
    CGContextRef imageContext = UIGraphicsGetCurrentContext();
    
    [imgShirt.layer renderInContext: imageContext];
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    NSData *data = UIImagePNGRepresentation(viewImage);
    if (!data) {
        return;
    }
    
    _countUploading ++;
    _allUploading ++;
    
    NSString *path = [NSString stringWithFormat:@"/%@/%@", _orderNumber, title];
    
    switch (index) {
        case 0:
        {
            _dataShirt1 = [[NSData alloc] initWithData:data];
            _uploadShirt1 = [[BRRequestUpload alloc] initWithDelegate:self];
            
            //----- for anonymous login just leave the username and password nil
            _uploadShirt1.path = path;
            _uploadShirt1.hostname = @"ftp.ipmapp.com";
            _uploadShirt1.username = @"nicoleaza";
            _uploadShirt1.password = @"Nicoleaza1!";
            
            //----- we start the request
            [_uploadShirt1 start];
        }
            break;
            
        case 1:
        {
            _dataImage1 = [[NSData alloc] initWithData:data];
            _uploadImage1 = [[BRRequestUpload alloc] initWithDelegate:self];
            
            //----- for anonymous login just leave the username and password nil
            _uploadImage1.path = path;
            _uploadImage1.hostname = @"ftp.ipmapp.com";
            _uploadImage1.username = @"nicoleaza";
            _uploadImage1.password = @"Nicoleaza1!";
            
            //----- we start the request
            [_uploadImage1 start];
        }
            break;
            
        case 2:
        {
            _dataShirt2 = [[NSData alloc] initWithData:data];
            _uploadShirt2 = [[BRRequestUpload alloc] initWithDelegate:self];
            
            //----- for anonymous login just leave the username and password nil
            _uploadShirt2.path = path;
            _uploadShirt2.hostname = @"ftp.ipmapp.com";
            _uploadShirt2.username = @"nicoleaza";
            _uploadShirt2.password = @"Nicoleaza1!";
            
            //----- we start the request
            [_uploadShirt2 start];
        }
            break;
            
        case 3:
        {
            _dataImage2 = [[NSData alloc] initWithData:data];
            _uploadImage2 = [[BRRequestUpload alloc] initWithDelegate:self];
            
            //----- for anonymous login just leave the username and password nil
            _uploadImage2.path = path;
            _uploadImage2.hostname = @"ftp.ipmapp.com";
            _uploadImage2.username = @"nicoleaza";
            _uploadImage2.password = @"Nicoleaza1!";
            
            //----- we start the request
            [_uploadImage2 start];
        }
            break;
            
        case 4:
        {
            _dataShirt3 = [[NSData alloc] initWithData:data];
            _uploadShirt3 = [[BRRequestUpload alloc] initWithDelegate:self];
            
            //----- for anonymous login just leave the username and password nil
            _uploadShirt3.path = path;
            _uploadShirt3.hostname = @"ftp.ipmapp.com";
            _uploadShirt3.username = @"nicoleaza";
            _uploadShirt3.password = @"Nicoleaza1!";
            
            //----- we start the request
            [_uploadShirt3 start];
        }
            break;
            
        case 5:
        {
            _dataImage3 = [[NSData alloc] initWithData:data];
            _uploadImage3 = [[BRRequestUpload alloc] initWithDelegate:self];
            
            //----- for anonymous login just leave the username and password nil
            _uploadImage3.path = path;
            _uploadImage3.hostname = @"ftp.ipmapp.com";
            _uploadImage3.username = @"nicoleaza";
            _uploadImage3.password = @"Nicoleaza1!";
            
            //----- we start the request
            [_uploadImage3 start];
        }
            break;
    }
}

- (void)sendStringToFTP
{
    NSMutableData *data = [NSMutableData data];
    
    for (NSInteger i = 0; i < 2; i ++) {
        UIImageView *imgView;
        if (i == 0) {
            imgView = frontImage;
        }else
        {
            imgView = backImage;
        }
        
        UIScrollView *container = (UIScrollView *)[imgView viewWithTag:100];
        
        for (UIView *lblText in container.subviews) {
            if ([lblText class] == [MovableLabel class]) {
                [data appendData:[((MovableLabel *)lblText).text dataUsingEncoding:NSUTF8StringEncoding]];
                [data appendData:[@"\n\t" dataUsingEncoding:NSUTF8StringEncoding]];
                [data appendData:[((MovableLabel *)lblText).font.fontName dataUsingEncoding:NSUTF8StringEncoding]];
                [data appendData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
    }
    if (![data length]) {
        return;
    }
    
    _countUploading ++;
    _allUploading ++;
    
    _dataText = [[NSData alloc] initWithData:data];
    
    _uploadText = [[BRRequestUpload alloc] initWithDelegate:self];
    
    NSString *path = [NSString stringWithFormat:@"/%@/%@", _orderNumber, @"text.txt"];
    
    //----- for anonymous login just leave the username and password nil
    _uploadText.path = path;
    _uploadText.hostname = @"ftp.ipmapp.com";
    _uploadText.username = @"nicoleaza";
    _uploadText.password = @"Nicoleaza1!";
    
    //----- we start the request
    [_uploadText start];
}

- (void)sendShippingTo:(NSString *)shippingAddress
{
    _countUploading ++;
    _allUploading ++;
    
    NSMutableData *data = [NSMutableData data];
    
    [data appendData:[shippingAddress dataUsingEncoding:NSUTF8StringEncoding]];
    
    _dataShipping = [[NSData alloc] initWithData:data];
    
    _uploadShipping = [[BRRequestUpload alloc] initWithDelegate:self];
    
    NSString *path = [NSString stringWithFormat:@"/%@/%@", _orderNumber, @"shippingAddress.txt"];
    
    //----- for anonymous login just leave the username and password nil
    _uploadShipping.path = path;
    _uploadShipping.hostname = @"ftp.ipmapp.com";
    _uploadShipping.username = @"nicoleaza";
    _uploadShipping.password = @"Nicoleaza1!";
    
    //    NSLog(@"Data: %@", _dataShipping);
    
    //----- we start the request
    [_uploadShipping start];
    
}

- (void)sendShippingString:(NSString *)shippingString
{
    _countUploading ++;
    _allUploading ++;
    
    NSMutableData *data = [NSMutableData data];
    
    [data appendData:[shippingString dataUsingEncoding:NSUTF8StringEncoding]];
    
    _dataShipping = [[NSData alloc] initWithData:data];
    
    _uploadShipping = [[BRRequestUpload alloc] initWithDelegate:self];
    
    NSString *path = [NSString stringWithFormat:@"/%@/%@", _orderNumber, @"shippingAddress.txt"];
    
    //----- for anonymous login just leave the username and password nil
    _uploadShipping.path = path;
    _uploadShipping.hostname = @"ftp.ipmapp.com";
    _uploadShipping.username = @"nicoleaza";
    _uploadShipping.password = @"Nicoleaza1!";
    
    //    NSLog(@"Data: %@", _dataShipping);
    
    //----- we start the request
    [_uploadShipping start];
    
}

- (void)uploadAllDataToFTP
{
    [UIView animateWithDuration:1.0
                     animations:^{
                         [self.view setAlpha:0.5];
                         
                     } completion:^(BOOL finished) {
                         [self.view setAlpha:1.0];
                         
                         for (NSInteger i = 0; i < 2; i ++) {
                              UIImageView *imgView;
                             if (i == 0) {
                                 imgView = frontImage;
                             }else{
                                 imgView = backImage;
                             }
                            
                             UIScrollView *container = (UIScrollView *)[imgView viewWithTag:100];
                             MovableImageView *imgRef = (MovableImageView *)[container viewWithTag:200];
                             
                             if (i == 0) {
                                 [self sendShirtImage:imgView index:0 title:@"shirt_front.png"];
                                 [self sendRefImage:imgRef index:1 title:@"front_ref.png"];
                                 
                             } else if (i == 1) {
                                 [self sendShirtImage:imgView index:2 title:@"shirt_back.png"];
                                 [self sendRefImage:imgRef index:3 title:@"back_ref.png"];
                                 
                             } else {
                                 [self sendShirtImage:imgView index:4 title:@"shirt_side.png"];
                                 [self sendRefImage:imgRef index:5 title:@"side_ref.png"];
                             }
                         }
                         
                         [self sendStringToFTP];
//                         NSString *combined = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@",fullName, emailAddress, phoneNumber, fullAddress];
                         NSString *combined = [NSString stringWithFormat:@"%@", fullAddress];
                         
                         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                         NSMutableString *string = [defaults objectForKey:@"STRIPEADDRESS"];
                         
                         if ([combined rangeOfString:@"(null)"].location == NSNotFound) {
                             [self sendShippingTo:combined];
                         } else {
                             [self sendShippingTo:string];
                         }
                         
                         
                         
                     }];
}



#pragma mark - show progress

- (void)onHudProgress
{
    float progress = 0.0;
    while (progress < 1.0) {
        if (!_allUploading) {
            progress = 0.0;
        } else {
            progress = 1.0 / (_allUploading) * (_allUploading - _countUploading);
        }
        _hudProgress.progress = progress;
    }
}

- (void)showWaitView:(BOOL)flag
{
    /*
     _hudProgress = [[MBProgressHUD alloc] initWithView:self.view];
     [self.view addSubview:_hudProgress];
     
     _hudProgress.mode = MBProgressHUDModeAnnularDeterminate;
     
     _hudProgress.delegate = self;
     _hudProgress.labelText = @"Uploading";
     
     [_hudProgress showWhileExecuting:@selector(onHudProgress) onTarget:self withObject:nil animated:YES];
     
     */
    
    _hudProgress = [MBProgressHUD showHUDAddedTo:checkoutView animated:YES];
    [_hudProgress setMode: MBProgressHUDModeAnnularDeterminate];
    _hudProgress.delegate = self;
    _hudProgress.labelText = @"Uploading...";
    [_hudProgress showWhileExecuting:@selector(onHudProgress) onTarget:self withObject:nil animated:YES];
}


#pragma mark - MBProgressHUD delegate

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [_hudProgress removeFromSuperview];
    _hudProgress = nil;
}



#pragma mark - BRRequest delegate implementation

/// requestCompleted
/// Indicates when a request has completed without errors.
/// \param request The request object

- (void)requestCompleted:(BRRequest *)request
{
    if (request == _createDirectory) {
        NSLog(@"folder is created");
        _countUploading = 0;
        _allUploading = 0;
        _createDirectory = nil;
        [self uploadAllDataToFTP];
        
        [self showWaitView:YES];
        
        return;
    }
    
    _countUploading --;
    if (!_countUploading) {
        [_hudProgress hide:YES afterDelay:0.5];
    }
    
    NSLog(@"%@ completed!", request);
}

/// requestFailed
/// \param request The request object
- (void)requestFailed:(BRRequest *)request
{
    if (request == _createDirectory) {
        _createDirectory = nil;
    }
    
    NSLog(@"faile: %@", request.error.message);
}

/// shouldOverwriteFileWithRequest
/// \param request The request object;
- (BOOL)shouldOverwriteFileWithRequest:(BRRequest *)request
{
    return YES;
}

- (long) requestDataSendSize: (BRRequestUpload *) request
{
    //----- user returns the total size of data to send. Used ONLY for percentComplete
    NSLog(@"request size");
    
    if (request == _uploadImage1) {
        return [_dataImage1 length];
        
    } else if (request == _uploadImage2) {
        return [_dataImage1 length];
        
    } else if (request == _uploadImage3) {
        return [_dataImage1 length];
        
    } else if (request == _uploadShirt1) {
        return [_dataShirt1 length];
        
    } else if (request == _uploadShirt2) {
        return [_dataShirt1 length];
        
    } else if (request == _uploadShirt3) {
        return [_dataShirt1 length];
        
    } else if (request == _uploadText) {
        return [_dataText length];
        
    } else if (request == _uploadShipping) {
        return [_dataShipping length];
    }
    
    return 0;
}

- (NSData *)requestDataToSend:(BRRequestUpload *)request
{
    //----- returns data object or nil when complete
    //----- basically, first time we return the pointer to the NSData.
    //----- and BR will upload the data.
    //----- Second time we return nil which means no more data to send
    NSData *temp;
    if (request == _uploadImage1) {
        temp = _dataImage1;
        _dataImage1 = nil;
        
    } else if (request == _uploadImage2) {
        temp = _dataImage2;
        _dataImage2 = nil;
        
    } else if (request == _uploadImage3) {
        temp = _dataImage3;
        _dataImage3 = nil;
        
    } else if (request == _uploadShirt1) {
        temp = _dataShirt1;
        _dataShirt1 = nil;
        
    } else if (request == _uploadShirt2) {
        temp = _dataShirt2;
        _dataShirt2 = nil;
        
    } else if (request == _uploadShirt3) {
        temp = _dataShirt3;
        _dataShirt3 = nil;
        
    } else if (request == _uploadText) {
        temp = _dataText;
        _dataText = nil;
        
    } else if (request == _uploadShipping) {
        temp = _dataShipping;
        _dataShipping = nil;
    }
    
    return temp;
}




-(void)onAddShape:(id)sender
{
      if (currentImageView != nil && currentImageView.originalImag != nil) {
            SelectShapeViewController *controller = (SelectShapeViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SelectShapeViewController"];
            controller.delegate = self;
            controller.originalImage = currentImageView.originalImag;
          [self.navigationController pushViewController:controller animated:YES];
      }else{
          
          UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Failed !"
                                                            message:@"Please Insert  or Select Image ! "
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
          [message show];
      }
}



///   Select Shape Delegate

-(void)shapeEditDone:(UIImage *)image
{
    self.currentImageView.originalImag = [UIImage imageWithCGImage: image.CGImage];
    self.currentImageView.image = image;
    self.currentImageView.frame = CGRectMake(frontImageScrollView.frame.size.width/3, frontImageScrollView.frame.size.height / 3,  image.size.width/2, image.size.height/2);
    [filterCollectionView reloadData];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"checkoutSegue"]) {
        CheckoutViewController *controller = (CheckoutViewController *)segue.destinationViewController;
        controller.delegate = self;
    
    }
}
@end

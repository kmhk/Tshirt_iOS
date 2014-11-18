//
//  MainViewController.m
//  LionTee
//
//  Created by baijin on 10/16/14.
//  Copyright (c) 2014 Bai. All rights reserved.
//

#import "MainViewController.h"
#import "OrderConfirmationViewController.h"
#import "Stripe+ApplePay.h"
#import "PaymentViewController.h"
#import <AVFoundation/AVFoundation.h>



#define YOUR_APPLE_MERCHANT_ID @"merchant.samgabbay.liontee"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize basePrice;
@synthesize isFull_Flag;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIApplication * application = [UIApplication sharedApplication];
    
    //production
    myHostname = @"ftp.ipmapp.com";
    myUsername = @"nicoleaza";
    myPassword = @"Nicoleaza1!";
    
    
    if([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)])
    {
        NSLog(@"Multitasking Supported");
        
        __block UIBackgroundTaskIdentifier background_task;
        background_task = [application beginBackgroundTaskWithExpirationHandler:^ {
            
            //Clean up code. Tell the system that we are done.
            [application endBackgroundTask: background_task];
            background_task = UIBackgroundTaskInvalid;
        }];
        
        __weak MainViewController *weakSelf = self;
        
        //To make the code block asynchronous
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            //### background task starts
            NSLog(@"Running in the background\n");
            BOOL didCreateDirectoryToFtp = NO;
            client = [FTPClient clientWithHost:myHostname port:21 username:myUsername password:myPassword];
            
            while(TRUE)
            {
                NSTimeInterval seconds = [[UIApplication sharedApplication] backgroundTimeRemaining];
                if (seconds < 1000) {
//                    NSLog(@"Background time Remaining: %f\n",seconds);
                    if (didCreateDirectoryToFtp != YES) {
                        didCreateDirectoryToFtp = YES;
                        [weakSelf createDirectoryToFtp];
                    }
                }
                
//                [NSThread sleepForTimeInterval:1]; //wait for 1 sec
            }
            //#### background task ends
            
            //Clean up code. Tell the system that we are done.
            [application endBackgroundTask: background_task];
            background_task = UIBackgroundTaskInvalid; 
        });
    }
    else
    {
        NSLog(@"Multitasking Not Supported");
    }
	
    //basePrice = 19.99;
    _isFullImage = self.isFull_Flag;
    sizeArray = [[NSArray alloc] initWithObjects:@"Small",@"Medium",@"Large",@"X-Large",@"2X-Large",@"3X-Large", nil];
    currentSize = @"Small";
    [quantityLabel setText:@"1"];
    [self.priceLabel setText:[NSString stringWithFormat:@"$%.2f" , self.basePrice]];
    [basePriceButton setTitle:[NSString stringWithFormat:@"$%.2f" , self.basePrice] forState:UIControlStateNormal];
    
	UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:2000];
	scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 3, scrollView.frame.size.height);
	scrollView.scrollEnabled = NO;
	scrollView.delegate = self;
	
	UISwipeGestureRecognizer *gesture1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipShirtRight:)];
	gesture1.direction = UISwipeGestureRecognizerDirectionLeft;
	[scrollView addGestureRecognizer:gesture1];
	
	UISwipeGestureRecognizer *gesture2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipShirtLeft:)];
	gesture2.direction = UISwipeGestureRecognizerDirectionRight;
	[scrollView addGestureRecognizer:gesture2];
	
	for (UIImageView *imgView in _imgViewShirts) {
		CGRect rtContent;
        if (self.isFull_Flag) {
            
            CGSize iOSScreenSize = [[UIScreen mainScreen] bounds].size;
            if (iOSScreenSize.height <= 568) {
                movableImageViwScale = 6;
                rtContent = CGRectMake(72, 60, 145, 220);
            } else if(iOSScreenSize.width == 375){
                movableImageViwScale = 6;
                rtContent = CGRectMake(70, 70, 170, 240);
            }else if(iOSScreenSize.width == 414)
            {
                movableImageViwScale = 12;
                rtContent = CGRectMake(85, 70, 180, 250);
            }
        }else{
            rtContent = CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height)
            ;
        }
		UIScrollView *scrollContent = [[UIScrollView alloc] initWithFrame:rtContent];
		[imgView addSubview:scrollContent];
		[imgView setUserInteractionEnabled:YES];
		[scrollContent setUserInteractionEnabled:YES];
		[scrollContent setTag:100];
		
		MovableImageView *lblImgView = [[MovableImageView alloc] initWithFrame:CGRectZero];
		lblImgView.delegate = self;
		lblImgView.userInteractionEnabled = YES;
		[lblImgView setTag:200];
		[lblImgView setHidden:YES];
		[scrollContent addSubview:lblImgView];
	}
    addImgs = [[NSMutableArray alloc] init];
    [addImgs addObject:[[UIImage alloc] init]];
    [addImgs addObject:[[UIImage alloc] init]];
    [addImgs addObject:[[UIImage alloc] init]];
	_ShirtColors = @[@"apple_red_shirt",
					 @"asphalt_shirt",
					 @"brown_shirt",
					 @"cream_shirt",
					 @"heather_grey_shirt",
					 @"hunter_green",
					 @"midnight_shirt",
					 @"navy_shirt",
					 @"orange_shirt",
					 @"powder_blue_shirt",
					 @"purple_shirt",
					 @"royal_shirt",
					 @"silver_shirt",
					 @"turq_shirt"];
	
	UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapShirtColor:)];
	UIView *view = [self.view viewWithTag:500];
	[view addGestureRecognizer:gesture];
	
	gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapText:)];
	view = [self.view viewWithTag:600];
	[view addGestureRecognizer:gesture];
	
	gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImage:)];
	view = [self.view viewWithTag:700];
	[view addGestureRecognizer:gesture];
	
  
    gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapSize:)];
    
    [sizeView addGestureRecognizer:gesture];
    
    
    gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapApplepay:)];
    
    [applePayView addGestureRecognizer:gesture];
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangedTextField) name:UITextFieldTextDidChangeNotification object:nil];
	
	_index = 1;
	_colorIndex = 0;
	
	_orderNumber = @"order_LionTee_123";
    
    if (self.isFull_Flag) {
                [colorButton setBackgroundImage:[UIImage imageNamed:@"btn_color"] forState:UIControlStateNormal];
                [shapeButton setBackgroundImage:[UIImage imageNamed:@"shape_icon"] forState:UIControlStateNormal];
    }else{
        [colorButton setUserInteractionEnabled:NO];
        [shapeButton setUserInteractionEnabled:NO];
                [colorButton setBackgroundImage:[UIImage imageNamed:@"btn_color_disable"] forState:UIControlStateNormal];
                [shapeButton setBackgroundImage:[UIImage imageNamed:@"shape_icon_disable"] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	NSInteger i = 0;
	for (UIButton *btn in _arrayColorBtn) {
		NSString *name = [NSString stringWithFormat:@"%@%ld.png", _ShirtColors[i], (long)_index];
		
		[btn setTag:(i + 1)];
		[btn setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
		[btn addTarget:self action:@selector(onAddShirtColor:) forControlEvents:UIControlEventTouchUpInside];
		
		i ++;
	}
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - send Image to FTP

- (void)createDirectoryToFtp
{
    NSLog(@"createDirectoryToFtp");
    _countUploading = 1;
    _allUploading = 1;
    //ShowWaitView(YES, self.view);
    
	NSDate *date = [NSDate date];
	_orderNumber = [NSString stringWithFormat:@"order_lionshirt_%f", date.timeIntervalSince1970];
    NSString *path = [NSString stringWithFormat:@"./%@/", _orderNumber];
	
    [client createDirectoryAtPath:path success:^(void) {
        // Success!
        NSLog(@"Just created my new folder %@",path);
        
        _countUploading = 0;
        _allUploading = 0;
        
        [self uploadAllDataToFTP];
        [self showWaitView:YES];
        
        _countUploading --;
        if (!_countUploading) {
            [_hudProgress hide:YES afterDelay:0.5];
            [self performSegueWithIdentifier:@"orderComplete" sender:self];
        }
        
    } failure:^(NSError *error) {
        // Display an error...
        NSLog(@"Failed to create my new folder %@",path);
        NSLog(@"Error is %@",error);
        [self showWaitView:NO];
    }];
}

- (void)sendRefImage:(MovableImageView *)imgRef index:(NSInteger)index title:(NSString *)title
{
	NSData *data = UIImagePNGRepresentation(imgRef.image);
	if (!data) {
		return;
	}
    
    _countUploading ++;
    _allUploading ++;
    
    NSString *localFilePath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/image.%@.png",title]];
    if ([data writeToFile:localFilePath atomically:YES]) {
        NSLog(@"save ok %@",localFilePath);
    }
    else {
        NSLog(@"save failed %@",localFilePath);
    }
	
    NSString *path = [NSString stringWithFormat:@"./%@/%@", _orderNumber, title];
    
    [client uploadFile:localFilePath to:path progress:NULL success:^(void) {
        NSLog(@"Uploaded the %@ sucesfully", path);
    } failure:^(NSError *error) {
        NSLog(@"Error %@ for the path: %@",error,path);
    }];
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
	
    NSString *localFilePath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/image.%@.png",title]];
    if ([data writeToFile:localFilePath atomically:YES]) {
        NSLog(@"save ok %@",localFilePath);
    }
    else {
        NSLog(@"save failed %@",localFilePath);
    }
    
    NSString *path = [NSString stringWithFormat:@"./%@/%@", _orderNumber, title];
    
    [client uploadFile:localFilePath to:path progress:NULL success:^(void) {
        NSLog(@"Uploaded the %@ sucesfully", path);
    } failure:^(NSError *error) {
        NSLog(@"Error %@ for the path: %@",error,path);
    }];
}

- (void)sendStringToFTP
{
	NSMutableData *data = [NSMutableData data];
	
	for (NSInteger i = 0; i < 2; i ++) {
		UIImageView *imgView = _imgViewShirts[i];
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
    
    NSString *localFilePath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/text.txt"]];
    if ([data writeToFile:localFilePath atomically:YES]) {
        NSLog(@"sendStringToFTP: save ok %@",localFilePath);
    }
    else {
        NSLog(@"sendStringToFTP: save failed %@",localFilePath);
    }
	
	NSString *path = [NSString stringWithFormat:@"./%@/%@", _orderNumber, @"text.txt"];
    
    [client uploadFile:localFilePath to:path progress:NULL success:^(void) {
        NSLog(@"Uploaded the %@ sucesfully", path);
    } failure:^(NSError *error) {
        NSLog(@"Error %@ or the path: %@",error,path);
    }];
}

- (void)sendShippingTo:(NSString *)shippingAddress
{
    _countUploading ++;
    _allUploading ++;
    
    NSMutableData *data = [NSMutableData data];
    
    [data appendData:[shippingAddress dataUsingEncoding:NSUTF8StringEncoding]];

    NSString *localFilePath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/shippingAddress.txt"]];
    if ([data writeToFile:localFilePath atomically:YES]) {
        NSLog(@"sendStringToFTP: save ok %@",localFilePath);
    }
    else {
        NSLog(@"sendStringToFTP: save failed %@",localFilePath);
    }
    NSString *path = [NSString stringWithFormat:@"./%@/%@", _orderNumber, @"shippingAddress.txt"];
    [client uploadFile:localFilePath to:path progress:NULL success:^(void) {
        NSLog(@"Uploaded the %@ sucesfully", path);
    } failure:^(NSError *error) {
        NSLog(@"Error %@ or the path: %@",error,path);
    }];
}

- (void)sendShippingString:(NSString *)shippingString
{
    _countUploading ++;
    _allUploading ++;
    
    NSMutableData *data = [NSMutableData data];
    
    [data appendData:[shippingString dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *localFilePath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Order Information.txt"]];
    if ([data writeToFile:localFilePath atomically:YES]) {
        NSLog(@"sendStringToFTP: save ok %@",localFilePath);
    }
    else {
        NSLog(@"sendStringToFTP: save failed %@",localFilePath);
    }
    
    NSString *path = [NSString stringWithFormat:@"./%@/%@", _orderNumber, @"Order Information.txt"];
    [client uploadFile:localFilePath to:path progress:NULL success:^(void) {
        NSLog(@"Uploaded the %@ sucesfully", path);
    } failure:^(NSError *error) {
        NSLog(@"Error %@ or the path: %@",error,path);
    }];
    
}

- (void)uploadAllDataToFTP
{
	[UIView animateWithDuration:1.0
					 animations:^{
						 [self.view setAlpha:0.5];
						 
					 } completion:^(BOOL finished) {
						 [self.view setAlpha:1.0];
						 
						 for (NSInteger i = 0; i < 2; i ++) {
							 UIImageView *imgView = _imgViewShirts[i];
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
                         NSString *combined = [NSString stringWithFormat:@"Size: %@\nQuantity: %@\nOrder #: %@\n\n%@\n\n%@\n%@\n\n%@",sizeLabel.text, quantityLabel.text, _orderNumber, fullName, emailAddress, phoneNumber, fullAddress];

                         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                         NSMutableString *string = [defaults objectForKey:@"STRIPEADDRESS"];
                         NSString *userDefaults = [NSString stringWithFormat:@"Size: %@\nQuantity: %@\nOrder #: %@\n\n%@",sizeLabel.text,quantityLabel.text,_orderNumber, string];
                         if ([combined rangeOfString:@"(null)"].location == NSNotFound) {
                             [self sendShippingTo:combined];
                         } else {
                             [self sendShippingTo:userDefaults];
                         }
                         

                         
					 }];
}

/*
- (void)SendImageToFTP
{
#if 0
	UIGraphicsBeginImageContextWithOptions(_imgViewTShirt.bounds.size, _imgViewTShirt.opaque, 0.0);
    [_imgViewTShirt.layer renderInContext:UIGraphicsGetCurrentContext()];
	
    UIImage * imgCard = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
#endif
	
#if 1
    UIGraphicsBeginImageContext(_imgViewTShirt.bounds.size);
    CGContextRef imageContext = UIGraphicsGetCurrentContext();apple
	
    //CGContextTranslateCTM(imageContext, 0.0, _imgViewTShirt.bounds.size.height);
    //CGContextScaleCTM(imageContext, 1.0, -1.0);
	
    //for (CALayer* layer in self.layer.sublayers) {
    //  [layer renderInContext: imageContext];
    //}
	
    [_imgViewTShirt.layer renderInContext: imageContext];
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
#endif

#if 1
	NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	
	NSData * binaryImageData = UIImagePNGRepresentation(viewImage);
	
	[binaryImageData writeToFile:[basePath stringByAppendingPathComponent:@"image.png"] atomically:YES];
	
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentImagePath = [documentsDirectory stringByAppendingPathComponent:@"image.png"];
	
    _uploadData = [NSData dataWithContentsOfFile: documentImagePath];
#endif
	
#if 1
    //----- create our upload object
    uploadFile = [[BRRequestUpload alloc] initWithDelegate: self];
	
	NSString *path = [NSString stringWithFormat:@"/%@.png", @"image"];
	
    //----- for anonymous login just leave the username and password nil
    uploadFile.path = path;
    uploadFile.hostname = myHostname;
    uploadFile.username = myUsername;
    uploadFile.password = myPassword;
	
    //----- we start the request
    [uploadFile start];
#endif
	
	// upload text file to ftp server
	_uploadText = [_txtTitle.text dataUsingEncoding:NSUTF8StringEncoding];
	uploadText = [[BRRequestUpload alloc] initWithDelegate:self];
	NSString *path1 = [NSString stringWithFormat:@"/%@.txt", @"text"];
	
	//----- for anonymous login just leave the username and password nil
	uploadText.path = path1;
	uploadText.hostname = myHostname;
	uploadText.username = myUsername;
	uploadText.password = myPassword;
	
	//----- we start the request
	[uploadText start];
}
 */


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
    
    _hudProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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


#pragma mark - Gesture actions

- (void)onSwipShirtLeft:(id)sender
{
	_index --;
	if (_index < 1) {
		_index = 1;
	}
	
	_page.currentPage = _index - 1;
	
	UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:2000];
	[scrollView setContentOffset:CGPointMake(scrollView.frame.size.width * (_index - 1), 0) animated:YES];
	//scrollView.contentOffset = CGPointMake(scrollView.frame.size.width * (_index - 1), 0);
}

- (void)onSwipShirtRight:(id)sender
{
	_index ++;
	if (_index > 2) {
		_index = 2;
	}
	
	_page.currentPage = _index - 1;
	
	UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:2000];
	[scrollView setContentOffset:CGPointMake(scrollView.frame.size.width * (_index - 1), 0) animated:YES];
}

- (void)onTapShirtColor:(id)sender
{
	UIView *view = [self.view viewWithTag:500];
	[UIView animateWithDuration:0.5
					 animations:^{
						 view.frame = CGRectMake(0, view.frame.size.height, view.frame.size.width, view.frame.size.height);
					 } completion:^(BOOL finished) {
						 
					 }];
}

- (void)onTapSize:(id)sender
{
    UIView *view = sizeView;
    [UIView animateWithDuration:0.5
                     animations:^{
                         view.frame = CGRectMake(0, view.frame.size.height, view.frame.size.width, view.frame.size.height);
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)onTapApplepay:(id)sender
{
    UIView *view = applePayView;
    [UIView animateWithDuration:0.5
                     animations:^{
                         view.frame = CGRectMake(0, view.frame.size.height, view.frame.size.width, view.frame.size.height);
                     } completion:^(BOOL finished) {
                        
                     }];
}

- (void)onTapText:(id)sender
{
	[_txtTitle resignFirstResponder];
	
	UIView *view = [self.view viewWithTag:600];
	[UIView animateWithDuration:0.5
					 animations:^{
						 view.frame = CGRectMake(0, -view.frame.size.height, view.frame.size.width, view.frame.size.height);
						 
					 } completion:^(BOOL finished) {
						 
					 }];
}

- (void)onTapImage:(id)sender
{
	UIView *view = [self.view viewWithTag:700];
	[UIView animateWithDuration:0.5
					 animations:^{
						 view.frame = CGRectMake(0, -view.frame.size.height, view.frame.size.width, view.frame.size.height);
						 
					 } completion:^(BOOL finished) {
						 
					 }];
}

- (void)showTextEditView
{
	if (_curTextField) {
		_txtTitle.text = _curTextField.text;
		_txtTitle.textColor = _curTextField.textColor;
		_txtTitle.font = _curTextField.font;
		_sliderSize.value = _curTextField.font.pointSize;
	}
	
	UIView *view = [self.view viewWithTag:600];
	[UIView animateWithDuration:0.5
					 animations:^{
						 view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
					 } completion:^(BOOL finished) {
						 
					 }];
}

- (void)showImageEditView
{
	if (_curImageView) {
		_sliderImageSize.minimumValue = _curImageView.frame.size.width / 2;
		_sliderImageSize.maximumValue = _curImageView.frame.size.width * 2;
		_sliderImageSize.value = _curImageView.frame.size.width;
	}
	
	UIView *view = [self.view viewWithTag:700];
	[UIView animateWithDuration:0.5
					 animations:^{
						 view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
					 } completion:^(BOOL finished) {
						 
					 }];
}


#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	_index = scrollView.contentOffset.x / scrollView.frame.size.width;
}


#pragma mark - button action



- (IBAction)onRemoveText:(id)sender
{
	if (_curTextField) {
		[_curTextField removeFromSuperview];
		[self onTapText:nil];
	}
}

- (IBAction)onRemoveImage:(id)sender
{
	if (_curImageView) {
		[_curImageView setImage:nil];
		[_curImageView setHidden:YES];
		[self onTapImage:nil];
	}
}

- (IBAction)onAddText:(id)sender
{
	NSString *string = @"Hello";
	
	UIFont *font = [UIFont systemFontOfSize:30];
	CGSize sz = [string sizeWithAttributes:@{NSFontAttributeName:font}];
	
	UIScrollView *scrollContainer = (UIScrollView *)[_imgViewShirts[(_index - 1)] viewWithTag:100];
	
	_curTextField = [[MovableLabel alloc] initWithFrame:CGRectZero];
	[scrollContainer addSubview:_curTextField];
	_curTextField.userInteractionEnabled = YES;
	_curTextField.delegate = self;
	
	_curTextField.font = font;
	_curTextField.text = string;
	_curTextField.frame = CGRectMake(_curTextField.frame.origin.x, _curTextField.frame.origin.y, sz.width, sz.height);
	
	[self showTextEditView];
	
	//[self createDirectoryToFtp];
}

- (IBAction)onChangedImageSizeSlide:(id)sender
{
	if (_curImageView) {
		CGFloat w = _sliderImageSize.value;
		CGFloat scale = _curImageView.frame.size.width / _curImageView.frame.size.height;
		_curImageView.frame = CGRectMake(_curImageView.frame.origin.x, _curImageView.frame.origin.y, w, w/scale);
	}
}

- (IBAction)onChangedFontSizeSlide:(id)sender
{
	if (_curTextField) {
		UIFont *font = [UIFont fontWithName:[_txtTitle.font fontName] size:_sliderSize.value];
		CGSize sz = [_curTextField.text sizeWithAttributes:@{NSFontAttributeName:font}];
		
		_curTextField.font = font;
		_curTextField.frame = CGRectMake(_curTextField.frame.origin.x, _curTextField.frame.origin.y, sz.width, sz.height);
	}
}

- (IBAction)onChangeTextColor:(id)sender
{
	InfColorPickerController* picker = [InfColorPickerController colorPickerViewController];
	
	//UIColor *color = [SharedInfo mainInfo].colorText;
	//picker.sourceColor = color;
	picker.delegate = self;
	
	[picker presentModallyOverViewController: self];
}

- (IBAction)onChangeTextFont:(id)sender
{
	ARFontPickerViewController *fontPicker = [[ARFontPickerViewController alloc] init];
	fontPicker.delegate = self;
	[self presentViewController:fontPicker animated:YES completion:nil];
}

- (IBAction)onMainBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onAddColor:(id)sender
{
	UIView *view = [self.view viewWithTag:500];
	[UIView animateWithDuration:0.5
					 animations:^{
						 view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
					 } completion:^(BOOL finished) {
						 
					 }];
}

-(IBAction)onAddShape:(id)sender
{
    UIImage * temp = [addImgs objectAtIndex:_index-1];
    if (temp.size.width == 0) {
        return;
    }
    SelectShapeViewController * controller = (SelectShapeViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"SelectShapeViewController"];
    controller.delegate = self;
    controller.originalImage = temp;
    
    [self.navigationController pushViewController:controller animated:YES];
    
//    UIView *view = [self.view viewWithTag:789];
//    [UIView animateWithDuration:0.5
//                     animations:^{
//                         view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//                     } completion:^(BOOL finished) {
//                         
//                     }];

}


-(void)shapeEditDone:(UIImage *)image
{
    UIScrollView *scrollContainer = (UIScrollView *)[_imgViewShirts[(_index - 1)] viewWithTag:100];
    MovableImageView *imgView = (MovableImageView *)[scrollContainer viewWithTag:200];
    [imgView setImage:image];
   imgView.frame = CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y, image.size.width / 2, image.size.height / 2);
}
- (IBAction)onAddShirtColor:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger bTag = button.tag;
    
    NSLog(@"onAddShirtColor - %ld",(long)bTag);
	int index = bTag - 1;
	
	_index = 1;
	_colorIndex = index;
	
	for (NSInteger i = 0; i < 3; i ++) {
		NSString *name = [NSString stringWithFormat:@"%@%ld.png", _ShirtColors[index], i + 1];
        NSLog(@"Name is %@",name);
		
		UIImageView *imgView = _imgViewShirts[i];
		[imgView setImage:[UIImage imageNamed:name]];
	}
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
    pickerController.allowsEditing = YES;
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];
   }


- (void)onAddImageFromLibrary
{
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
    pickerController.allowsEditing = YES;
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];

}


///////////// /      wnaghe added this code
- (IBAction)onSize:(id)sender
{
    UIView * view = sizeView;
    [UIView animateWithDuration:0.5 animations:^{
        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    } completion:^(BOOL finished) {
    
    }];
}

- (IBAction)onBack:(id)sender
{
    UIView *view = editOrderView;
    [UIView animateWithDuration:0.5
                     animations:^{
                         view.frame = CGRectMake(self.view.frame.size.width, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
                     } completion:^(BOOL finished) {
                         
                     }];

}
- (IBAction)onDone:(id)sender
{
    int order = [orderPickerView selectedRowInComponent:0] + 1;
    if (order == 0) {
        order = 1;
    }
    
    
    [quantityLabel setText:[NSString stringWithFormat:@"%d", order]];
    [self.priceLabel setText:[NSString stringWithFormat:@"$%.2f", order * self.basePrice]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.priceLabel.text forKey:@"PRICEKEY"];
    [defaults synchronize];
    
    [basePriceButton setTitle:self.priceLabel.text forState:UIControlStateNormal];
    
    [self onBack:nil];
}

- (IBAction)onBuyApplepay:(id)sender
{
    #if 1
        // for Apple Pay
        PKPaymentRequest *request = [Stripe paymentRequestWithMerchantIdentifier:YOUR_APPLE_MERCHANT_ID];
    
        //
        if ([Stripe canSubmitPaymentRequest:request]) {
            UIViewController *paymentController;

            
    #if 0
            paymentController = [[STPTestPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
            paymentController.delegate = self;
    #else
            paymentController = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
            ((PKPaymentAuthorizationViewController *)paymentController).delegate = self;
    #endif
            
            [self presentViewController:paymentController animated:YES completion:nil];
            
        } else {
            PaymentViewController *paymentViewController = [[PaymentViewController alloc] initWithNibName:nil bundle:nil];
            
            paymentViewController.amount = [NSDecimalNumber decimalNumberWithString:@"19.99f"];
            paymentViewController.parent = self;
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:paymentViewController];
            [payButton setImage:[UIImage imageNamed:@"pay_stripe_button.png"] forState:UIControlStateNormal];
            [self presentViewController:navController animated:YES completion:nil];
            
        }
    #else
        
        [self createDirectoryToFtp];
    #endif

}
- (IBAction)onEditOrder:(id)sender
{
    UIView *view = editOrderView;
    [UIView animateWithDuration:0.5
                     animations:^{
                         view.frame = CGRectMake(0, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
                     } completion:^(BOOL finished) {
                         NSInteger index = [quantityLabel.text integerValue];
                         [orderPickerView selectRow:index - 1 inComponent:0 animated:NO];
                    }];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.priceLabel.text forKey:@"PRICEKEY"];
    [defaults synchronize];
    
}


- (IBAction)onPurchase:(id)sender
{
    [self createDirectoryToFtp];
#if 1
    // for Apple Pay
    PKPaymentRequest *request = [Stripe paymentRequestWithMerchantIdentifier:YOUR_APPLE_MERCHANT_ID];
    
    //
    if ([Stripe canSubmitPaymentRequest:request]) {
#if 0
        UIViewController *paymentController;
        paymentController = [[STPTestPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
        paymentController.delegate = self;
#else

#endif
        
    }
        [payButton setBackgroundImage:[UIImage imageNamed:@"pay_stripe_button.png"] forState:UIControlStateNormal];
        NSLog(@"Apple Pay Disabled");
    
#endif
    
    UIView * view = applePayView;
    [UIView animateWithDuration:0.5 animations:^{
        editOrderView.frame = CGRectMake(self.view.frame.size.width, editOrderView.frame.origin.y, editOrderView.frame.size.width, editOrderView.frame.size.height);
        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.priceLabel.text forKey:@"PRICEKEY"];
    [defaults synchronize];
    
    [_txtTitle.font fontName];
    
}
/*
#pragma NON APPLE PAY CODE BELOW
- (IBAction)onPurchase:(id)sender
{
#if 1
    // for Apple Pay
    PKPaymentRequest *request = [Stripe paymentRequestWithMerchantIdentifier:YOUR_APPLE_MERCHANT_ID];
    PKPaymentRequest *request = [Stripe
     paymentRequestWithMerchantIdentifier:@""
     amount:[NSDecimalNumber decimalNumberWithString:@"10.00"]
     currency:@"USD"
     description:@"Premium llama food"];
    //
    //	if ([Stripe canSubmitPaymentRequest:request]) {
    //		UIViewController *paymentController;
    //
    //#if 0
    //		paymentController = [[STPTestPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
    //		paymentController.delegate = self;
    //#else
    //		paymentController = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
    //		((PKPaymentAuthorizationViewController *)paymentController).delegate = self;
    //#endif
    //
    //		[self presentViewController:paymentController animated:YES completion:nil];
    //
    //	} else {
    PaymentViewController *paymentViewController = [[PaymentViewController alloc] initWithNibName:nil bundle:nil];
    paymentViewController.amount = [NSDecimalNumber decimalNumberWithString:@"19.99f"];
    paymentViewController.parent = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:paymentViewController];
    [self presentViewController:navController animated:YES completion:nil];
    //	}
#else
    
    [self createDirectoryToFtp];
#endif
}
*/

#pragma mark - ARFontPicker delegate
    
-(void)fontPickerViewController:(ARFontPickerViewController *)fontPicker didSelectFont:(NSString *)fontName

{
	[fontPicker dismissViewControllerAnimated:YES completion:nil];
	
	UIFont *font = [UIFont fontWithName:fontName size:_sliderSize.value];
	[_txtTitle setFont:font];
	
	CGSize sz = [_curTextField.text sizeWithAttributes:@{NSFontAttributeName:font}];
	
	_curTextField.font = font;
	_curTextField.frame = CGRectMake(_curTextField.frame.origin.x, _curTextField.frame.origin.y, sz.width, sz.height);
}


#pragma mark - InfColorPicker delegate

- (void) colorPickerControllerDidFinish: (InfColorPickerController*) picker
{
	if (_curTextField) {
		[_curTextField setTextColor:picker.resultColor];
		_txtTitle.textColor = picker.resultColor;
	}
	
	[self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - MoavableImageView delegate

- (void)setCurrentImageView:(MovableImageView *)imgView
{
	_curImageView = imgView;
	[self showImageEditView];
}


#pragma mark - MovalbeLabel delegate

- (void)setCurrentTextLabel:(MovableLabel *)label
{
	_curTextField = label;
	[self showTextEditView];
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

//-(void)willPresentActionSheet:(UIActionSheet *)actionSheet
//{
//    NSArray * array = actionSheet.subviews;
//    NSString * systemVersion = [[UIDevice currentDevice] systemVersion];
//    if ([systemVersion isEqualToString:@""]) {
//        
//    }
//    for (UIView *subView in actionSheet.subviews) {
//        if ([subView isKindOfClass:[UIButton class]]) {
//            UIButton * button = (UIButton *)subView;
//            
//            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        }
//        
//        if ([subView isKindOfClass:[UILabel class]]) {
//            UILabel * titleLabel = (UILabel *)subView;
//            [titleLabel setFont:[UIFont systemFontOfSize:20]];
//            [titleLabel setTextColor:[UIColor redColor]];
//        }
//    }
//}


#pragma mark - UIAlertView delegate

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//	if (buttonIndex == 0) {
//		_isFullImage = NO;
//	} else {
//		_isFullImage = YES;
//	}
//	
//	[alertView dismissWithClickedButtonIndex:0 animated:YES];
//	
//	if (alertView.tag == 0x100) {
//		UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
//		pickerController.videoQuality = UIImagePickerControllerQualityTypeLow;
//		pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//    //    pickerController.sourceType = uiimagepi
//		pickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
//		pickerController.allowsEditing = YES;
//		pickerController.delegate = self;
//		[self presentViewController:pickerController animated:YES completion:nil];
//		
//	} else if (alertView.tag == 0x101) {
//		UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
//		pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//		pickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
//		pickerController.allowsEditing = YES;
//		pickerController.delegate = self;
//		[self presentViewController:pickerController animated:YES completion:nil];
//	}
//}


#pragma mark - UIImagePickerController delegate

- (UIImage *)maskImage:(UIImage *)image withMask:(UIImage *)maskImage
{
	
	CGImageRef maskRef = maskImage.CGImage;
	
	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
										CGImageGetHeight(maskRef),
										CGImageGetBitsPerComponent(maskRef),
										CGImageGetBitsPerPixel(maskRef),
										CGImageGetBytesPerRow(maskRef),
										CGImageGetDataProvider(maskRef), NULL, false);
	
	CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
	return [UIImage imageWithCGImage:masked];
	
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
	
	if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
		
		UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
		if (!img) {
			img = [info objectForKey:UIImagePickerControllerOriginalImage];
		}
		
		if (_isFullImage) {
			UIScrollView *scrollContainer = (UIScrollView *)[_imgViewShirts[(_index - 1)] viewWithTag:100];
			MovableImageView *imgView = (MovableImageView *)[scrollContainer viewWithTag:200];
            [addImgs replaceObjectAtIndex:_index-1 withObject:img];
			[imgView setHidden:NO];
			
            CGSize s= img.size;
			imgView.image = img;
			imgView.frame = CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y, img.size.width / movableImageViwScale, img.size.height / movableImageViwScale);
			
		} else {
			UIImageView *shirtImgView = _imgViewShirts[(_index - 1)];
			UIScrollView *scrollContainer = (UIScrollView *)[shirtImgView viewWithTag:100];
			NSString *name = [NSString stringWithFormat:@"%@%d.png", _ShirtColors[_colorIndex], _index];
			UIImage *imgOrigin = [UIImage imageNamed:name];
			
            UIImage * tempImage = [imgOrigin imageWithMappingImage:img];
            shirtImgView.image = tempImage; //[self maskImage:imgOrigin withMask:img];
            
            MovableImageView *imgView = (MovableImageView *)[scrollContainer viewWithTag:200];
            imgView.image = img;
            [addImgs replaceObjectAtIndex:_index-1 withObject:tempImage];
            [imgView setHidden:YES];

		}
	}
	
    [picker dismissViewControllerAnimated:YES completion:nil];
   
    if (_isFullImage == NO && _index == 2) {
        self.basePrice = 39.99f;
        [basePriceButton setTitle:[NSString stringWithFormat:@"$%.2f" , self.basePrice] forState:UIControlStateNormal];
    }
    
}


#pragma mark - UITextField delegate

- (void)didChangedTextField
{
    
	if (_curTextField) {
		_curTextField.text = _txtTitle.text;
		
		UIFont *font = _curTextField.font;
		CGSize sz = [_curTextField.text sizeWithAttributes:@{NSFontAttributeName:font}];
		
		_curTextField.font = font;
		_curTextField.frame = CGRectMake(_curTextField.frame.origin.x, _curTextField.frame.origin.y, sz.width, sz.height);
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
	[textField resignFirstResponder];
	
	if (_curTextField) {
		_curTextField.text = textField.text;
		
		UIFont *font = _curTextField.font;
		CGSize sz = [_curTextField.text sizeWithAttributes:@{NSFontAttributeName:font}];
		
		_curTextField.font = font;
		_curTextField.frame = CGRectMake(_curTextField.frame.origin.x, _curTextField.frame.origin.y, sz.width, sz.height);
	}
	
	return YES;
}


#pragma mark - PKPaymentViewController delegate

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
					   didAuthorizePayment:(PKPayment *)payment
								completion:(void (^)(PKPaymentAuthorizationStatus))completion {
	/*
	 We'll implement this method below in 'Creating a single-use token'.
	 Note that we've also been given a block that takes a
	 PKPaymentAuthorizationStatus. We'll call this function with either
	 PKPaymentAuthorizationStatusSuccess or PKPaymentAuthorizationStatusFailure
	 after all of our asynchronous code is finished executing. This is how the
	 PKPaymentAuthorizationViewController knows when and how to update its UI.
	 */
	[self handlePaymentAuthorizationWithPayment:payment completion:completion];
    

    ABMultiValueRef emails = ABRecordCopyValue([payment shippingAddress], kABPersonEmailProperty);
    
    for (CFIndex index = 0; index < ABMultiValueGetCount(emails); index++)
    {
        NSArray *emailAddresses = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(emails);
        NSString * result = [emailAddresses description];
        NSString *openString = [result stringByReplacingOccurrencesOfString:@"(" withString:@""];
        NSString *closeString = [openString stringByReplacingOccurrencesOfString:@")" withString:@""];
        NSString *quoteString = [closeString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSString *quotesString = [quoteString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *spaceString = [quotesString stringByReplacingOccurrencesOfString:@" " withString:@""];
        emailAddress = spaceString;
        NSLog(@"Email: %@", spaceString);
        
    }
    
    ABMultiValueRef phones = ABRecordCopyValue([payment shippingAddress], kABPersonPhoneProperty);

    
    for (CFIndex index = 0; index < ABMultiValueGetCount(emails); index++)
    {
        NSArray *phoneNumbers = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phones);
        NSString * result = [phoneNumbers description];
        NSString *openString = [result stringByReplacingOccurrencesOfString:@"(" withString:@""];
        NSString *closeString = [openString stringByReplacingOccurrencesOfString:@")" withString:@""];
        NSString *quoteString = [closeString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSString *quotesString = [quoteString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *extraSpace = [quotesString stringByReplacingOccurrencesOfString:@"    " withString:@""];
        phoneNumber = extraSpace;
        NSLog(@"Phone Number: %@", extraSpace);
        
    }
    
    ABMultiValueRef addresses = ABRecordCopyValue([payment shippingAddress], kABPersonAddressProperty);
    
    for (CFIndex index = 0; index < ABMultiValueGetCount(addresses); index++)
    {
        CFDictionaryRef properties = ABMultiValueCopyValueAtIndex(addresses, index);
        NSString *street = [(__bridge NSString *)(CFDictionaryGetValue(properties, kABPersonAddressStreetKey)) copy];
        NSString *city = [(__bridge NSString *)(CFDictionaryGetValue(properties, kABPersonAddressCityKey)) copy];
        NSString *state = [(__bridge NSString *)(CFDictionaryGetValue(properties, kABPersonAddressStateKey)) copy];
        NSString *postalCode = [(__bridge NSString *)(CFDictionaryGetValue(properties, kABPersonAddressZIPKey)) copy];
        NSString *country = [(__bridge NSString *)(CFDictionaryGetValue(properties, kABPersonAddressCountryKey)) copy];
        fullAddress = [NSString stringWithFormat:@"%@\n%@, %@ %@\n%@", street, city, state, postalCode, country];
        NSLog(@"Address: %@", fullAddress);

    }
    
    NSString *name = (__bridge_transfer NSString *)(ABRecordCopyCompositeName([payment shippingAddress]));
    NSLog(@"Name: %@", name);
    fullName = name;
    
    //NSLog(@"City: %@", [shippingAddress valueForKey:@"City"]);
    
    
}



- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
	[self dismissViewControllerAnimated:YES completion:nil];
    [self createDirectoryToFtp];

}

- (void)handlePaymentAuthorizationWithPayment:(PKPayment *)payment
                                   completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    [Stripe createTokenWithPayment:payment
                        completion:^(STPToken *token, NSError *error) {
                            if (error) {
                                completion(PKPaymentAuthorizationStatusFailure);
                                return;
                            }
                            /*
                             We'll implement this below in "Sending the token to your server".
                             Notice that we're passing the completion block through.
                             See the above comment in didAuthorizePayment to learn why.
                             */
                            
                            [self createBackendChargeWithToken:token completion:completion];

                            
                            ABMultiValueRef addresses = ABRecordCopyValue([payment shippingAddress], kABPersonAddressProperty);
                            
                            for (CFIndex index = 0; index < ABMultiValueGetCount(addresses); index++)
                            {
                                CFDictionaryRef properties = ABMultiValueCopyValueAtIndex(addresses, index);
                                NSString *street = [(__bridge NSString *)(CFDictionaryGetValue(properties, kABPersonAddressStreetKey)) copy];
                                NSString *city = [(__bridge NSString *)(CFDictionaryGetValue(properties, kABPersonAddressCityKey)) copy];
                                NSString *state = [(__bridge NSString *)(CFDictionaryGetValue(properties, kABPersonAddressStateKey)) copy];
                                NSString *postalCode = [(__bridge NSString *)(CFDictionaryGetValue(properties, kABPersonAddressZIPKey)) copy];
                                NSString *country = [(__bridge NSString *)(CFDictionaryGetValue(properties, kABPersonAddressCountryKey)) copy];
                                fullAddress = [NSString stringWithFormat:@"%@\n%@, %@\n%@\n%@", street, city, state, postalCode, country];
                                
                                addressStringPass = [NSString stringWithFormat:@"%@\n%@, %@ %@", street, city, state, postalCode];

                                
                            }
                            
                            NSLog(@"handlePaymentAuthorizationWithPayment");
                            
                            
                            
                        }];
}


-(void) applePayCheck {
    
#if 1
    // for Apple Pay
    PKPaymentRequest *request = [Stripe paymentRequestWithMerchantIdentifier:YOUR_APPLE_MERCHANT_ID];
    
    //
    if ([Stripe canSubmitPaymentRequest:request]) {
        UIViewController *paymentController;
        
        
#if 0
        paymentController = [[STPTestPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
        paymentController.delegate = self;
#else
        
#endif
        
    }
    [payButton setBackgroundImage:[UIImage imageNamed:@"pay_stripe_button.png"] forState:UIControlStateNormal];
    NSLog(@"Apple Pay Disabled");
    [self createDirectoryToFtp];

    
#else
    
#endif

    
}

- (void)createBackendChargeWithToken:(STPToken *)token
                          completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    
//    NSString * str = [NSNumber numberWithFloat:self.basePrice].stringValue;
    NSString *newString = [self.priceLabel.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *finalPrice = [newString stringByReplacingOccurrencesOfString:@"$" withString:@""];
    NSLog(@"Base Price: %@", finalPrice);
    
    NSURL *url = [NSURL URLWithString:@"http://liontee.com/ApplePay/applepay.php"];
    
    NSString *end = [NSString stringWithFormat:@"stripeToken=%@", token.tokenId];
    NSString *begin = [NSString stringWithFormat:@"%@&stripePrice=%@", end, finalPrice];
    NSString *desc = [NSString stringWithFormat:@"%@&stripeDesc=%@", begin, emailAddress];
    NSString *strings = [NSString stringWithFormat:@"%@?%@", url, desc];
    NSURL *newURL = [NSURL URLWithString:strings];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:newURL];
    request.HTTPMethod = @"POST";
    NSLog(@"New URL: %@", newURL);
    
    
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
                                   
                                   completion(PKPaymentAuthorizationStatusSuccess);
                                   NSLog(@"Created: %@", token.tokenId);
                                   [self applePayCheck];
                                   AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                               }
                               
                           }];
    }



///Creatting   Mask Image

-(CGImageRef)CopyImageAndAddAlphaChannel:(CGImageRef) sourceImage {
    CGImageRef retVal = NULL;
    
    size_t width = CGImageGetWidth(sourceImage);
    size_t height = CGImageGetHeight(sourceImage);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL, width, height,
                                                          8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    if (offscreenContext != NULL) {
        CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), sourceImage);
        
        retVal = CGBitmapContextCreateImage(offscreenContext);
        CGContextRelease(offscreenContext);
    }
    
    CGColorSpaceRelease(colorSpace);
    
    return retVal;
}

- (UIImage*)maskImage1:(UIImage *)image withMask:(UIImage *)maskImage {
    CGImageRef maskRef = maskImage.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef sourceImage = [image CGImage];
    CGImageRef imageWithAlpha = sourceImage;
    //add alpha channel for images that don't have one (ie GIF, JPEG, etc...)
    //this however has a computational cost
    // needed to comment out this check. Some images were reporting that they
    // had an alpha channel when they didn't! So we always create the channel.
    // It isn't expected that the wheelin application will be doing this a lot so
    // the computational cost isn't onerous.
    //if (CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNone) {
    imageWithAlpha = [self CopyImageAndAddAlphaChannel :sourceImage];
    //}
    
    CGImageRef masked = CGImageCreateWithMask(imageWithAlpha, mask);
    CGImageRelease(mask);
    
    //release imageWithAlpha if it was created by CopyImageAndAddAlphaChannel
    if (sourceImage != imageWithAlpha) {
        CGImageRelease(imageWithAlpha);
    }
    
    UIImage* retImage = [UIImage imageWithCGImage:masked];
    CGImageRelease(masked);
    
    return retImage;
}


#pragma mark - UIPickerView Delegate 

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == orderPickerView) {
        return 100;
    }
    return  [sizeArray count];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
}
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    return  [sizeArray objectAtIndex:row];
//}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (view == nil) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 30)];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 30)];
        [label setTextAlignment:NSTextAlignmentCenter];
        if (pickerView == orderPickerView) {
            [label setText: [NSString stringWithFormat:@"%d",row + 1]];
            [label setFont:[UIFont systemFontOfSize:22]];
        }else{
            [label setText: [sizeArray objectAtIndex:row]];
            [label setFont:[UIFont systemFontOfSize:20]];
        }
        
        [label setTag:123];
        [label setTextColor:[UIColor whiteColor]];
        //[view.layer setBorderColor:[[UIColor whiteColor] CGColor]];
       // [view.layer setBorderWidth:0.5f];
       // [label setBackgroundColor:[UIColor blackColor]];
        [view addSubview:label];
    }else
    {
        UILabel * label = (UILabel *)[view viewWithTag:123];
        [label setText:[sizeArray objectAtIndex:row]];
    }
    
 //
//    [view addSubview:]
    return view;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView != orderPickerView) {
        currentSize = [sizeArray objectAtIndex:row];
        [sizeLabel setText:currentSize];
    }
}


#pragma passing info to new segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"orderComplete"]) {
        OrderConfirmationViewController *vc = [segue destinationViewController];
        [vc view];
        
        if ([addressStringPass rangeOfString:@"(null)"].location == NSNotFound) {
            vc.addressLabel.text = addressStringPass;
            NSLog(@"First");
        } else {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSMutableString *string = [defaults objectForKey:@"STRIPEADDRESS"];
            vc.addressLabel.text = string;
        }
        
//        vc.addressLabel.text = addressStringPass;
        vc.totalPrice.text = basePriceButton.titleLabel.text;
        
        NSLog(@"Pass: %@", addressStringPass);
    }
}

@end

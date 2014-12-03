//
//  SecondViewController.m
//  LionTee
//
//  Created by iii on 27/11/14.
//  Copyright (c) 2014 Bai. All rights reserved.
//

#import "SecondViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate* MyAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self.title = MyAppDelegate.tshirtType;
    [self.navigationController setNavigationBarHidden:NO];
    
    float price = MyAppDelegate.price/100.00;
    NSString *priceTitle = [NSString stringWithFormat:@"$%.2f",price];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:priceTitle forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 60, 30);
    button.layer.borderColor = [self.view tintColor].CGColor;
    button.layer.borderWidth = 1.0f;
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    
    fontPanelButton.layer.borderColor = [self.view tintColor].CGColor;
    fontPanelButton.layer.borderWidth = 1.0f;
    fontPanelButton.layer.cornerRadius = 5;
    
    colorPanelButton.layer.borderColor = [self.view tintColor].CGColor;
    colorPanelButton.layer.borderWidth = 1.0f;
    colorPanelButton.layer.cornerRadius = 5;
    
    removePanelButton.layer.borderColor = [UIColor redColor].CGColor;
    removePanelButton.layer.borderWidth = 1.0f;
    removePanelButton.layer.cornerRadius = 5;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self action:@selector(clickPayButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [self setImagesScrollView];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.tintColor = [self.view tintColor];
    
    imagesScrollView.contentOffset = CGPointMake(0, 64);
    [super viewWillAppear:animated];
    
    AppDelegate* MyAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSString *frontImageName = [NSString stringWithFormat:@"%@1.png",MyAppDelegate.tshirtColor];
    [frontImage setImage:[UIImage imageNamed:frontImageName]];
//    NSLog(@"SecondViewController viewWillAppear frontImage - %@",frontImageName);
    
    NSString *backImageName = [NSString stringWithFormat:@"%@1.png",MyAppDelegate.tshirtColor];
    [backImage setImage:[UIImage imageNamed:backImageName]];
//    NSLog(@"SecondViewController viewWillAppear backImage - %@",backImageName);
}

-(void)setImagesScrollView
{
    imagesScrollView.contentSize = CGSizeMake(imagesScrollView.frame.size.width * 3, imagesScrollView.frame.size.height);
    imagesScrollView.scrollEnabled = NO;
    
    frontImage.frame = CGRectMake(0, 0, imagesScrollView.frame.size.width, imagesScrollView.frame.size.height);
    backImage.frame = CGRectMake(imagesScrollView.frame.size.width, 0, imagesScrollView.frame.size.width, imagesScrollView.frame.size.height);
//    [imagesScrollView setContentOffset:CGPointMake(0, 64) animated:NO];
    
    UISwipeGestureRecognizer *gestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipShirtRight:)];
    gestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [imagesScrollView addGestureRecognizer:gestureLeft];
    
    UISwipeGestureRecognizer *gestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipShirtLeft:)];
    gestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    [imagesScrollView addGestureRecognizer:gestureRight];
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
    AppDelegate* MyAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *printType = MyAppDelegate.printType;
    NSString *isAllOver = ALLOVER_TSHIRT_TYPE;
    BOOL isFullImage = [printType isEqualToString:isAllOver];
    
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        if (!img) {
            img = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        if (isFullImage) {
//            UIScrollView *scrollContainer = (UIScrollView *)[_imgViewShirts[(_index - 1)] viewWithTag:100];
//            MovableImageView *imgView = (MovableImageView *)[scrollContainer viewWithTag:200];
//            [addImgs replaceObjectAtIndex:_index-1 withObject:img];
//            [imgView setHidden:NO];
//            
//            CGSize s= img.size;
//            imgView.image = img;
//            imgView.frame = CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y, img.size.width / movableImageViwScale, img.size.height / movableImageViwScale);
            
        } else {
                NSLog(@"HERE");
                AppDelegate* MyAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                NSString *name = [NSString stringWithFormat:@"%@%ld.png", MyAppDelegate.tshirtColor, (long)_index+1];
                UIImage *imgOrigin = [UIImage imageNamed:name];
                UIImage * tempImage = [imgOrigin imageWithMappingImage:img];
                NSLog(@"HERE %@",name);
            
                UIImageView *imageView = [[UIImageView alloc] initWithImage:tempImage];
                imageView.frame = frontImage.frame;
                [imagesScrollView addSubview:imageView];
            
//            UIImageView *shirtImgView = _imgViewShirts[(_index - 1)];
//            UIScrollView *scrollContainer = (UIScrollView *)[shirtImgView viewWithTag:100];
//            NSString *name = [NSString stringWithFormat:@"%@%d.png", _ShirtColors[_colorIndex], _index];
//            UIImage *imgOrigin = [UIImage imageNamed:name];
//            
//            UIImage * tempImage = [imgOrigin imageWithMappingImage:img];
//            shirtImgView.image = tempImage; //[self maskImage:imgOrigin withMask:img];
//            
//            MovableImageView *imgView = (MovableImageView *)[scrollContainer viewWithTag:200];
//            imgView.image = img;
//            [addImgs replaceObjectAtIndex:_index-1 withObject:tempImage];
//            [imgView setHidden:YES];
            
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

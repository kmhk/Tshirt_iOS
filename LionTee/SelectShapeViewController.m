//
//  SelectShapeViewController.m
//  LionTee
//
//  Created by wang on 11/12/14.
//  Copyright (c) 2014 Bai. All rights reserved.
//

#import "SelectShapeViewController.h"


@implementation SelectShapeViewController

@synthesize originalImage;
@synthesize delegate;

- (void)viewDidLoad {
    
    titleArray = [[NSArray alloc] initWithObjects:@"Heart",@"Circle", @"Curved Frame" , @"Rectangle" , @"Triangle" ,@"Arrow", @"Star", @"Comic", nil];
    [super viewDidLoad];
    [sourceImageView setImage:nil];
    
    [titleLabel setFont:[UIFont fontWithName:@"MyriadPro-Light" size:19.0]];
    [cancelButton.titleLabel setFont:[UIFont fontWithName:@"MyriadPro-Light" size:17.0]];

    [cancelButtonTwo.titleLabel setFont:[UIFont fontWithName:@"MyriadPro-Light" size:17.0]];
    [titleLabelTwo setFont:[UIFont fontWithName:@"MyriadPro-Light" size:19.0]];
    [doneButton.titleLabel setFont:[UIFont fontWithName:@"MyriadPro-Light" size:17.0]];
    
    [shapeLabel setFont:[UIFont fontWithName:@"MyriadPro-Light" size:13.0]];

    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)onBackEdit:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^(void){
        
        [editView setFrame: CGRectMake(self.view.frame.size.width, 0, editView.frame.size.width, editView.frame.size.height)];
    }];
}

- (IBAction)onDone:(id)sender
{
    if (delegate != nil && [delegate respondsToSelector:@selector(shapeEditDone:)]) {
        [delegate shapeEditDone:shapeImageView.image];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    float baseWidth ;
    float baseHeight;
    float x,y;
    if (originalImage.size.width < originalImage.size.height) {
        baseWidth = shapeImageView.frame.size.width;
        baseHeight = (shapeImageView.frame.size.width / originalImage.size.width) * originalImage.size.height;
        x = 0;
        y = (shapeImageView.frame.size.height - baseHeight) / 2 ;
    }else
    {
        baseHeight = shapeImageView.frame.size.height;
        baseWidth = (shapeImageView.frame.size.height / originalImage.size.height) * originalImage.size.width;
        
        x = (shapeImageView.frame.size.width - baseWidth)/2;
        y = 0;
    }
    sourceImageView.frame = CGRectMake(x, y, baseWidth , baseHeight);
    
    currentMask = [UIImage imageNamed:[NSString stringWithFormat:@"mask_%ld", (long)indexPath.row + 1]];
    [self setShapeImage];
    [UIView animateWithDuration:0.5 animations:^(void){
    
        [editView setFrame: CGRectMake(0, 0, editView.frame.size.width, editView.frame.size.height)];
    }];
    
}

-(UIImage *)getImageFromEditView
{
    CALayer *layer = sourceView.layer;
    
    UIGraphicsBeginImageContext(sourceView.frame.size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"shapecell" forIndexPath:indexPath];
    UIImageView * shapeView = (UIImageView *)[cell viewWithTag:456];
    UIImage * customImage = [self maskImage1:self.originalImage withMask:[UIImage imageNamed:[NSString stringWithFormat:@"mask_%ld", (long)indexPath.row + 1]]];
    [shapeView setImage:customImage];
    
    UILabel * titleLabel = (UILabel *)[cell viewWithTag:123];
    [titleLabel setText:[titleArray objectAtIndex:indexPath.row]];
    
    return cell;
    
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
    imageWithAlpha = [self CopyImageAndAddAlphaChannel:sourceImage];
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


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    _start = [touch locationInView:sourceImageView];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:sourceImageView];
    
    
    CGFloat x = sourceImageView.frame.origin.x + (location.x - _start.x);
    
    
    CGFloat y = sourceImageView.frame.origin.y + (location.y - _start.y);
    
    [sourceImageView setFrame:CGRectMake(x, y, sourceImageView.frame.size.width, sourceImageView.frame.size.height)];
    
    [self setShapeImage];
    
}


-(void)setShapeImage
{
    [sourceImageView setImage:originalImage];
    UIImage * tempSourceImage = [self getImageFromEditView];
    [sourceImageView setImage:nil];
    
    UIImage * tempTargetImage = [self maskImage1:tempSourceImage withMask:currentMask];
    
    [shapeImageView setImage:tempTargetImage];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}


@end

//
//  SelectShapeViewController.h
//  LionTee
//
//  Created by wang on 11/12/14.
//  Copyright (c) 2014 Bai. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SelectShapeDelegate <NSObject>
-(void)shapeEditDone:(UIImage *)image;

@end


@interface SelectShapeViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSArray * titleArray;
    
    IBOutlet UILabel *titleLabel;
    IBOutlet UIButton *cancelButton;
    
    IBOutlet UILabel *titleLabelTwo;
    IBOutlet UIButton *cancelButtonTwo;
    IBOutlet UIButton *doneButton;
    
    IBOutlet UILabel *shapeLabel;
    
    IBOutlet  UIView * editView;
    
    IBOutlet  UIImageView * sourceImageView;
    IBOutlet UIImageView  * shapeImageView;
    CGPoint						_start;
    
    IBOutlet UIView * sourceView;
    
    UIImage * currentMask;
}

@property (nonatomic, strong) UIImage * originalImage;
@property (nonatomic, strong) id <SelectShapeDelegate> delegate;
-(IBAction)onBack:(id)sender;
- (IBAction)onBackEdit:(id)sender;
- (IBAction)onDone:(id)sender;



@end

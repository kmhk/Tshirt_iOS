//
//  ColorViewController.h
//  LionTee
//
//  Created by iii on 27/11/14.
//  Copyright (c) 2014 Bai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface ColorViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>
{
    IBOutlet UICollectionView * colorCollectionView;
    NSString  * currentShirtStyle;
    
    NSArray * currentColorList;
}


@end


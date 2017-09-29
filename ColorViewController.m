//
//  ColorViewController.m
//  LionTee
//
//  Created by iii on 27/11/14.
//  Copyright (c) 2014 Bai. All rights reserved.
//

#import "ColorViewController.h"
#import "LaunchViewController.h"

@interface ColorViewController ()

@end

@implementation ColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Choose color";
    
    AppDelegate* MyAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    currentShirtStyle = MyAppDelegate.tshirtImageName;
    
     currentColorList =  [LaunchViewController sharedShirtColorList:currentShirtStyle];
//    currentColorList = [[NSArray alloc] initWithArray:[[LaunchViewController sharedShirtColorList] objectForKey:currentShirtStyle]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate* MyAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    MyAppDelegate.tshirtColor = [currentColorList objectAtIndex:indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"colorCell" forIndexPath:indexPath];
    UIImageView * imageView = (UIImageView *)[cell viewWithTag:456];
    NSString * imageName  = [NSString stringWithFormat:@"%@_%@_front",[currentColorList objectAtIndex:indexPath.row],currentShirtStyle ];
    
    [imageView setImage:[UIImage imageNamed:imageName]];
    
    return  cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
         return [currentColorList count];
}

@end

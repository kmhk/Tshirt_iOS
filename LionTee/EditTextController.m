//
//  EditTextController.m
//  LionTee
//
//  Created by wang on 12/4/14.
//  Copyright (c) 2014 Bai. All rights reserved.
//

#import "EditTextController.h"

@interface EditTextController ()

@end

@implementation EditTextController

@synthesize delegate;
@synthesize currentText;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.tintColor = [self.view tintColor];
    
    UIButton * button  = [[ UIButton alloc] init];
    [button setFrame:CGRectMake(0, 0, 60, 30)];
    [button setTitle:@"Save"  forState:UIControlStateNormal];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self action:@selector(onSave:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderColor = [self.view tintColor].CGColor;
    button.layer.borderWidth = 1.0f;
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightButton;
    [self setTitle:@"Edit Text"];
    
    textView.text = self.currentText;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onSave:(id)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(onEditTextFinish:)]) {
        [self.delegate onEditTextFinish:textView.text];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end

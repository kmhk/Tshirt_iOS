//
//  ShippinngEditViewController.m
//  StripeExample
//
//  Created by wang on 11/6/14.
//  Copyright (c) 2014 Stripe. All rights reserved.
//

#import "ShippinngEditViewController.h"

@interface ShippinngEditViewController ()

@end

@implementation ShippinngEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardDidShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = saveButton;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)save:(id)sender
{
    [currentTextField resignFirstResponder];
    if ([self isValidValue]) {
        NSString * name  = [NSString stringWithFormat:@"%@  %@" , firstName.text, lastName.text];
        NSDictionary * AddressData  = [[NSDictionary alloc] initWithObjectsAndKeys:name , @"name",street1.text,@"line1",street2.text, @"line2" , city.text , @"city" , state.text , @"state", zip.text ,  @"zip", country.text ,@"country", phone.text , @"phone", nil];
        
        NSMutableArray * addressArray = (NSMutableArray *)[[[NSUserDefaults standardUserDefaults] objectForKey:@"AddressDataStore"] mutableCopy];
        if (addressArray == nil) {
            addressArray = [[NSMutableArray alloc] init];
        }
        [addressArray addObject:AddressData];
        [[NSUserDefaults standardUserDefaults] setObject:addressArray forKey:@"AddressDataStore"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(BOOL)isValidValue
{
    if ([firstName.text isEqualToString:@""]) {
        [self showAlert:1];
        return NO;
    }
    if ([lastName.text isEqualToString:@""]) {
        [self showAlert:2];
        return NO;
    }
    
    if ([street1.text isEqualToString:@""]) {
        [self showAlert:3];
        return NO;
        
    }
    
//    if ([street2.text isEqualToString:@""]) {
//        return NO;
//    }
    if ([city.text isEqualToString:@""]) {
        [self showAlert:4];
        return NO;
    }
    
    if ([state.text isEqualToString:@""]) {
        [self showAlert:5];
        return NO;
    }
    
    if ([zip.text isEqualToString:@""]) {
        [self showAlert:6];
        return NO;
    }
    if ([country.text isEqualToString:@""]) {
        [self showAlert:7];
        return NO;
    }
    
    
    return YES;
}


-(void)showAlert:(NSInteger)alertIndex
{
    NSString * alertString  = @"";
    switch (alertIndex) {
        case 1:
            alertString = @"FirtName empty";
            break;
        case 2:
            alertString = @"LastName empty";
            break;
        case 3:
            alertString = @"Street Empty";
            break;
        case 4:
            alertString = @"City Empty";
            break;
        case 5:
            alertString = @"State Emty";
            break;
        case 6:
            alertString = @"Zip Code Empty";
            break;
        case 7:
            alertString = @"Coutry Empty";
            break;
        default:
            break;
    }
    
    [alertLabel setHidden:NO];
    [alertLabel setText:alertString];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self keyboardWillHide];
    
    [textField resignFirstResponder];
    return  YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    currentTextField = textField;
    [alertLabel setHidden:YES];
    if ((textField != firstName) || (textField != lastName) || (textField != street1))
    {
        [self  keyboardWillShow:textField];

    }
    return  YES;
}


////      uiScrollViewDelegate   //////////
- (void)keyboardWillShow:(UITextField *)textField
{
    // if we have no view or are not visible in any window, we don't care
    
    if (!self.isViewLoaded || !self.view.window) {
        return;
    }
    
//    NSDictionary *userInfo = [notification userInfo];
//    
//    CGRect keyboardFrameInWindow;
//    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrameInWindow];
    
   // int h = keyboardFrameInWindow.size.height;
    
    int h = textField.frame.origin.y - lastName.frame.origin.y;
    [scrollView setContentOffset:CGPointMake(0, h) animated:YES];
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height)];
    
}

- (void) keyboardWillHide {
    [scrollView setContentOffset:CGPointMake(0,-(firstName.frame.origin.y) - 10) animated:YES];
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height)];
}


@end

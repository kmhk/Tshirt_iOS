//
//  EditTextController.h
//  LionTee
//
//  Created by wang on 12/4/14.
//  Copyright (c) 2014 Bai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditTextDelegate <NSObject>
-(void)onEditTextFinish:(NSString *) str;
@end

@interface EditTextController : UIViewController
{
    IBOutlet UITextView * textView;
}

@property ( nonatomic , strong) id<EditTextDelegate> delegate;
@property (nonatomic , strong) NSString * currentText;
@end

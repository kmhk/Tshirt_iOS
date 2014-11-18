//
//  Common.h
//  LionTee
//
//  Created by Sam Gabbay on 11/9/14.
//  Copyright (c) 2014 Bai. All rights reserved.
//

#ifndef LionTee_Common_h
#define LionTee_Common_h

#define ShowWaitView(flag, src) \
{ \
if (flag) { \
if ([src viewWithTag:0x100000] != nil) { \
[[src viewWithTag:0x100000] removeFromSuperview]; \
} \
\
[UIApplication sharedApplication].networkActivityIndicatorVisible = YES; \
\
UIView *viewWait = [[UIView alloc] initWithFrame:CGRectMake(src.bounds.size.width / 2 - 2, src.bounds.size.height / 2 - 2, 4, 4)]; \
[viewWait setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]]; \
viewWait.layer.masksToBounds = NO; \
viewWait.layer.cornerRadius = 5; \
[viewWait.layer setBorderWidth:0.5]; \
[viewWait.layer setBorderColor:[UIColor blackColor].CGColor]; \
[viewWait setTag:0x100000]; \
[viewWait setCenter:CGPointMake(src.bounds.size.width / 2, src.bounds.size.height / 2)]; \
[src addSubview:viewWait]; \
\
UIActivityIndicatorView *progress= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]; \
[viewWait addSubview:progress]; \
\
UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 70, 16)]; \
lbl.text = @"Uploading"; \
lbl.textColor = [UIColor whiteColor]; \
lbl.font = [UIFont systemFontOfSize:13]; \
lbl.textAlignment = NSTextAlignmentCenter; \
[viewWait addSubview:lbl]; \
\
[viewWait setFrame:CGRectMake(src.bounds.size.width / 2 - 35, src.bounds.size.height / 2 - 35, 70, 70)]; \
[progress setFrame:CGRectMake(8, 0, 54, 54)]; \
[viewWait setAlpha:0.0]; \
\
[UIView animateWithDuration:0.2 \
animations:^{ \
[viewWait setAlpha:1.0]; \
} \
completion:^(BOOL finished) { \
[progress startAnimating]; \
}]; \
} else { \
\
[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;  \
\
[UIView animateWithDuration:0.2 \
animations:^{ \
[[src viewWithTag:0x100000] setAlpha:0]; \
} \
completion:^(BOOL finished) { \
[[src viewWithTag:0x100000] removeFromSuperview]; \
}]; \
} \
} \


#endif

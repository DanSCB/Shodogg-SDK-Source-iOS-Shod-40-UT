//
//  SHMIDLoginHeaderView.h
//  
//
//  Created by Aamir Khan on 12/11/15.
//  Copyright (c) 2015 Shodogg. All rights reserved.
//S

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HeaderType) {
    HeaderSocial,
    HeaderEmail,
    HeaderSignIn,
    HeaderSignUp
};

@interface SHMIDLoginHeaderView : UIView

+ (SHMIDLoginHeaderView *)headerType:(HeaderType)type
                    parentController:(UIViewController *)topViewController;
@end
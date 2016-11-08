//
//  SHMIDLoginFormView.h
//  
//
//  Created by Aamir Khan on 12/11/15.
//  Copyright (c) 2015 Shodogg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SHMIDRoundedButton.h"
#import "SHMIDLoginViewController.h"

typedef NS_ENUM(NSInteger, FormType){
    FormEmail,
    FormSignIn,
    FormSignUp
};

@protocol SHMIDLoginFormViewDelegate <NSObject>
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
@end

@interface SHMIDLoginFormView : UIView

@property (readonly) FormType type;

@property (weak) id <SHMIDLoginFormViewDelegate> delegate;

@property (nonatomic, readonly) UITextField *emailTextField;
@property (nonatomic, readonly) UITextField *passwordTextField;
@property (nonatomic, readonly) UITextField *firstNameTextField;
@property (nonatomic, readonly) UITextField *lastNameTextField;
@property (nonatomic, readonly) UITextField *activeTextField;
@property (nonatomic, readonly) SHMIDRoundedButton *submitButton;
@property (nonatomic, readonly) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, readonly) UIButton *toggleButton;

+ (SHMIDLoginFormView *)formType:(FormType)type
            parentViewController:(UIViewController *)topViewController;

- (void)textfieldResignActive;
- (void)textfieldBecomeFirstResponder;

@end
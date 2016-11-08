//
//  SHMIDLoginFormView.m
//  
//
//  Created by Aamir Khan on 12/11/15.
//  Copyright (c) 2015 Shodogg. All rights reserved.
//

#import "SHMIDLoginFormView.h"
#import "SHMIDClient.h"

@interface SHMIDLoginFormView()<UITextFieldDelegate,
                                UIAlertViewDelegate>

@property (readwrite) FormType type;
@property (nonatomic, weak) UIViewController *topViewController;
@property (nonatomic, strong)  NSMutableDictionary *views;
@property (nonatomic, readwrite) UITextField *emailTextField;
@property (nonatomic, readwrite) UITextField *passwordTextField;
@property (nonatomic, readwrite) UITextField *firstNameTextField;
@property (nonatomic, readwrite) UITextField *lastNameTextField;
@property (nonatomic, readwrite) UITextField *activeTextField;
@property (nonatomic, readwrite) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, readwrite) SHMIDRoundedButton *submitButton;
@property (nonatomic, readwrite) UIButton *toggleButton;
@property (nonatomic, strong) UIView *inputAccessoryView;
@end

@implementation SHMIDLoginFormView

+ (SHMIDLoginFormView *)formType:(FormType)type
            parentViewController:(UIViewController *)topViewController {
    return [[self alloc] initWithFrame:CGRectZero
                              formType:type
                  parentViewController:topViewController];
}

- (instancetype)initWithFrame:(CGRect)frame
                     formType:(FormType)type
         parentViewController:(UIViewController *)topViewController {
    
    self = [super initWithFrame:frame];

    if (self) {
        
        _type = type;
        _topViewController = topViewController;
        _views = [[NSMutableDictionary alloc] init];
        
        self.emailTextField = [[UITextField alloc] init];
        _emailTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _emailTextField.textAlignment = NSTextAlignmentCenter;
        _emailTextField.textColor = [UIColor colorWithWhite:100.f alpha:.7f];
        _emailTextField.tintColor = [UIColor whiteColor];
        _emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        _emailTextField.keyboardAppearance = UIKeyboardAppearanceDark;
        _emailTextField.returnKeyType = UIReturnKeyNext;
        NSDictionary *emailPlaceholderAttrs =
        @{NSFontAttributeName : [UIFont fontWithName:@"Avenir" size:15.0],
          NSForegroundColorAttributeName : [UIColor colorWithWhite:100.f alpha:.4f]};
        _emailTextField.attributedPlaceholder =
        [[NSAttributedString alloc] initWithString:@"john@shodogg.com" attributes:emailPlaceholderAttrs];
        _emailTextField.delegate = self;

        self.passwordTextField = [[UITextField alloc] init];
        _passwordTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _passwordTextField.textAlignment = NSTextAlignmentCenter;
        _passwordTextField.textColor = [UIColor colorWithWhite:100.f alpha:.7f];
        _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _passwordTextField.keyboardAppearance = UIKeyboardAppearanceDark;
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.returnKeyType = UIReturnKeyGo;
        NSDictionary *passwordPlaceholderAttrs =
        @{NSFontAttributeName : [UIFont fontWithName:@"Avenir" size:15.0],
          NSForegroundColorAttributeName : [UIColor colorWithWhite:100.f alpha:.4f]};
        _passwordTextField.attributedPlaceholder =
        [[NSAttributedString alloc] initWithString:@"Password" attributes:passwordPlaceholderAttrs];
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.delegate = self;
        _passwordTextField.tintColor = [UIColor whiteColor];

        self.firstNameTextField = [[UITextField alloc] init];
        _firstNameTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _firstNameTextField.tintColor = [UIColor whiteColor];
        _firstNameTextField.textColor = [UIColor colorWithWhite:100.f alpha:.6f];
        _firstNameTextField.textAlignment = NSTextAlignmentCenter;
        _firstNameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        _firstNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _firstNameTextField.placeholder = @"John";
        _firstNameTextField.keyboardAppearance = UIKeyboardAppearanceDark;
        _firstNameTextField.returnKeyType = UIReturnKeyNext;
        _firstNameTextField.delegate = self;
        
        self.lastNameTextField  = [[UITextField alloc] init];
        _lastNameTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _lastNameTextField.tintColor = [UIColor whiteColor];
        _lastNameTextField.textColor = [UIColor colorWithWhite:100.f alpha:.6f];
        _lastNameTextField.textAlignment = NSTextAlignmentCenter;
        _lastNameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        _lastNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _lastNameTextField.placeholder = @"Appleseed";
        _lastNameTextField.keyboardAppearance = UIKeyboardAppearanceDark;
        _lastNameTextField.returnKeyType = UIReturnKeyNext;
        _lastNameTextField.delegate = self;
        
        [self configureSubviews];
    }
    return self;
}

- (void)configureSubviews {
    [self configureInputAccessoryView];
    [self configureForm];
}

- (void)configureForm {
    
    UIView *separator = [self textFieldSeparator];
    
    if (_type == FormEmail) {
        
        _emailTextField.inputAccessoryView = _inputAccessoryView;
        
        [_views setObject:_emailTextField forKey:@"EmailTF"];
        [_views setObject:separator forKey:@"Separator"];
        [self addSubview:_emailTextField];
        [self addSubview:separator];
        
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[EmailTF]-10-|"
                                                 options:0 metrics:0 views:_views]];
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[Separator]-10-|"
                                                 options:0 metrics:0 views:_views]];
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[EmailTF(30)]-5-[Separator(1)]-|"
                                                 options:0 metrics:0 views:_views]];
        
    } else if (_type == FormSignIn) {
        
        _passwordTextField.inputAccessoryView = _inputAccessoryView;
        
        [_views setObject:_passwordTextField forKey:@"PasswordTF"];
        [_views setObject:separator forKey:@"Separator"];
        [self addSubview:_passwordTextField];
        [self addSubview:separator];
        
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[PasswordTF]-10-|"
                                                 options:0 metrics:0 views:_views]];
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[Separator]-10-|"
                                                 options:0 metrics:0 views:_views]];
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[PasswordTF(30)]-5-[Separator(1)]-|"
                                                 options:0 metrics:0 views:_views]];
        
    } else if (_type == FormSignUp) {
        
        _firstNameTextField.inputAccessoryView = _inputAccessoryView;
        _lastNameTextField.inputAccessoryView = _inputAccessoryView;
        _passwordTextField.inputAccessoryView = _inputAccessoryView;
        
        UIView *separatorFName = [self textFieldSeparator];
        UIView *separatorLName = [self textFieldSeparator];
        UIView *separatorPassword = [self textFieldSeparator];
        
        [_views setObject:_firstNameTextField forKey:@"FirstName"];
        [_views setObject:_lastNameTextField forKey:@"LastName"];
        [_views setObject:_passwordTextField forKey:@"Password"];
        [_views setObject:separatorFName forKey:@"separatorFName"];
        [_views setObject:separatorLName forKey:@"separatorLName"];
        [_views setObject:separatorPassword forKey:@"separatorPassword"];
        
        [self addSubview:_firstNameTextField];
        [self addSubview:_lastNameTextField];
        [self addSubview:_passwordTextField];
        [self addSubview:separatorFName];
        [self addSubview:separatorLName];
        [self addSubview:separatorPassword];
        
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[FirstName]-10-|"
                                                 options:0 metrics:0 views:_views]];
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:[LastName(==FirstName)]"
                                                 options:0 metrics:0 views:_views]];
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:[Password(FirstName)]|"
                                                 options:0 metrics:0 views:_views]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_firstNameTextField
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_lastNameTextField
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_firstNameTextField
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_passwordTextField
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0 constant:0]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[separatorFName]-10-|"
                                                                     options:0 metrics:0 views:_views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[separatorLName(==separatorFName)]"
                                                                     options:0 metrics:0 views:_views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[separatorPassword(==separatorFName)]"
                                                                     options:0 metrics:0 views:_views]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:separatorFName
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:separatorPassword
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:separatorFName
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:separatorLName
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0 constant:0]];
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:
          @"V:|-5-[FirstName(30)]-[separatorFName(1)]-10-[LastName(==FirstName)]-[separatorLName(1)]-10-[Password(==FirstName)]-[separatorPassword(1)]-|"
                                                 options:0 metrics:0 views:_views]];
    }
}

- (void)configureInputAccessoryView {
    
    NSMutableDictionary *views = [[NSMutableDictionary alloc] init];
    CGSize size = self.frame.size;
    self.inputAccessoryView =
    [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 75)];
    _inputAccessoryView.translatesAutoresizingMaskIntoConstraints = NO;
    [views setObject:_inputAccessoryView forKey:@"InputAV"];
    self.activityIndicator =
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [_activityIndicator setHidesWhenStopped:YES];
    [views setObject:_activityIndicator forKey:@"Indicator"];
    CGRect frame = CGRectMake(0, 0, 80, 40);
    self.submitButton = [[SHMIDRoundedButton alloc] initWithFrame:frame appearance:SHMIDButtonAppearanceWhite];
    _submitButton.translatesAutoresizingMaskIntoConstraints = NO;
    _submitButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:14.f];
    [_submitButton setTitle:@"Continue" forState:UIControlStateNormal];
    [_submitButton addSubview:_activityIndicator];
    [_inputAccessoryView addSubview:_submitButton];
    [views setObject:_submitButton forKey:@"Submit"];
    if (_type == FormSignIn
        || _type == FormSignUp) {
        self.toggleButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _toggleButton.translatesAutoresizingMaskIntoConstraints = NO;
        _toggleButton.tintColor = [UIColor whiteColor];
        _toggleButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:12.f];
        [_inputAccessoryView addSubview:_toggleButton];
        [views setObject:_toggleButton forKey:@"ToggleButton"];
    }
    if (_type == FormEmail) {
        [self.inputAccessoryView addConstraint:
            [NSLayoutConstraint constraintWithItem:_submitButton
                                         attribute:NSLayoutAttributeCenterY
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:_inputAccessoryView
                                         attribute:NSLayoutAttributeCenterY
                                        multiplier:1.f constant:0]];
    } else {
        [self.inputAccessoryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[ToggleButton(200)]"
                                                                                        options:0 metrics:0 views:views]];
        [self.inputAccessoryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[Submit]-5-[ToggleButton(20)]-5-|"
                                                                                        options:0 metrics:0 views:views]];
        [self.inputAccessoryView addConstraint:
            [NSLayoutConstraint constraintWithItem:self.toggleButton
                                         attribute:NSLayoutAttributeCenterX
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self.inputAccessoryView
                                         attribute:NSLayoutAttributeCenterX
                                        multiplier:1.0f constant:0]];
    }
    
    [self.inputAccessoryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[Submit(150)]"
                                                                                   options:0 metrics:0 views:views]];
    [self.inputAccessoryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[Submit(40)]"
                                                                                    options:0 metrics:0 views:views]];
    [self.inputAccessoryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[Indicator]-5-|"
                                                                                    options:0 metrics:0 views:views]];
    [self.inputAccessoryView addConstraint:
        [NSLayoutConstraint constraintWithItem:_submitButton
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.inputAccessoryView
                                     attribute:NSLayoutAttributeCenterX
                                    multiplier:1.0f constant:0]];
    [_submitButton addConstraint:
        [NSLayoutConstraint constraintWithItem:_submitButton
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:_activityIndicator
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1.f constant:0]];
}

- (UIView *)textFieldSeparator {
    UIView *separator = [[UIView alloc] init];
    separator.translatesAutoresizingMaskIntoConstraints = NO;
    separator.backgroundColor = [UIColor whiteColor];
    separator.alpha = .6f;
    return separator;
}

#pragma mark - TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [self.delegate textFieldShouldReturn:textField];
    }
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeTextField = nil;
}

#pragma mark - TextField responding

- (void)textfieldResignActive {
    if (self.activeTextField
        && [self.activeTextField respondsToSelector:@selector(resignFirstResponder)]) {
        [self.activeTextField resignFirstResponder];
    }
}

- (void)textfieldBecomeFirstResponder {
    UIResponder *responder;
    switch (_type) {
        case FormEmail:
            responder = _emailTextField;
            break;
        case FormSignIn:
            responder = _passwordTextField;
            break;
        case FormSignUp:
            responder = _firstNameTextField;
            break;
    }
    [responder becomeFirstResponder];
}

#pragma mark - Alerting

- (BOOL)shouldShowRequiredFieldAlert {
    return ![_firstNameTextField.text length]
    || ![_lastNameTextField.text length]
    || ![_emailTextField.text length]
    || ![_passwordTextField.text length];
}

- (void)showRequiredFieldAlert {
    NSError *error;
    if (![_firstNameTextField.text length]
        ||![_lastNameTextField.text length]) {
        error = [NSError errorWithLocalizedDescription:@"First and last name are required."];
        [error showAsAlertInController:_topViewController];
    }
    else if (![_emailTextField.text length]) {
        error = [NSError errorWithLocalizedDescription:@"Email Address is required."];
        [error showAsAlertInController:_topViewController];
    }
    else if(![_passwordTextField.text length]) {
        error = [NSError errorWithLocalizedDescription:@"Password is required."];
        [error showAsAlertInController:_topViewController];
    }
}

- (void)showSignupSuccessAlert {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Email Verification"
                          message:@"Please check your email to verify account"
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil];
    [alert setTag:1];
    [alert show];
}

- (void)showUserAlreadyExistsAlert {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Already Registered"
                          message:@"The email you have chosen has already been registered"
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil];
    [alert setTag:1];
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1 &&
        [_topViewController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [_topViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

/*
#pragma mark - UIAlerting
 
- (void)setupKVO {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShowNotification:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)teardownKVO {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardDidShowNotification:(NSNotification *)notification {
    UIScrollView *scrollView = [self getScrollView];
    NSDictionary *info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [_topViewController.view convertRect:kbRect fromView:nil];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = _topViewController.view.frame;
    aRect.size.height -= kbRect.size.height;
    if (!CGRectContainsPoint(aRect, _activeTextField.frame.origin) ) {
        [scrollView scrollRectToVisible:_activeTextField.frame animated:YES];
    }
}

- (void)keyboardWillHideNotification:(NSNotification *)notification {
    UIScrollView *scrollView = [self getScrollView];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

- (UIScrollView *)getScrollView {
    return [(UIScrollView *)_topViewController.view subviews][1];
}*/

@end
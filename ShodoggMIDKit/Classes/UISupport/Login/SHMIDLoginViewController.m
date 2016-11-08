//
//  SHMIDLoginViewController.m
//  Pods
//
//  Created by Aamir Khan on 12/11/15.
//
//

#import "SHMIDLoginViewController.h"
#import "SHMIDClient.h"
#import "SHMIDLoginHeaderView.h"
#import "SHMIDLoginFormView.h"
#import "SHMIDOAuthChooser.h"

@interface SHMIDLoginViewController () <SHMIDLoginFormViewDelegate>
@property (nonatomic,   copy) SHLoginDoneBlock done;
@property (nonatomic, strong) SHMIDLoginFormView *formView;
@property (nonatomic, strong) SHMIDOAuthChooser *chooser;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation SHMIDLoginViewController

+ (SHMIDLoginViewController *)controllerWithModalPresentationStyle:(UIModalPresentationStyle)presentationStyle
                                              loginCompletionBlock:(SHLoginDoneBlock)block {
    return [[self alloc] initWithModalPresentationStyle:presentationStyle
                                        completionBlock:block];
}

- (instancetype)initWithModalPresentationStyle:(UIModalPresentationStyle)style
                               completionBlock:(SHLoginDoneBlock)block {
    self = [super init];
    if (self) {
        _done = block;
//        self.modalPresentationStyle = style;
        [self configureSubviews];
    }
    return self;
}

- (void)configureSubviews {
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view insertSubview:blurView atIndex:0];
    
    self.contentView = [[UIView alloc] init];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *navigationBarView = [[UIView alloc] init];
    navigationBarView.translatesAutoresizingMaskIntoConstraints = NO;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.tintColor = [UIColor whiteColor];
    [button setTitle:@"X" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarView addSubview:button];

    SHMIDLoginHeaderView *header;
    header = [SHMIDLoginHeaderView headerType:HeaderSignIn parentController:self];
    header.translatesAutoresizingMaskIntoConstraints = NO;
    self.formView = [SHMIDLoginFormView formType:FormSignIn parentViewController:self];
    _formView.translatesAutoresizingMaskIntoConstraints = NO;
    [_formView.submitButton addTarget:self action:@selector(submitButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_formView.toggleButton addTarget:self action:@selector(toggleButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    _formView.toggleButton.hidden = YES;
    _formView.delegate = self;
    [self.contentView addSubview:header];
    [self.contentView addSubview:_formView];
    [self.view addSubview:navigationBarView];
    [self.view addSubview:_contentView];
    
    NSDictionary *barViews = @{@"NavigationBarView": navigationBarView, @"Button" : button};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[NavigationBarView]|" options:0 metrics:0 views:barViews]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[NavigationBarView(44)]" options:0 metrics:0 views:barViews]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[Button(30)]" options:0 metrics:0 views:barViews]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[Button(30)]" options:0 metrics:0 views:barViews]];
    
    NSDictionary *views = @{@"BlurView"    : blurView,
                            @"ContentView" : self.contentView,
                            @"Header"      : header,
                            @"FormView"    : self.formView};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[Header]|"
                                                                             options:0 metrics:0 views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[FormView]|"
                                                                             options:0 metrics:0 views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[Header]-10-[FormView]-|"
                                                                             options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[ContentView]|"
                                                                      options:0 metrics:0 views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_contentView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:navigationBarView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.f constant:10.f]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[BlurView]|"
                                                                      options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[BlurView]|"
                                                                      options:0 metrics:0 views:views]];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.formView textfieldBecomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.formView textfieldResignActive];
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - SHMIDLoginFormViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _formView.firstNameTextField) {
        return [_formView.lastNameTextField becomeFirstResponder];
    }
    else if (textField == _formView.lastNameTextField) {
        return [_formView.passwordTextField becomeFirstResponder];
    }
    else if (textField == _formView.passwordTextField) {
        if (![_formView.passwordTextField.text length]) {
            return [_formView.firstNameTextField becomeFirstResponder];
        }
        (_formView.type == FormSignIn) ? [self signin] : [self signup];
    }
    return NO;
}

#pragma mark - Actions

- (void)dismiss {
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self dismiss];
}

- (void)submitButtonTapped:(id)sender {
    switch (self.formView.type) {
        case FormSignIn:
            [self signin];
            break;
        case FormSignUp:
            [self signup];
            break;
        default:
            break;
    }
}

- (void)toggleButtonTapped:(id)sender {
    //TODO:
    if (_formView.type == FormSignIn) {
        //_formView.type = FormSignUp;
    } else if (_formView.type == FormSignUp) {
        //_formView.type = FormSignIn;
    }
    [_formView.toggleButton setTitle:[self toggleButtonTitle:_formView.type] forState:UIControlStateNormal];
}

- (NSString *)toggleButtonTitle:(FormType)type {
    NSString *title;
    switch (type) {
        case FormEmail:
        case FormSignIn:
            title = @"Need an account? Sign up";
            break;
        case FormSignUp:
            title = @"Have an account? Sign in";
            break;
    }
    return title;
}

#pragma mark - API
- (void)signin {
    NSString *email = self.emailAddress;
    NSString *password = self.formView.passwordTextField.text;
    if (![email length]
        || ![password length]) {
        NSError *error = [NSError errorWithLocalizedDescription:@"Email and password are required."];
        [error showAsAlertInController:self];
        return;
    }
    [self.formView.activityIndicator startAnimating];
    __weak typeof(self) weakself = self;
    __weak typeof(SHMIDClient *) weakClient = [SHMIDClient sharedClient];
    [[SHMIDClient sharedClient]
        loginWithEmail:email
        password:password
     	completionBlock:^(NSError *error) {
            [weakself.formView.activityIndicator stopAnimating];
            if (error) {
                [error showAsAlertInController:weakself];
            }
            if ([weakClient.delegate respondsToSelector:@selector(didFinishAuthenticationWithError:)]) {
                [weakClient.delegate didFinishAuthenticationWithError:error];
            }
        }];
}

- (void)signup {
    //TODO:
}
@end
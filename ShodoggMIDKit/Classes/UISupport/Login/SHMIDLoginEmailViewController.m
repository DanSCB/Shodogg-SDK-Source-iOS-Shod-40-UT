//
//  SHMIDLoginEmailViewController.m
//  Pods
//
//  Created by Aamir Khan on 2/25/16.
//
//

#import "SHMIDLoginEmailViewController.h"
#import "SHMIDLoginHeaderView.h"
#import "SHMIDLoginFormView.h"

@interface SHMIDLoginEmailViewController () <SHMIDLoginFormViewDelegate>
@property (nonatomic) SHMIDLoginFormView *formView;
@end

@implementation SHMIDLoginEmailViewController

+ (instancetype)controllerWithModalPresentationStyle:(UIModalPresentationStyle)style {
    return [[self alloc] initWithModalPresentationStyle:style];
}

- (instancetype)initWithModalPresentationStyle:(UIModalPresentationStyle)style {
    if (self = [super init]) {
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
    
    UIView *contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;

    UIView *navigationBarView = [[UIView alloc] init];
    navigationBarView.translatesAutoresizingMaskIntoConstraints = NO;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.tintColor = [UIColor whiteColor];
    [button setTitle:@"X" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarView addSubview:button];
    
    SHMIDLoginHeaderView *header;
    header = [SHMIDLoginHeaderView headerType:HeaderEmail parentController:self];
    header.translatesAutoresizingMaskIntoConstraints = NO;
    self.formView = [SHMIDLoginFormView formType:FormEmail parentViewController:self];
    _formView.translatesAutoresizingMaskIntoConstraints = NO;
    [_formView.submitButton addTarget:self action:@selector(submitButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    _formView.delegate = self;
    [contentView addSubview:header];
    [contentView addSubview:_formView];
    [self.view addSubview:navigationBarView];
    [self.view addSubview:contentView];
    
    NSDictionary *barViews = @{@"NavigationBarView": navigationBarView, @"Button" : button};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[NavigationBarView]|" options:0 metrics:0 views:barViews]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[NavigationBarView(44)]" options:0 metrics:0 views:barViews]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[Button(30)]" options:0 metrics:0 views:barViews]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[Button(30)]" options:0 metrics:0 views:barViews]];

    NSDictionary *views = @{@"Header" : header, @"FormView": _formView, @"ContentView": contentView, @"BlurView": blurView};
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[Header]|" options:0 metrics:0 views:views]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[FormView]|" options:0 metrics:0 views:views]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[Header]-20-[FormView]-|" options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[ContentView]|"
                                                                      options:0 metrics:0 views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.formView textfieldBecomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.formView textfieldResignActive];
    [super viewWillDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Navigation

- (void)cancelButtonTapped:(id)sender {
    [self dismiss];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)gotoSignIn {
    SHMIDLoginViewController *loginViewController =
    [SHMIDLoginViewController controllerWithModalPresentationStyle:UIModalPresentationOverCurrentContext
                                              loginCompletionBlock:^(NSError *error) {
                                              }];
    loginViewController.emailAddress = _formView.emailTextField.text;
    [self presentViewController:loginViewController animated:YES completion:nil];
}

#pragma mark - FormView Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.formView.emailTextField) {
        [self submitButtonTapped:nil];
    }
    return NO;
}

#pragma mark - Form Actions

- (void)submitButtonTapped:(id)sender {
    //TODO:email address validity
    if (![self.formView.emailTextField.text length]) {
        //TODO:Alerting
        return;
    }
    [self gotoSignIn];
}

@end
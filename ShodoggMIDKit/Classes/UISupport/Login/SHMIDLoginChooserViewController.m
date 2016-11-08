//
//  SHMIDLoginChooserViewController.m
//  Pods
//
//  Created by Aamir Khan on 2/25/16.
//
//

#import "SHMIDLoginChooserViewController.h"
#import "SHMIDLoginHeaderView.h"
#import "SHMIDOAuthChooser.h"

@interface SHMIDLoginChooserViewController ()<SHMIDClientDelegate>
@property (nonatomic, copy) SHLoginChooserDoneBlock doneBlock;
@end

@implementation SHMIDLoginChooserViewController

+ (instancetype)controllerWithCompletionBlock:(SHLoginChooserDoneBlock)completion {
    return [[self alloc] initWithCompletionBlock:completion];
}

- (instancetype)initWithCompletionBlock:(SHLoginChooserDoneBlock)completion {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _doneBlock = completion;
        [self configureSubviews];
    }
    return self;
}

- (void)configureSubviews {
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurredView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurredView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view insertSubview:blurredView atIndex:0];

    UIView *contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *navigationBarView = [[UIView alloc] init];
    navigationBarView.translatesAutoresizingMaskIntoConstraints = NO;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.tintColor = [UIColor whiteColor];
    [button setTitle:@"X" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarView addSubview:button];
    
    SHMIDLoginHeaderView *header;
    header = [SHMIDLoginHeaderView headerType:HeaderSocial parentController:self];
    header.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *services = @[@"FACEBOOK", @"GOOGLE", @"EMAIL"];
    SHMIDOAuthChooser *chooser;
    chooser = [SHMIDOAuthChooser chooserWithServicesAndOrder:services parentViewController:self];
    chooser.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:header];
    [contentView addSubview:chooser];
    [self.view addSubview:navigationBarView];
    [self.view addSubview:contentView];
    
    NSDictionary *barViews = @{@"NavigationBarView": navigationBarView, @"Button" : button};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[NavigationBarView]|" options:0 metrics:0 views:barViews]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[NavigationBarView(44)]" options:0 metrics:0 views:barViews]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[Button(30)]" options:0 metrics:0 views:barViews]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[Button(30)]" options:0 metrics:0 views:barViews]];
    
    NSDictionary *views = @{@"Header" : header, @"Chooser": chooser, @"ContentView": contentView, @"BlurredView": blurredView};
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[Header]|" options:0 metrics:0 views:views]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[Chooser]|" options:0 metrics:0 views:views]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[Header]-50-[Chooser]-|" options:0 metrics:0 views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:blurredView
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:blurredView
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0f constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[ContentView]|"
                                                                      options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[BlurredView]|"
                                                                      options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[BlurredView]|"
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark -

- (void)cancelButtonTapped:(id)sender {
    [self dismiss];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MIDClient delegate

- (void)didFinishAuthenticationWithError:(NSError *)error {
    if (error) {
        [error showAsAlertInController:self];
    } else {
        if (_doneBlock) {
            _doneBlock(error);
        }
    }
}

@end
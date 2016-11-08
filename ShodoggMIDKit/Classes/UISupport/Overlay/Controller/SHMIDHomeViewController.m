//
//  SHMIDHomeViewController.m
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 5/19/16.
//
//

#import "SHMIDHomeViewController.h"
#import "SHMIDSettingsViewController.h"
#import "SHMIDCastingView.h"
#import "SHMIDPlaylistView.h"
#import "SHMIDCastController.h"
#import "SHMIDMediaItem.h"
#import "SHMIDClient.h"
#import "SHMIDUtilities.h"
#import "SHMIDRoundedButton.h"
#import "SHMIDCastControlsView.h"
#import "SHMIDScreen.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "LNPopupController.h"

@interface SHMIDHomeViewController ()
    <UIScrollViewDelegate,
     SHMIDSettingsViewControllerDelegate>

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIView *containerView;
@property (nonatomic) UIImageView *mediaThumbnailView;
@property (nonatomic) UIActivityIndicatorView *indicatorView;
@property (nonatomic) UILabel *contentOwnerMarkLabel;
@property (nonatomic) UILabel *contentOwnerNameLabel;
@property (nonatomic) UILabel *contentTitleLabel;
@property (nonatomic) UIButton *castButton;
@property (nonatomic) SHMIDRoundedButton *saveButton;
@property (nonatomic) SHMIDCastControlsView *castControlsView;
@property (nonatomic) SHMIDPlaylistView *playlistView;
@property (nonatomic) SHMIDCastingView *castingView;
@property (nonatomic) CGFloat lastYAxisContentOffset;
@property (nonatomic) NSLayoutConstraint *contentTitleLabelTopAnchor;
@property (nonatomic) NSArray *contentOwnerNameLabelConstraints;
@property (nonatomic) BOOL atHome;
@property (nonatomic) BOOL showingContentOwnerNameLabel;
@property (nonatomic) BOOL containsPlaylistView;
@property (nonatomic) BOOL containsCastView;
@property (nonatomic) BOOL waitingCastingViewDisplay;
@property (nonatomic) UIView *currentCastInfoView;
@property (nonatomic) UILabel *currentCastInfoViewDetailLabel;
@property (nonatomic) BOOL toolbarModeEnabled;
@property (nonatomic) UINavigationController *toolbarController;
@property (nonatomic) UINavigationController *toolbarPresentingController;
@property (nonatomic) UIButton *toolbarPlaybackButton;

@property (nonatomic) BOOL settingsViewInPresentation;
@property (nonatomic) BOOL settingsViewWasDismissed;

@end

@implementation SHMIDHomeViewController {

    CGFloat imageViewHeight;
    CGFloat imageViewWidth;
    CGFloat buttonHeight;
    CGFloat buttonWidth;
    CGFloat offsetCast;
    CGFloat offsetHome;
    CGFloat offsetSave;
    CGFloat containerViewHeight;
    UIImage *chevronDownImage;
    UIImage *settingsButtonImage;
    UIImage *chevronLeftImage;
    UIImage *saveButtonImage;
    UIImage *saveButtonImageFill;
    UIImage *castButtonImage;
    UIImage *castButtonImageFill;
    CGAffineTransform imageScaleFocussed;
    CGAffineTransform imageScaleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {

    [super viewDidLoad];

    CGRect  bounds          = self.view.bounds;
    CGFloat viewHeight      = CGRectGetHeight(bounds);
    CGFloat viewWidth       = CGRectGetWidth(bounds);
    containerViewHeight     = viewHeight/2.0 - 24.0;
    imageViewHeight         = roundf(viewHeight*0.30);
    imageViewWidth          = roundf(viewWidth*0.80);
    CGFloat buttonVPos      = roundf(((viewHeight*0.50-(containerViewHeight*0.50))-44.0)/2.0);
    offsetCast              = (imageViewHeight*2.0)-24.0;
    offsetHome              = imageViewHeight;
    offsetSave              = 0.0;
    buttonHeight            = 90.0;
    buttonWidth             = 64.0;
    chevronDownImage        = [SHMIDUtilities imageNamed:@"icon_bar_chevron_down"];
    chevronLeftImage        = [SHMIDUtilities imageNamed:@"icon_bar_chevron_left"];
    castButtonImage         = [SHMIDUtilities imageNamed:@"icon_home_cast"];
    saveButtonImage         = [SHMIDUtilities imageNamed:@"icon_home_playlist"];
    castButtonImageFill     = [SHMIDUtilities imageNamed:@"icon_home_cast_fill"];
    saveButtonImageFill     = [SHMIDUtilities imageNamed:@"icon_home_playlist_fill"];
    settingsButtonImage     = [SHMIDUtilities imageNamed:@"icon_nav_settings_outline"];
    SHMIDMediaItem *context = [[SHMIDCastController sharedInstance] contextItem];
    
    [self applyBlurEffect];
    self.containerView = [[UIView alloc] initWithFrame:bounds];
    _containerView.translatesAutoresizingMaskIntoConstraints = NO;

    self.mediaThumbnailView = [[UIImageView alloc] init];
    _mediaThumbnailView.translatesAutoresizingMaskIntoConstraints = NO;
    _mediaThumbnailView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *placeholderImage = [SHMIDUtilities imageNamed:@"media_video_placeholder"];
    NSURL *posterImageURL = [NSURL URLWithString:context.posterURL];
    [_mediaThumbnailView sd_setImageWithURL:posterImageURL placeholderImage:placeholderImage];
    [_containerView addSubview:_mediaThumbnailView];

    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    _indicatorView.hidesWhenStopped = YES;
    [self.mediaThumbnailView addSubview:_indicatorView];
    
    UIColor *whiteColor = [UIColor whiteColor];
    self.contentOwnerMarkLabel = [[UILabel alloc] init];
    _contentOwnerMarkLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _contentOwnerMarkLabel.font = [UIFont fontWithName:@"AvenirNext-Heavy" size:14.0];
    _contentOwnerMarkLabel.textAlignment = NSTextAlignmentCenter;
    _contentOwnerMarkLabel.textColor = whiteColor;
    _contentOwnerMarkLabel.text = context.show.uppercaseString;
    _contentOwnerMarkLabel.alpha = 0.7;
    [self.mediaThumbnailView addSubview:_contentOwnerMarkLabel];

    self.contentOwnerNameLabel = [[UILabel alloc] init];
    _contentOwnerNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _contentOwnerNameLabel.font = [UIFont fontWithName:@"AvenirNext-UltraLight" size:32.0];
    _contentOwnerNameLabel.textAlignment = NSTextAlignmentCenter;
    _contentOwnerNameLabel.textColor = whiteColor;
    _contentOwnerNameLabel.text = context.show.uppercaseString;
    
    self.contentTitleLabel = [[UILabel alloc] init];
    _contentTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _contentTitleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14.0];
    _contentTitleLabel.textAlignment = NSTextAlignmentCenter;
    _contentTitleLabel.textColor = whiteColor;
    _contentTitleLabel.numberOfLines = 2;
    _contentTitleLabel.text = context.title;
    _contentTitleLabel.alpha = 0.7;
    [_containerView addSubview:_contentTitleLabel];
    
    UIView *contentView = [[UIView alloc] initWithFrame:bounds];
    CGRect frame = contentView.frame;
    frame.size.height += imageViewHeight*2;
    contentView.frame = frame;
    [contentView addSubview:_containerView];
    
    self.castButton = [[UIButton alloc] init];
    _castButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_castButton addTarget:self action:@selector(castButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_castButton setImage:castButtonImage forState:UIControlStateNormal];
    [_castButton setTitle:@"C A S T" forState:UIControlStateNormal];
    _castButton.titleLabel.textAlignment    = NSTextAlignmentCenter;
    _castButton.titleLabel.font             = [UIFont fontWithName:@"AvenirNext-Regular" size:12.0];
    _castButton.titleLabel.alpha            = 0.0;
    _castButton.titleEdgeInsets             = UIEdgeInsetsMake(74.0, -64.0, 0.0, 0.0);
    _castButton.imageEdgeInsets             = UIEdgeInsetsMake(-30.0, 0, 0, 0);
    _castButton.imageView.contentMode       = UIViewContentModeScaleAspectFit;
    [contentView addSubview:_castButton];
    
    self.saveButton = [[UIButton alloc] init];
    _saveButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_saveButton addTarget:self action:@selector(saveButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_saveButton setImage:saveButtonImage forState:UIControlStateNormal];
    [_saveButton setTitle:@"S A V E" forState:UIControlStateNormal];
    _saveButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _saveButton.titleLabel.font          = [UIFont fontWithName:@"AvenirNext-Regular" size:12.0];
    _saveButton.titleLabel.alpha         = 0.0;
    _saveButton.titleEdgeInsets          = UIEdgeInsetsMake(-74.0, -64.0, 0.0, 0.0);
    _saveButton.imageEdgeInsets          = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0);
    _saveButton.imageView.contentMode    = UIViewContentModeScaleAspectFit;
    [contentView addSubview:_saveButton];
    
    self.scrollView  = [[UIScrollView alloc] init];
    [self.scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.scrollView setDelegate:self];
    [self.scrollView setContentOffset:CGPointMake(0, imageViewHeight)];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setContentSize:contentView.frame.size];
    [self.scrollView addSubview:contentView];
    [self.view addSubview:_scrollView];
    
    self.currentCastInfoView = [[UIView alloc] init];
    _currentCastInfoView.translatesAutoresizingMaskIntoConstraints = NO;
    _currentCastInfoView.hidden = YES;
    
    UILabel *currentCastInfoViewTitleLabel = [[UILabel alloc] init];
    currentCastInfoViewTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    currentCastInfoViewTitleLabel.textAlignment = NSTextAlignmentCenter;
    currentCastInfoViewTitleLabel.textColor = [UIColor whiteColor];
    currentCastInfoViewTitleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12.0];
    currentCastInfoViewTitleLabel.text = @"Currently Casting:";
    
    self.currentCastInfoViewDetailLabel = [[UILabel alloc] init];
    _currentCastInfoViewDetailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _currentCastInfoViewDetailLabel.numberOfLines = 2;
    _currentCastInfoViewDetailLabel.textAlignment = NSTextAlignmentCenter;
    _currentCastInfoViewDetailLabel.textColor = [UIColor whiteColor];
    _currentCastInfoViewDetailLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12.0];
    _currentCastInfoViewDetailLabel.text = [SHMIDScreen sharedScreen].nowPlaying.title;
    
    [_currentCastInfoView addSubview:currentCastInfoViewTitleLabel];
    [_currentCastInfoView addSubview:_currentCastInfoViewDetailLabel];
    [self.view addSubview:_currentCastInfoView];
    
    // MARK: AutoLayout
    NSLayoutConstraint *containerViewHeightAnchor= [_containerView.heightAnchor constraintEqualToConstant:containerViewHeight];
    NSLayoutConstraint *containerViewWidthAnchor = [_containerView.widthAnchor constraintEqualToConstant:viewWidth];
    NSLayoutConstraint *containerViewCenterX     = [_containerView.centerXAnchor constraintEqualToAnchor:contentView.centerXAnchor];
    NSLayoutConstraint *containerViewCenterY     = [_containerView.centerYAnchor constraintEqualToAnchor:contentView.centerYAnchor];
    [NSLayoutConstraint activateConstraints:@[containerViewCenterX, containerViewCenterY, containerViewHeightAnchor, containerViewWidthAnchor]];
    NSLayoutConstraint *mediaThumbnailHeight  = [_mediaThumbnailView.heightAnchor constraintEqualToConstant:imageViewHeight];
    NSLayoutConstraint *mediaThumbnailWidth   = [_mediaThumbnailView.widthAnchor constraintEqualToConstant:imageViewWidth];
    NSLayoutConstraint *mediaThumbnailCenterX = [_mediaThumbnailView.centerXAnchor constraintEqualToAnchor:_containerView.centerXAnchor];
    NSLayoutConstraint *mediaThumbnailCenterY = [_mediaThumbnailView.centerYAnchor constraintEqualToAnchor:_containerView.centerYAnchor];
    NSLayoutConstraint *indicatorViewCenterX  = [_indicatorView.centerXAnchor constraintEqualToAnchor:_mediaThumbnailView.centerXAnchor];
    NSLayoutConstraint *indicatorViewCenterY  = [_indicatorView.centerYAnchor constraintEqualToAnchor:_mediaThumbnailView.centerYAnchor];
    NSLayoutConstraint *castButtonBottomAnchor= [_castButton.centerYAnchor constraintEqualToAnchor:_containerView.topAnchor constant:-buttonVPos];
    NSLayoutConstraint *saveButtonTopAnchor   = [_saveButton.centerYAnchor constraintEqualToAnchor:_containerView.bottomAnchor constant:buttonVPos];
    [NSLayoutConstraint activateConstraints:@[mediaThumbnailHeight, mediaThumbnailWidth, mediaThumbnailCenterX, mediaThumbnailCenterY, indicatorViewCenterX, indicatorViewCenterY, castButtonBottomAnchor, saveButtonTopAnchor]];
    NSLayoutConstraint *contentOwnerLabelCenterX      = [_contentOwnerMarkLabel.centerXAnchor constraintEqualToAnchor:_mediaThumbnailView.centerXAnchor];
    NSLayoutConstraint *contentOwnerLabelBottomAnchor = [_contentOwnerMarkLabel.bottomAnchor constraintEqualToAnchor:_mediaThumbnailView.bottomAnchor constant:-(imageViewHeight * 0.10)];
    NSLayoutConstraint *contentTitleLabelCenterX      = [_contentTitleLabel.centerXAnchor constraintEqualToAnchor:_mediaThumbnailView.centerXAnchor];
    self.contentTitleLabelTopAnchor                   = [_contentTitleLabel.topAnchor constraintEqualToAnchor:_mediaThumbnailView.bottomAnchor constant:10.0];
    NSLayoutConstraint *contentTitleLabelWidth        = [_contentTitleLabel.widthAnchor constraintEqualToAnchor:contentView.widthAnchor multiplier:0.80];
    [NSLayoutConstraint activateConstraints:@[contentOwnerLabelCenterX, contentOwnerLabelBottomAnchor, contentTitleLabelCenterX, _contentTitleLabelTopAnchor, contentTitleLabelWidth]];
    NSLayoutConstraint *buttonWidthConstraint  = [_castButton.widthAnchor constraintEqualToConstant:buttonWidth];
    NSLayoutConstraint *buttonHeightConstraint = [_castButton.heightAnchor constraintEqualToConstant:buttonHeight];
    NSLayoutConstraint *buttonLabelWidth       = [_castButton.titleLabel.widthAnchor constraintEqualToAnchor:_castButton.widthAnchor];
    NSLayoutConstraint *castCenterX            = [_castButton.centerXAnchor  constraintEqualToAnchor:self.view.centerXAnchor];
    NSLayoutConstraint *buttonEqualWidths      = [_saveButton.widthAnchor constraintEqualToAnchor:_castButton.widthAnchor];
    NSLayoutConstraint *buttonEqualHeights     = [_saveButton.heightAnchor constraintEqualToAnchor:_castButton.heightAnchor];
    NSLayoutConstraint *saveButtonLabelWidth   = [_saveButton.titleLabel.widthAnchor constraintEqualToAnchor:_saveButton.widthAnchor];
    NSLayoutConstraint *saveCenterX            = [_saveButton.centerXAnchor  constraintEqualToAnchor:self.view.centerXAnchor];
    [NSLayoutConstraint activateConstraints:@[buttonWidthConstraint, buttonHeightConstraint, buttonLabelWidth, castCenterX, buttonEqualWidths, buttonEqualHeights, saveButtonLabelWidth, saveCenterX]];
    
    NSDictionary *views = @{@"CurrentCastInfoViewTitleLabel" : currentCastInfoViewTitleLabel, @"CurrentCastInfoViewDetailLabel" : _currentCastInfoViewDetailLabel};
    [_currentCastInfoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[CurrentCastInfoViewTitleLabel][CurrentCastInfoViewDetailLabel]|" options:0 metrics:0 views:views]];
    [_currentCastInfoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[CurrentCastInfoViewDetailLabel]-20-|" options:0 metrics:0 views:views]];
    NSLayoutConstraint *castInfoViewTitleLabelCenterXAnchor = [currentCastInfoViewTitleLabel.centerXAnchor constraintEqualToAnchor:_currentCastInfoView.centerXAnchor];
    NSLayoutConstraint *castInfoViewLeadingAnchor  = [_currentCastInfoView.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor];
    NSLayoutConstraint *castInfoViewTrailingAnchor = [_currentCastInfoView.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor];
    NSLayoutConstraint *castInfoViewBottomAnchor   = [_currentCastInfoView.bottomAnchor constraintEqualToAnchor:self.containerView.topAnchor constant:8.0];
    [NSLayoutConstraint activateConstraints:@[castInfoViewTitleLabelCenterXAnchor, castInfoViewLeadingAnchor, castInfoViewTrailingAnchor, castInfoViewBottomAnchor]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_scrollView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_scrollView)]];
    
    self.atHome         = YES;
    imageScaleDefault   = CGAffineTransformScale(self.mediaThumbnailView.transform, 1.0, 1.0);
    imageScaleFocussed  = CGAffineTransformScale(self.mediaThumbnailView.transform, 1.28, 1.18);
    [self adjustCastButtonAppearance];
    [self setupHomeNavigation];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self shouldShowActivityProgress];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Regular" size:18.0]}];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processMIDInitDoneNotification:) name:kMIDInitDoneNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(castingBeganNotification:) name:kMIDCastingBeganNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(castingEndedNotification:) name:kMIDCastingEndedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackChangedNotification:) name:kMIDScreenPlaybackChangedNotification object:nil];
    
    if (self.settingsViewWasDismissed) {
        self.settingsViewInPresentation  = NO;
        return;
    }
    if (self.showSelectedContext) {
        [self transitionToHomeNoAnimation];
        [self shouldShowCurrentCastView];
    } else if (self.shouldShowCastDestinations) {
        [self transitionToCastNoAnimation];
        [self shouldHideCurrentCastView];
    } else {
        [self showWithNowPlayingContext];
        [self shouldHideCurrentCastView];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.settingsViewInPresentation) {
        return;
    }
    self.showSelectedContext = NO;
    self.shouldShowCastDestinations = NO;
    self.settingsViewWasDismissed = NO;
    [self removePlaylistViewInView];
    if (!self.toolbarModeEnabled) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

#pragma mark - Toolbar

- (void)dismissToolbar {
    self.toolbarModeEnabled = NO;
    [self.toolbarPresentingController dismissPopupBarAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)minimizeToolbar {
    [self.toolbarPresentingController closePopupAnimated:YES completion:nil];
}

- (void)openToolBar {
    [self.toolbarPresentingController openPopupAnimated:YES completion:nil];
}

- (void)switchToToolbarFromController:(UIViewController *)controller openOnPresentation:(BOOL)open {
    if (self.toolbarModeEnabled) {
        [self openToolBar];
        return;
    }
    self.toolbarPresentingController = controller.navigationController;
    SHMIDMediaItem *nowPlaying = [[SHMIDScreen sharedScreen] nowPlaying];
    if (!self.toolbarPlaybackButton) {
        self.toolbarPlaybackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        self.toolbarPlaybackButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.toolbarPlaybackButton.showsTouchWhenHighlighted = YES;
        [self.toolbarPlaybackButton setTintColor:[UIColor whiteColor]];
        [self.toolbarPlaybackButton addTarget:self action:@selector(toolbarPlaybackButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (!self.toolbarController) {
        self.toolbarController = [[UINavigationController alloc] initWithRootViewController:self];
        self.toolbarController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    UIImage *seekButtonImage = [SHMIDUtilities imageNamed:@"icon_media_rewind"];
    UIButton *seekButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 24)];
    seekButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    seekButton.showsTouchWhenHighlighted = YES;
    [seekButton setImage:seekButtonImage forState:UIControlStateNormal];
    [seekButton addTarget:self action:@selector(toolbarSeekBackButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemLeft  = [[UIBarButtonItem alloc] initWithCustomView:seekButton];
    UIBarButtonItem *itemRight = [[UIBarButtonItem alloc] initWithCustomView:self.toolbarPlaybackButton];
    self.toolbarController.popupItem.leftBarButtonItems = @[itemLeft];
    self.toolbarController.popupItem.rightBarButtonItems = @[itemRight];
    [[LNPopupBar appearanceWhenContainedInInstancesOfClasses:@[[UINavigationController class]]] setBarStyle:UIBarStyleBlackTranslucent];
    [[LNPopupBar appearanceWhenContainedInInstancesOfClasses:@[[UINavigationController class]]] setTintColor:[UIColor whiteColor]];
    [self.toolbarPresentingController presentPopupBarWithContentViewController:self.toolbarController openPopup:open animated:YES completion:nil];
    [self updateToolbarInfoWithMediaItem:nowPlaying];
    self.toolbarModeEnabled = YES;
}

- (void)updateToolbarInfoWithMediaItem:(SHMIDMediaItem *)mediaItem {
    [self shouldReConfigBar];
    NSString *playbackImageNamed = mediaItem.playback == SHMIDMediaItemPlaying ? @"icon_media_pause_fill" : @"icon_media_play_fill";
    UIImage *playbackButtonImage = [[SHMIDUtilities imageNamed:playbackImageNamed] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.toolbarPlaybackButton setImage:playbackButtonImage forState:UIControlStateNormal];
    self.toolbarController.popupItem.title =
    [NSString stringWithFormat:@"Casting to %@", [SHMIDCastController sharedInstance].connectedDevice.friendlyName];
    self.toolbarController.popupItem.subtitle =
    [NSString stringWithFormat:@"%@ • %@", mediaItem.title, mediaItem.show.uppercaseString];
}

- (void)shouldReConfigBar {
    if (self.toolbarPresentingController != nil) {
        return;
    }
    UIViewController *controller = [SHMIDCastController sharedInstance].viewController;
    [self switchToToolbarFromController:controller openOnPresentation:NO];
}

- (void)toolbarPlaybackButtonTapped:(id)sender {
    SHMIDMediaItem *nowPlaying = [[SHMIDScreen sharedScreen] nowPlaying];
    if (nowPlaying.playback == SHMIDMediaItemPlaying) {
        [[SHMIDScreen sharedScreen] pause];
    } else {
        [[SHMIDScreen sharedScreen] play];
    }
}

- (void)toolbarSeekBackButtonTapped:(id)sender {
    [[SHMIDScreen sharedScreen] seekBySeconds:@(-15)];
}

#pragma mark - Notifications

- (void)castingBeganNotification:(NSNotification *)notification {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self shouldShowCurrentCastView];
    if ([self.delegate respondsToSelector:@selector(castControlsViewNeedsLayout)]) {
        [self.delegate castControlsViewNeedsLayout];
    }
}

- (void)castingEndedNotification:(NSNotification *)notification {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if ([self.delegate respondsToSelector:@selector(castControlsViewNeedsLayout)]) {
        [self.delegate castControlsViewNeedsLayout];
    }
    [self shouldHideCurrentCastView];
    [self adjustCastButtonAppearance];
    self.title = @"Cast to TV";
}

- (void)processMIDInitDoneNotification:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self shouldShowActivityProgress];
        [self showRightNavigationItem];
        if (_waitingCastingViewDisplay) {
            SHMIDMediaItem *context = [[SHMIDCastController sharedInstance] contextItem];
            [self shouldAddCastingViewWithMediaItem:context];
        }
    });
}

- (void)playbackChangedNotification:(NSNotification *)notification {
    [self updateToolbarInfoWithMediaItem:[[SHMIDScreen sharedScreen] nowPlaying]];
}

#pragma mark - Actions

- (IBAction)castButtonTapped:(id)sender {
    [self transitionToCast];
}

- (IBAction)saveButtonTapped:(id)sender {
    [self transitionToSave];
}

#pragma mark - Navigation Bar

- (void)setupHomeNavigation {
    self.title = @"";
    [self showLeftNavigationItem];
    if (!self.indicatorView.isAnimating) {
        [self showRightNavigationItem];
    }
}

- (void)showLeftNavigationItem {
    UIBarButtonItem *itemLeft = [[UIBarButtonItem alloc] initWithImage:chevronDownImage
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItems = @[itemLeft];
}

- (void)showRightNavigationItem {
    UIBarButtonItem *itemRight = [[UIBarButtonItem alloc] initWithImage:settingsButtonImage
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self action:@selector(gotoSettings)];
    self.navigationItem.rightBarButtonItems = @[itemRight];
}

- (void)applyBlurEffect {
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
    blurView.frame = self.view.bounds;
    blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view insertSubview:blurView atIndex:0];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Navigation

- (void)gotoSettings {
    UIStoryboard *storyboard = [SHMIDClient sharedClient].storyboard;
    SHMIDSettingsViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SHMIDSettingsViewController"];
    controller.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:YES completion:nil];
    self.settingsViewInPresentation = YES;
}

- (void)dismiss {
    if (self.toolbarModeEnabled) {
        [self minimizeToolbar];
        return;
    }
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SHMIDSettingsViewControllerDelegate

- (void)didDismissController:(UIViewController *)controller {
    self.settingsViewWasDismissed = YES;
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self shouldLayoutViewOnScroll:scrollView];
}

- (void)shouldLayoutViewOnScroll:(UIScrollView *)scrollView {
    
    [self shouldHideCurrentCastView];
    
    if (scrollView.contentOffset.y > offsetHome) {//Cast
        
        CGFloat totalDistance = offsetCast - offsetHome;
        CGFloat distanceMoved = scrollView.contentOffset.y - offsetHome;
        CGFloat displacement = distanceMoved/totalDistance;
        CGFloat progress = displacement*100.0;
        CGFloat scaleFactor = displacement/4.0;
        CGFloat scale = MIN(1.0+scaleFactor, 1.28);
        CGFloat imageAlpha = MAX(1.0 - displacement, 0.40);
        self.contentOwnerMarkLabel.alpha = 0.0;
        self.contentTitleLabel.alpha = 1.0;
        self.saveButton.alpha = 0.0;
        [self.castButton setImage:castButtonImageFill forState:UIControlStateNormal];
        self.castButton.titleLabel.alpha = displacement * 2.0;
        self.castButton.alpha = displacement * 2.0;
        self.mediaThumbnailView.alpha = imageAlpha;
        self.mediaThumbnailView.transform = CGAffineTransformMakeScale(scale, scale);
        if(progress > 60) {
            [self showContentOwnerNameLabel];
            SHMIDMediaItem *context = [[SHMIDCastController sharedInstance] contextItem];
            [self shouldAddCastingViewWithMediaItem:context];
        } else {
            [self removeCastingView];
        }
    
    } else if (scrollView.contentOffset.y < offsetHome) {//Save
        
        CGFloat totalDistance = offsetHome - offsetSave;
        CGFloat distanceMoved = offsetHome - scrollView.contentOffset.y;
        CGFloat displacement = distanceMoved/totalDistance;
        CGFloat progress = MIN(displacement*100, 100);
        CGFloat mediaThumbAlpha = 1.0 - displacement;
        CGFloat playlistViewAlpha = displacement;
        self.contentOwnerMarkLabel.alpha = 0.0;
        self.contentTitleLabel.alpha = 0.0;
        self.castButton.alpha = 0.0;
        [self.saveButton setImage:saveButtonImageFill forState:UIControlStateNormal];
        self.saveButton.titleLabel.alpha = displacement * 2.0;
        self.saveButton.alpha = displacement * 2.0;
        self.mediaThumbnailView.alpha = mediaThumbAlpha;
        self.playlistView.alpha = playlistViewAlpha;
        if (progress > 30) {
            [self shouldAddPlaylistViewInView];
        } else {
            [self removePlaylistViewInView];
        }
        [self collapseContentOwnerNameLabel];
        
    } else {//Default
        SHMIDMediaItem *context = [[SHMIDCastController sharedInstance] contextItem];
        self.contentOwnerMarkLabel.alpha = 0.7;
        self.contentTitleLabel.alpha = 0.7;
        [self collapseContentOwnerNameLabel];
        [self updateUIInfoToMediaItem:context];
        [self shouldShowCurrentCastView];
        [self adjustSaveButtonAppearance];
        [self adjustCastButtonAppearance];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    *targetContentOffset = [self scrollOffsetForProposedOffset:*targetContentOffset];
}

- (CGPoint)scrollOffsetForProposedOffset:(CGPoint)offset {
    
    self.atHome = NO;
    CGPoint newOffset = CGPointZero;
    CGFloat yPOS = _scrollView.contentOffset.y;
    
    if (yPOS > (imageViewHeight - 50.0)
        && yPOS < (imageViewHeight + 50.0)) {//Home
        offset.y = offsetHome;
        self.atHome = YES;
        [self setupHomeNavigation];
        
    } else if (yPOS < imageViewHeight - 50.0) {//Add to Playlist
        offset.y = offsetSave;

    } else if (yPOS > imageViewHeight + 50.f) {//Cast to TV
        offset.y = offsetCast;
        if ([self castInProgress]) {
            SHMIDMediaItem *context = [[SHMIDCastController sharedInstance] contextItem];
            [[SHMIDScreen sharedScreen] setNowPlaying:context];
            [[SHMIDScreen sharedScreen] play];
        }
    }
    return offset;
}

#pragma mark - Transitions

- (void)shouldReturnToHome {
    [self setupHomeNavigation];
    [self removeCastingView];
    [self removePlaylistViewInView];
}

- (void)showContentOwnerNameLabel {
    
    if (!_showingContentOwnerNameLabel) {
        [UIView animateWithDuration:0.3
                              delay:0.1
                            options:UIViewAnimationOptionShowHideTransitionViews
                         animations:^{
                             _showingContentOwnerNameLabel = YES;
                             [self.containerView addSubview:_contentOwnerNameLabel];
                             self.contentTitleLabelTopAnchor.active = NO;
                             NSLayoutConstraint *ownerNameLabelTopAnchor     = [_contentOwnerNameLabel.topAnchor constraintEqualToAnchor:_mediaThumbnailView.bottomAnchor constant:20.0];
                             NSLayoutConstraint *ownerNameLabelCenterXAnchor = [_contentOwnerNameLabel.centerXAnchor constraintEqualToAnchor:_contentTitleLabel.centerXAnchor];
                             NSLayoutConstraint *ownerNameLabelWidthAnchor   = [_contentOwnerNameLabel.widthAnchor constraintEqualToAnchor:_scrollView.widthAnchor multiplier:0.90];
                             NSLayoutConstraint *contentTitleLabelTopAnchor  = [_contentTitleLabel.topAnchor constraintEqualToAnchor:_contentOwnerNameLabel.bottomAnchor constant:5.0];
                             _contentOwnerNameLabelConstraints = @[ownerNameLabelTopAnchor, ownerNameLabelCenterXAnchor, ownerNameLabelWidthAnchor, contentTitleLabelTopAnchor];
                             [NSLayoutConstraint activateConstraints:_contentOwnerNameLabelConstraints];
                         }
                         completion:nil];
    }
}

- (void)collapseContentOwnerNameLabel {
    
    if (_showingContentOwnerNameLabel) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.contentOwnerNameLabel removeFromSuperview];
            [NSLayoutConstraint deactivateConstraints:_contentOwnerNameLabelConstraints];
            self.contentTitleLabelTopAnchor.active = YES;
            _showingContentOwnerNameLabel = NO;
        }];
    }
}

- (void)transitionToHomeFromCast {
    [self transitionToHomeFromView:@"CAST"];
}

- (void)transitionToHomeFromSave {
    [self transitionToHomeFromView:@"SAVE"];
}

- (void)transitionToHomeFromView:(NSString *)view {
    SHMIDMediaItem *context = [[SHMIDCastController sharedInstance] contextItem];
    [self shouldReturnToHome];
    if ([view isEqualToString:@"CAST"]) {
        [self updateUIInfoToMediaItem:context];
        [self adjustCastButtonAppearance];
        [UIView animateWithDuration:0.2
                              delay:0.6
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self adjustSaveButtonAppearance];
                         } completion:nil];
    } else {
        [self adjustSaveButtonAppearance];
        [UIView animateWithDuration:0.2
                              delay:0.6
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self adjustCastButtonAppearance];
                         } completion:nil];
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.atHome = YES;
        self.contentOwnerMarkLabel.hidden = NO;
        self.contentOwnerMarkLabel.alpha = 0.7;
        self.contentTitleLabel.hidden = NO;
        self.contentTitleLabel.alpha = 0.7;
        self.mediaThumbnailView.alpha = 1.0;
        self.mediaThumbnailView.transform = imageScaleDefault;
        [self.scrollView setContentOffset:CGPointMake(0, offsetHome)];
    }];
}

- (void)transitionToHomeNoAnimation {
    SHMIDMediaItem *context = [[SHMIDCastController sharedInstance] contextItem];
    [self shouldReturnToHome];
    [self updateUIInfoToMediaItem:context];
    [self adjustCastButtonAppearance];
    [self adjustSaveButtonAppearance];
    self.atHome = YES;
    self.contentOwnerMarkLabel.hidden = NO;
    self.contentOwnerMarkLabel.alpha = 0.7;
    self.contentTitleLabel.hidden = NO;
    self.contentTitleLabel.alpha = 0.7;
    self.mediaThumbnailView.alpha = 1.0;
    self.mediaThumbnailView.transform = imageScaleDefault;
    [self.scrollView setContentOffset:CGPointMake(0, offsetHome)];
}

- (void)transitionToCast {
    [self transitionToCastAnimated:YES completion:^{
        self.mediaThumbnailView.alpha = 0.7;
        self.mediaThumbnailView.transform = imageScaleFocussed;
        [self.scrollView setContentOffset:CGPointMake(0, offsetCast)];
    }];
}

- (void)transitionToCastNoAnimation {
    [self transitionToCastAnimated:NO completion:^{
        self.mediaThumbnailView.alpha = 0.7;
        self.mediaThumbnailView.transform = imageScaleFocussed;
        [self.scrollView setContentOffset:CGPointMake(0, offsetCast)];
    }];
}

- (void)transitionToCastAnimated:(BOOL)animated completion:(void(^)())completion {
    self.saveButton.hidden = YES;
    SHMIDMediaItem *mediaItem =
    [self castInProgress] ? [[SHMIDScreen sharedScreen] nowPlaying]
                          : [[SHMIDCastController sharedInstance] contextItem];
    [self updateUIInfoToMediaItem:mediaItem];
    [self shouldAddCastingViewWithMediaItem:mediaItem];
    if (animated) {
        [UIView animateWithDuration:0.5 animations:completion];
    } else {
        completion();
    }
}

- (void)transitionToSave {
    self.castButton.hidden = YES;
    [self shouldAddPlaylistViewInView];
    [UIView animateWithDuration:0.5 animations:^{
        self.mediaThumbnailView.alpha = 0.0;
        self.mediaThumbnailView.transform = imageScaleDefault;
        [self.scrollView setContentOffset:CGPointMake(0.0, offsetSave)];
    }];
}

- (void)updateUIInfoToMediaItem:(SHMIDMediaItem *)item {
    NSString *showNameString    = item.show.uppercaseString;
    UIImage *placeholderImage   = [SHMIDUtilities imageNamed:@"media_video_placeholder"];
    self.contentTitleLabel.text = item.title;
    self.contentOwnerNameLabel.text = showNameString;
    self.contentOwnerMarkLabel.text = showNameString;
    NSURL *posterImageURL = [NSURL URLWithString:item.posterURL];
    [self.mediaThumbnailView sd_setImageWithURL:posterImageURL placeholderImage:placeholderImage];
}

- (void)showWithNowPlayingContext {
    if (![self castInProgress]) {
        return;
    }
    [self transitionToCastNoAnimation];
}

#pragma mark - Button states

- (void)castButtonShowCastingFill {
    if ([SHMIDScreen sharedScreen].state == SHMIDScreenStateSynced) {
        [self.castButton setImage:castButtonImageFill forState:UIControlStateNormal];
    }
}

- (void)adjustCastButtonAppearance {
    if (self.castButton.hidden) {
        self.castButton.hidden = NO;
    }
    self.castButton.alpha = 1.0;
    self.castButton.titleLabel.alpha = 0.0;
    UIImage *image = [self castInProgress] ? castButtonImageFill : castButtonImage;
    [self.castButton setImage:image forState:UIControlStateNormal];
}

- (void)adjustSaveButtonAppearance {
    if (self.saveButton.hidden) {
        self.saveButton.hidden = NO;
    }
    self.saveButton.alpha = 1.0;
    self.saveButton.titleLabel.alpha = 0.0;
    [self.saveButton setImage:saveButtonImage forState:UIControlStateNormal];
}

#pragma mark - CastingView

- (void)shouldAddCastingViewWithMediaItem:(SHMIDMediaItem *)item {
    if (self.indicatorView.isAnimating) {
        _waitingCastingViewDisplay = YES;
        return;
    }
    if (!_containsCastView) {
        _containsCastView = YES;
        self.castingView = [[SHMIDCastingView alloc] initWithFrame:self.view.bounds mediaItem:item];
        _castingView.translatesAutoresizingMaskIntoConstraints = NO;
        self.delegate = _castingView;
        [self.containerView addSubview:_castingView];
        NSLayoutConstraint *castingViewLeadingAnchor = [_castingView.leadingAnchor constraintEqualToAnchor:_containerView.leadingAnchor];
        NSLayoutConstraint *castingViewTrailingAnchor= [_castingView.trailingAnchor constraintEqualToAnchor:_containerView.trailingAnchor];
        NSLayoutConstraint *castingViewTopAnchor     = [_castingView.topAnchor constraintEqualToAnchor:_mediaThumbnailView.topAnchor];
        NSLayoutConstraint *castingViewBottomAnchor  = [_castingView.bottomAnchor constraintEqualToAnchor:_mediaThumbnailView.bottomAnchor];
        [NSLayoutConstraint activateConstraints:@[castingViewLeadingAnchor, castingViewTrailingAnchor, castingViewTopAnchor, castingViewBottomAnchor]];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:chevronLeftImage
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self action:@selector(transitionToHomeFromCast)];
        self.navigationItem.leftBarButtonItems = @[item];
        SDConnectableDevice *connectTargetDevice = [[SHMIDCastController sharedInstance] connectedDevice];
        self.title = [self castInProgress] ? connectTargetDevice.friendlyName : @"Cast to TV";
        [[NSNotificationCenter defaultCenter] addObserver:_castingView selector:@selector(handleTargetCastDevicesChangeNotification:)
                                                     name:kSHMIDHandleTargetCastDevicesChangeNotification object:nil];
    }
}

- (void)removeCastingView {
    if (_containsCastView) {
        [self.castingView removeFromSuperview];
        self.castingView = nil;
        self.containsCastView = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:_castingView];
    }
    _waitingCastingViewDisplay = NO;
}

#pragma mark - PlaylistView

- (void)shouldAddPlaylistViewInView {
    if (!_containsPlaylistView) {
        _containsPlaylistView = YES;
        self.playlistView = [[SHMIDPlaylistView alloc] initWithFrame:self.containerView.bounds];
        [self.containerView addSubview:_playlistView];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:chevronLeftImage
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self action:@selector(transitionToHomeFromSave)];
        self.navigationItem.leftBarButtonItems = @[item];
        self.title = @"Save to Playlist";
    }
}

- (void)removePlaylistViewInView {
    if (_containsPlaylistView) {
        [self.playlistView removeFromSuperview];
        _playlistView = nil;
        _containsPlaylistView = NO;
    }
}

#pragma mark - CurrentCastView

- (void)shouldShowCurrentCastView {
    if ([self castInProgress]) {
        self.currentCastInfoViewDetailLabel.text = [SHMIDScreen sharedScreen].nowPlaying.title;
        if (_currentCastInfoView.hidden) {
            _currentCastInfoView.hidden = NO;
        }
    }
}

- (void)shouldHideCurrentCastView {
    if (!_currentCastInfoView.hidden) {
        _currentCastInfoView.hidden = YES;
    }
}

#pragma mark - Cast Controls

- (void)shouldShowCastControlsView {
    if ([self castInProgress]) {
        if (_castControlsView.hidden) {
            _castControlsView.hidden = NO;
        }
    }
}

- (void)shouldHideCastControlsView {
    if (!_castControlsView.hidden) {
        _castControlsView.hidden = YES;
    }
}

#pragma mark - ActivityIndicator

- (void)shouldShowActivityProgress {
    [self.indicatorView startAnimating];
    if ([SHMIDClient sharedClient].initDone) {
        [self.indicatorView stopAnimating];
        return;
    }
    [self scheduleReInitAfterDelay:20];
}

#pragma mark - MID Client reInit

- (void)scheduleReInitAfterDelay:(NSTimeInterval)delay {
    [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(reInitMIDClient) userInfo:nil repeats:NO];
}

- (void)reInitMIDClient {
    if ([[SHMIDClient sharedClient] initDone]) {
        return;
    }
    [[SHMIDClient sharedClient] reInitWithCompletion:^(BOOL done, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [self showAlertWithRetryOptionAndMessage:[error getFailureMessageInResponseData]];
            }
        });
    }];
}

- (void)showAlertWithRetryOptionAndMessage:(NSString *)message {
    __weak typeof(self) wself = self;
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:@"Could not connect to server" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *retry =
    [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
           [wself scheduleReInitAfterDelay:10];
        });
    }];
    UIAlertAction *close =
    [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.indicatorView stopAnimating];
            [wself dismiss];
        });
    }];
    [alertController addAction:retry];
    [alertController addAction:close];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Convenience

- (BOOL)castInProgress {
    return [SHMIDScreen sharedScreen].state == SHMIDScreenStateSynced;
}

@end
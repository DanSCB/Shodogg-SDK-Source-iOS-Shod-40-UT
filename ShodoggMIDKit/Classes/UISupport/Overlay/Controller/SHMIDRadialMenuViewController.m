//
//  SHMIDRadialMenuViewController.m
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 8/25/16.
//
//

#import "SHMIDRadialMenuViewController.h"
#import "SHMIDUtilities.h"
#import <QuartzCore/QuartzCore.h>

CGFloat numOfMenus = 2;
CGFloat menuRadius = 130.0;
CGFloat subMenuRadius = 30.0;

@interface SHMIDRadialMenuViewController () <SHMIDRadiaMenuDelegate>
@property (nonatomic, strong) SHMIDRadialMenu *radialMenu;
@property (nonatomic, strong) NSMutableArray *subMenus;
@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, strong) UILabel *radialMenuLabel;
@property (nonatomic) CGPoint adjustedOpeningPosition;
@end

@implementation SHMIDRadialMenuViewController {
    NSArray *menuTitles;
    NSArray *menuImageNames;
    NSArray *menuHighlightedImageNames;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    CGPoint position = self.openingPosition;
    position.y += 64.0;
    self.adjustedOpeningPosition = position;
    
    menuTitles = @[@"SAVE", @"CAST"];
    //[[SHMIDUtilities imageNamed:@"icon_save"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
    menuImageNames = @[@"icon_save", @"icon_home_cast"];
    menuHighlightedImageNames = @[@"icon_save_fill", @"icon_home_cast_fill"];
    [self applyBlurEffect];
    [self configureRadialMenuControl];
    
    UIButton *button = [UIButton buttonWithType:UIBarButtonSystemItemStop];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    NSLayoutConstraint *heightAnchor = [button.heightAnchor constraintEqualToConstant:50.0];
    NSLayoutConstraint *widthAnchor = [button.widthAnchor constraintEqualToConstant:50.0];
    NSLayoutConstraint *buttonTrailingAnchor = [button.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor];
    NSLayoutConstraint *buttonTopAnchor = [button.topAnchor constraintEqualToAnchor:self.view.topAnchor];
    [NSLayoutConstraint activateConstraints:@[heightAnchor, widthAnchor, buttonTrailingAnchor, buttonTopAnchor]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.radialMenu openAtPosition:_adjustedOpeningPosition];
}

#pragma mark - Visual

- (void)applyBlurEffect {
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
    self.blurView.frame = self.view.bounds;
    self.blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:_blurView atIndex:0];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Navigation

- (void)close {
    [self.radialMenu close];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)moveAtPosition:(CGPoint)position {
    [self.radialMenu moveAtPosition:position];
}

#pragma mark - Radial Interface

- (void)configureRadialMenuControl {
    self.subMenus = [NSMutableArray new];
    for (int i = 0; i < numOfMenus; i++) {
        [_subMenus addObject:[self createRadialSubMenuWithTag:i]];
    }
    self.radialMenu = [[SHMIDRadialMenu alloc] initWithMenus:_subMenus radius:menuRadius];
    self.radialMenu.center = self.blurView.contentView.center;
    self.radialMenu.openDelayStep = 0.05;
    self.radialMenu.closeDelayStep = 0.00;
    self.radialMenu.minAngle = 90;
    self.radialMenu.maxAngle = 270;
    self.radialMenu.activatedDelay          = 1.0;
    self.radialMenu.backgroundView.alpha = 0.0;
    self.radialMenu.delegate             = self;
    [self.blurView.contentView addSubview:self.radialMenu];
    self.radialMenuLabel               = [[UILabel alloc] init];
    self.radialMenuLabel.frame         = CGRectMake(0, 0, 150, 21);
    self.radialMenuLabel.center        = self.adjustedOpeningPosition;
    self.radialMenuLabel.textAlignment = NSTextAlignmentCenter;
    self.radialMenuLabel.font          = [UIFont fontWithName:@"AvenirNext-Regular" size:12.0];
    self.radialMenuLabel.textColor     = [UIColor whiteColor];
    self.radialMenuLabel.text          = @"";
    [self.blurView.contentView addSubview:self.radialMenuLabel];
}

#pragma mark - SHMIDRadialMenuDelegate

- (void)radialMenuDidClose {
    for (SHMIDRadialSubMenu *subMenu in self.subMenus) {
        [self resetSubMenu:subMenu];
    }
}

- (void)radialMenuDidHighlight:(SHMIDRadialSubMenu *)subMenu {
    NSLog(@"%s - ButtonAtIndex: %lu", __PRETTY_FUNCTION__, subMenu.tag);
    [self highlightSubMenu:subMenu];
    self.radialMenuLabel.text = [self nameForSubMenu:subMenu];
    if ([self.delegate respondsToSelector:@selector(radialMenu:didSelectSubMenuAtIndex:)]) {
        [self.delegate radialMenu:self.radialMenu didSelectSubMenuAtIndex:subMenu.tag];
    }
}

- (void)radialMenuDidUnHighlight:(SHMIDRadialSubMenu *)subMenu {
    NSLog(@"%s - ButtonAtIndex: %lu", __PRETTY_FUNCTION__, subMenu.tag);
    [self resetSubMenu:subMenu];
}

#pragma mark - Radial SubMenu Convenience

- (SHMIDRadialSubMenu *)createRadialSubMenuWithTag:(NSInteger)tag {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, subMenuRadius*2, subMenuRadius*2)];
    SHMIDRadialSubMenu *subMenu = [[SHMIDRadialSubMenu alloc] initWithImageView:imageView];
    subMenu.tintColor = [UIColor whiteColor];
    subMenu.userInteractionEnabled = YES;
    subMenu.layer.cornerRadius = subMenuRadius;
    subMenu.tag = tag;
    imageView.image = [self imageForSubMenu:subMenu highlighed:NO];
    [self resetSubMenu:subMenu];
    return subMenu;
}

- (NSString *)nameForSubMenu:(SHMIDRadialSubMenu *)subMenu {
    int pos = subMenu.tag % menuTitles.count;
    return menuTitles[pos];
}

- (UIColor *)imageForSubMenu:(SHMIDRadialSubMenu *)subMenu highlighed:(BOOL)highlighted {
    int pos = subMenu.tag % menuImageNames.count;
    NSString *imageName = highlighted ? menuHighlightedImageNames[pos] : menuImageNames[pos];
//    return [[SHMIDUtilities imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    return [SHMIDUtilities imageNamed:imageName];
}

- (void)highlightSubMenu:(SHMIDRadialSubMenu *)subMenu {
    subMenu.imageView.image = [self imageForSubMenu:subMenu highlighed:YES];
}

- (void)resetSubMenu:(SHMIDRadialSubMenu *)subMenu {
    subMenu.imageView.image = [self imageForSubMenu:subMenu highlighed:NO];
}

@end
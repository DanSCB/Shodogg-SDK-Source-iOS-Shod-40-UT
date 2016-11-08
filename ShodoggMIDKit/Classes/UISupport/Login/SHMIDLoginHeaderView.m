//
//  SHMIDLoginHeaderView.m
//  
//
//  Created by Aamir Khan on 12/11/15.
//  Copyright (c) 2015 Shodogg. All rights reserved.
//

#import "SHMIDLoginHeaderView.h"

static NSString *kSocialTitleText = @"CAST  •  SHARE  •  SAVE";
static NSString *kEmailTitleText = @"";
static NSString *kSigninTitleText = @"";
static NSString *kSignupTitleText = @"";
static NSString *kSocialSubtitleText = @"Your entertainment from all of your favorite TV apps";
static NSString *kEmailSubtitleText = @"Enter your email address to sign in or create an account";
static NSString *kSigninSubtitleText = @"Enter your password to get started!";
static NSString *kSignupSubtitleText = @"Welcome! Let's get you setup with your new account";

@interface SHMIDLoginHeaderView()
@property (assign) HeaderType type;
@property (nonatomic, weak) UIViewController *topViewController;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@end

@implementation SHMIDLoginHeaderView

+ (SHMIDLoginHeaderView *)headerType:(HeaderType)type
                    parentController:(UIViewController *)topViewController {;
    return [[self alloc] initWithFrame:CGRectZero
                            headerType:type
                  parentViewController:(UIViewController *)topViewController];
}

- (instancetype)initWithFrame:(CGRect)frame
                   headerType:(HeaderType)type
         parentViewController:(UIViewController *)topViewController {
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        _topViewController = topViewController;
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:16.0];
        UILabel *subtitleLabel = [[UILabel alloc] init];
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        subtitleLabel.textAlignment = NSTextAlignmentCenter;
        subtitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        subtitleLabel.textColor = [UIColor whiteColor];
        subtitleLabel.numberOfLines = 3;
        subtitleLabel.font = [UIFont fontWithName:@"Avenir" size:15.0];
        self.titleLabel = titleLabel;
        self.subtitleLabel = subtitleLabel;
        [self configureHeader:type];
    }
    return self;
}

- (void)configureHeader:(HeaderType)type {
    
    NSDictionary *views = @{@"Title" : _titleLabel, @"Subtitle": _subtitleLabel};
    if (![self.subviews containsObject:_subtitleLabel]) {
        [self addSubview:_subtitleLabel];
    }
    NSString *vposContraint;
    if (type == HeaderSocial) {
        if (![self.subviews containsObject:_titleLabel]) {
            [self addSubview:_titleLabel];
        }
        vposContraint = @"V:|-5-[Title(21)][Subtitle]-|";
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[Title]-|"
                                                 options:0 metrics:0 views:views]];
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:_titleLabel
                                      attribute:NSLayoutAttributeCenterX
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:_subtitleLabel
                                      attribute:NSLayoutAttributeCenterX
                                     multiplier:1.f constant:0]];
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:_subtitleLabel
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:_titleLabel
                                      attribute:NSLayoutAttributeHeight
                                     multiplier:3.f constant:0]];
        _titleLabel.text = [[self class] titleForType:type];
    } else {
        vposContraint = @"V:|-[Subtitle(>=21,<=63)]-|";
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:_subtitleLabel
                                      attribute:NSLayoutAttributeCenterX
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeCenterX
                                     multiplier:1.f constant:0]];
    }
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:vposContraint
                                             options:0 metrics:0 views:views]];
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:_subtitleLabel
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeWidth
                                 multiplier:.6f
                                   constant:0]];
    _subtitleLabel.text = [[self class] subTextForType:type];
}

- (void)resetConstraints {
    [self removeConstraints:self.titleLabel.constraints];
    [self removeConstraints:self.subtitleLabel.constraints];
}

- (void)reLayoutHeader:(HeaderType)type {
    [self resetConstraints];
    [self configureHeader:type];
}

+ (NSString *)titleForType:(HeaderType)type {
    NSString *title;
    switch (type) {
        case HeaderSocial:
            title = kSocialTitleText;
            break;
        case HeaderEmail:
            title = kEmailTitleText;
            break;
        case HeaderSignIn:
            title = kSigninTitleText;
            break;
        case HeaderSignUp:
            title = kSignupTitleText;
            break;
        default:
            break;
    }
    return title;
}

+ (NSString *)subTextForType:(HeaderType)type {
    NSString *subtitle;
    switch (type) {
        case HeaderSocial:
            subtitle = kSocialSubtitleText;
            break;
        case HeaderEmail:
            subtitle = kEmailSubtitleText;
            break;
        case HeaderSignIn:
            subtitle = kSigninSubtitleText;
            break;
        case HeaderSignUp:
            subtitle = kSignupSubtitleText;
            break;
        default:
            break;
    }
    return subtitle;
}

@end
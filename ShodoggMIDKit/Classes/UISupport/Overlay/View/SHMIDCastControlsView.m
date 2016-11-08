//
//  SHMIDCastControlsView.m
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 6/1/16.
//
//

#import "SHMIDCastControlsView.h"
#import "SHMIDCastController.h"
#import "SHMIDUtilities.h"
#import "SHMIDRoundedButton.h"
#import "SHMIDScreen.h"
#import "SHMIDVisualEffectView.h"
#import <QuartzCore/QuartzCore.h>

@interface SHMIDCastControlsView ()
@property (nonatomic) UIButton *playbackButton;
@property (nonatomic, strong) SHMIDMediaItem *mediaItem;
@end

@implementation SHMIDCastControlsView {
    UIImage *playButtonImage;
    UIImage *pauseButtonImage;
    UIImage *rewindButtonImage;
    UIImage *forwardButtonImage;
    CGFloat seekButtonSide;
    CGRect  seekButtonRect;
    CGFloat playbackButtonSide;
    CGRect  playbackButtonRect;
    CGFloat endCastButtonWidth;
    CGFloat endCastButtonHeight;
}

- (instancetype)initWithFrame:(CGRect)frame mediaItem:(SHMIDMediaItem *)item {
    if (self = [super initWithFrame:frame]) {
        [self layoutControlsForMediaItem:item];
    }
    return self;
}

- (void)layoutControlsForMediaItem:(SHMIDMediaItem *)item {
    
    _mediaItem = item;
    seekButtonSide = 32.0;
    playbackButtonSide = 64.0;
    endCastButtonHeight = 34.0;
    endCastButtonWidth  = 100.0;
    seekButtonRect = CGRectMake(0, 0, seekButtonSide, seekButtonSide);
    playbackButtonRect = CGRectMake(0, 0, playbackButtonSide, playbackButtonSide);
    playButtonImage  = [SHMIDUtilities imageNamed:@"icon_play_circle"];
    pauseButtonImage = [SHMIDUtilities imageNamed:@"icon_pause_circle"];
    rewindButtonImage = [SHMIDUtilities imageNamed:@"icon_media_rewind"];
    forwardButtonImage= [SHMIDUtilities imageNamed:@"icon_media_forward"];
    
    self.playbackButton = [[UIButton alloc] init];
    _playbackButton.translatesAutoresizingMaskIntoConstraints = NO;
    _playbackButton.showsTouchWhenHighlighted = YES;
    [_playbackButton setBackgroundImage:playButtonImage forState:UIControlStateNormal];
    [_playbackButton addTarget:self action:@selector(playbackButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *seekBackButton = [[UIButton alloc] init];
    seekBackButton.translatesAutoresizingMaskIntoConstraints = NO;
    seekBackButton.showsTouchWhenHighlighted = YES;
    [seekBackButton setImage:rewindButtonImage forState:UIControlStateNormal];
    [seekBackButton addTarget:self action:@selector(seekBackButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *seekForwardButton = [[UIButton alloc] init];
    seekForwardButton.translatesAutoresizingMaskIntoConstraints = NO;
    seekForwardButton.showsTouchWhenHighlighted = YES;
    [seekForwardButton setImage:forwardButtonImage forState:UIControlStateNormal];
    [seekForwardButton addTarget:self action:@selector(seekForwardButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *endCastButton = [[UIButton alloc] init];
    endCastButton.translatesAutoresizingMaskIntoConstraints = NO;
    endCastButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    endCastButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14.0];
    [endCastButton setTitle:@"End Cast" forState:UIControlStateNormal];
    [endCastButton addTarget:self action:@selector(endCastButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView = [[SHMIDVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = CGRectMake(0, 0, endCastButtonWidth, endCastButtonHeight);
    [[visualEffectView layer] setMasksToBounds:YES];
    [[visualEffectView layer] setCornerRadius:6.0];
    [endCastButton insertSubview:visualEffectView atIndex:0];
    
    [self addSubview:seekBackButton];
    [self addSubview:_playbackButton];
    [self addSubview:seekForwardButton];
    [self addSubview:endCastButton];
    
    NSDictionary *views = @{@"SeekBackButton": seekBackButton,
                            @"SeekForwardButton": seekForwardButton,
                            @"PlaybackButton": _playbackButton,
                            @"EndCastButton": endCastButton};
    
    NSDictionary *metrics = @{@"InterButtonSpacing": @20,
                              @"EndCastButtonHeight": @(endCastButtonHeight),
                              @"EndCastButtonWidth": @(endCastButtonWidth)};
    [self addConstraints:
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:[SeekBackButton]-InterButtonSpacing-[PlaybackButton]-InterButtonSpacing-[SeekForwardButton]"
                                                options:0 metrics:metrics views:views]];
    [self addConstraints:
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:[PlaybackButton]-10-[EndCastButton]"
                                                options:0 metrics:metrics views:views]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_playbackButton attribute:NSLayoutAttributeHeight relatedBy:nil toItem:nil attribute:nil multiplier:1.0 constant:playbackButtonSide]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_playbackButton attribute:NSLayoutAttributeWidth relatedBy:nil toItem:nil attribute:nil multiplier:1.0 constant:playbackButtonSide]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:endCastButton attribute:NSLayoutAttributeHeight relatedBy:nil toItem:nil attribute:nil multiplier:1.0 constant:endCastButtonHeight]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:endCastButton attribute:NSLayoutAttributeWidth relatedBy:nil toItem:nil attribute:nil multiplier:1.0 constant:endCastButtonWidth]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:seekBackButton attribute:NSLayoutAttributeHeight relatedBy:nil toItem:nil attribute:nil multiplier:1.0 constant:seekButtonSide]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:seekBackButton attribute:NSLayoutAttributeWidth relatedBy:nil toItem:nil attribute:nil multiplier:1.0 constant:seekButtonSide]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:seekBackButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:seekForwardButton attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:seekBackButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:seekForwardButton attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:seekBackButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_playbackButton attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:seekForwardButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_playbackButton attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_playbackButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_playbackButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:endCastButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_playbackButton attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    self.delegate = [SHMIDCastController sharedInstance];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackChangedNotification:) name:kMIDScreenPlaybackChangedNotification object:nil];
    [self playbackChangedNotification:nil];
}

- (void)playbackChangedNotification:(NSNotification *)notification {
    switch (self.mediaItem.playback) {
        case SHMIDMediaItemPlaybackUnknown:
        case SHMIDMediaItemPaused:
            [self.playbackButton setBackgroundImage:playButtonImage forState:UIControlStateNormal];
            break;
        case SHMIDMediaItemPlaying:
        case SHMIDMediaItemBuffering:
            [self.playbackButton setBackgroundImage:pauseButtonImage forState:UIControlStateNormal];
            break;
    }
}

#pragma mark - Button Actions

- (void)seekBackButtonTapped:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [[SHMIDScreen sharedScreen] seekBySeconds:@(-15)];
}

- (void)seekForwardButtonTapped:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [[SHMIDScreen sharedScreen] seekBySeconds:@(15)];
}

- (void)playbackButtonTapped:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (self.mediaItem.playback == SHMIDMediaItemPlaying) {
        [[SHMIDScreen sharedScreen] pause];
    } else {
        [[SHMIDScreen sharedScreen] play];
    }
}

- (void)endCastButtonTapped:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if ([self.delegate respondsToSelector:@selector(endCasting)]) {
        [self.delegate endCasting];
    }
}

@end
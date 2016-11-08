//
//  SHMIDPlaylistItemView.m
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 7/18/16.
//
//

#import "SHMIDPlaylistItemView.h"
#import <QuartzCore/QuartzCore.h>

@interface SHMIDPlaylistItemView ()

@end

@implementation SHMIDPlaylistItemView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        UIFont *headerFont = [UIFont fontWithName:@"AvenirNext-UltraLight" size:32.0];
        UIFont *detailFont = [UIFont fontWithName:@"AvenirNext-Regular" size:14.0];
        UIFont *buttonFont = [UIFont fontWithName:@"AvenirNext-UltraLight" size:40.0];
        UIColor*textColor  = [UIColor whiteColor];
        
        CGFloat height = CGRectGetHeight([[UIScreen mainScreen] bounds]);
        CGFloat artViewPreferedHeight = height*0.30;
        
        _headerLabel = [[UILabel alloc] init];
        _headerLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _headerLabel.font = headerFont;
        _headerLabel.textColor = textColor;
        _headerLabel.textAlignment = NSTextAlignmentCenter;
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _detailLabel.numberOfLines = 2;
        _detailLabel.font = detailFont;
        _detailLabel.textColor = textColor;
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        
        _artworkView = [[UIImageView alloc] init];
        _artworkView.translatesAutoresizingMaskIntoConstraints = NO;
        _artworkView.contentMode = UIViewContentModeScaleAspectFit;
        
        CGRect buttonRect = CGRectMake(0.0, 0.0, 64.0, 64.0);
        _addToPlaylistButton = [[SHMIDRoundedButton alloc] initWithFrame:buttonRect appearance:SHMIDButtonAppearanceWhite];
        _addToPlaylistButton.translatesAutoresizingMaskIntoConstraints = NO;
        _addToPlaylistButton.titleLabel.font = buttonFont;
        [_addToPlaylistButton setTitle:@"+" forState:UIControlStateNormal];
        _addToPlaylistButton.hidden = YES;
        
        [self.contentView addSubview:_headerLabel];
        [self.contentView addSubview:_detailLabel];
        [self.contentView addSubview:_artworkView];
        [self.contentView addSubview:_addToPlaylistButton];
        
        NSLayoutConstraint *headerLabelHeightAnchor   = [_headerLabel.heightAnchor constraintEqualToConstant:36.0];
        NSLayoutConstraint *headerLabelLeadingAnchor  = [_headerLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
        NSLayoutConstraint *headerLabelTrailingAnchor = [_headerLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor];
        NSLayoutConstraint *headerLabelTopAnchor      = [_headerLabel.topAnchor constraintEqualToAnchor:self.topAnchor];
        NSLayoutConstraint *headerLabelBottonAnchor   = [_headerLabel.bottomAnchor constraintEqualToAnchor:_detailLabel.topAnchor];
        [NSLayoutConstraint activateConstraints:@[headerLabelHeightAnchor, headerLabelTopAnchor, headerLabelLeadingAnchor, headerLabelTrailingAnchor, headerLabelBottonAnchor]];
        
        NSLayoutConstraint *detailLabelHeightAnchor   = [_detailLabel.heightAnchor constraintEqualToConstant:40.0];
        NSLayoutConstraint *detailLabelLeadingAnchor  = [_detailLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
        NSLayoutConstraint *detailLabelTrailingAnchor = [_detailLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor];
        NSLayoutConstraint *detailLabelBottomAnchor   = [_detailLabel.bottomAnchor constraintEqualToAnchor:_artworkView.topAnchor];
        [NSLayoutConstraint activateConstraints:@[detailLabelHeightAnchor, detailLabelLeadingAnchor, detailLabelTrailingAnchor, detailLabelBottomAnchor]];
        
        NSLayoutConstraint *artViewLeadingAnchor      = [_artworkView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
        NSLayoutConstraint *artViewTrailingAnchor     = [_artworkView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor];
        NSLayoutConstraint *artViewCenterXAnchor      = [_artworkView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor];
        NSLayoutConstraint *artViewHeightAnchor       = [_artworkView.heightAnchor constraintEqualToConstant:artViewPreferedHeight];
        [NSLayoutConstraint activateConstraints:@[artViewCenterXAnchor, artViewLeadingAnchor, artViewTrailingAnchor, artViewHeightAnchor]];
        
        NSLayoutConstraint *addButtonHeightAnchor   = [_addToPlaylistButton.heightAnchor constraintEqualToConstant:64.0];
        NSLayoutConstraint *addButtonWidthAnchor    = [_addToPlaylistButton.widthAnchor constraintEqualToAnchor:_addToPlaylistButton.heightAnchor];
        NSLayoutConstraint *addButtonCenterX        = [_addToPlaylistButton.centerXAnchor constraintEqualToAnchor:_artworkView.centerXAnchor];
        NSLayoutConstraint *addButtonCenterY        = [_addToPlaylistButton.centerYAnchor constraintEqualToAnchor:_artworkView.centerYAnchor];
        [NSLayoutConstraint activateConstraints:@[addButtonCenterX, addButtonCenterY, addButtonHeightAnchor, addButtonWidthAnchor]];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
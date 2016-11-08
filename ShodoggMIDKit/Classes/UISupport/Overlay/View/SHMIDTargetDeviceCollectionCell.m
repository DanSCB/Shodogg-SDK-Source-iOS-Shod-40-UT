//
//  SHMIDTargetDeviceCollectionCell.m
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 7/20/16.
//
//

#import "SHMIDTargetDeviceCollectionCell.h"
#import "SHMIDUtilities.h"
#import <QuartzCore/QuartzCore.h>

const CGFloat targetImageViewSide = 64.0;
const CGFloat padding = 5.0;

@interface SHMIDTargetDeviceCollectionCell()

@end

@implementation SHMIDTargetDeviceCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        UIImage *targetImage = [SHMIDUtilities imageNamed:@"icon_home_cast"];
        UIFont  *nameLabelFont = [UIFont fontWithName:@"AvenirNext-Regular" size:15.0];
        UIColor *nameLabelTextColor = [UIColor whiteColor];
        
        _targetImageView = [[UIImageView alloc] init];
        _targetImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _targetImageView.layer.cornerRadius = targetImageViewSide/2.0;
        _targetImageView.image = targetImage;
        
        _targetNameLabel = [[UILabel alloc] init];
        _targetNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _targetNameLabel.numberOfLines = 2;
        _targetNameLabel.font = nameLabelFont;
        _targetNameLabel.textColor = nameLabelTextColor;
        _targetNameLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:_targetImageView];
        [self.contentView addSubview:_targetNameLabel];
        
        NSLayoutConstraint *imageViewHeightContraint   = [_targetImageView.heightAnchor constraintEqualToConstant:targetImageViewSide];
        NSLayoutConstraint *imageViewWidthContraint    = [_targetImageView.widthAnchor constraintEqualToConstant:targetImageViewSide];
        NSLayoutConstraint *imageViewCenterXConstraint = [_targetImageView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor];
        NSLayoutConstraint *imageViewTopAnchor         = [_targetImageView.topAnchor constraintEqualToAnchor:self.topAnchor constant:padding];
        [NSLayoutConstraint activateConstraints:@[imageViewHeightContraint, imageViewWidthContraint, imageViewCenterXConstraint, imageViewTopAnchor]];
        
        NSLayoutConstraint *labelTopAnchor      = [_targetNameLabel.topAnchor constraintEqualToAnchor:_targetImageView.bottomAnchor constant:padding];
        NSLayoutConstraint *labelLeadingAnchor  = [_targetNameLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:padding];
        NSLayoutConstraint *labelTrailingAnchor = [_targetNameLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-padding];
        [NSLayoutConstraint activateConstraints:@[labelTopAnchor, labelLeadingAnchor, labelTrailingAnchor]];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end

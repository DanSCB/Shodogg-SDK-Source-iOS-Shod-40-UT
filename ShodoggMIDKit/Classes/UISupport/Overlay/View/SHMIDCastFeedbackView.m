//
//  SHMIDCastFeedbackView.m
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 7/11/16.
//
//

#import "SHMIDCastFeedbackView.h"

static NSString *headerTextString = @"Sorry, no cast targets found.";
static NSString *subTextString = @"Are you on the same wi-fi network as your supported devices?";

@implementation SHMIDCastFeedbackView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self layoutView];
    }
    return self;
}

- (void)layoutView {
    
    UIColor *textColor = [UIColor whiteColor];
    
    UIView *containerView = [[UIView alloc] init];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    headerLabel.text = headerTextString;
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.textColor = textColor;
    headerLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16.0];
    
    UILabel *subtextLabel = [[UILabel alloc] init];
    subtextLabel.translatesAutoresizingMaskIntoConstraints = NO;
    subtextLabel.text = subTextString;
    subtextLabel.numberOfLines = 2;
    subtextLabel.textAlignment = NSTextAlignmentCenter;
    subtextLabel.textColor = textColor;
    subtextLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14.0];
    
    [containerView addSubview:headerLabel];
    [containerView addSubview:subtextLabel];
    [self addSubview:containerView];
    
    NSLayoutConstraint *containerWidth   = [containerView.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.80];
    NSLayoutConstraint *containerHeight  = [containerView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.60];
    NSLayoutConstraint *containerCenterX = [containerView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor];
    NSLayoutConstraint *containerCenterY = [containerView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor];
    [NSLayoutConstraint activateConstraints:@[containerWidth, containerHeight, containerCenterX, containerCenterY]];
    NSLayoutConstraint *headerLabelCenterXAnchor      = [headerLabel.centerXAnchor constraintEqualToAnchor:containerView.centerXAnchor];
    NSLayoutConstraint *headerLabelAlignBottonCenterY = [headerLabel.bottomAnchor constraintEqualToAnchor:containerView.centerYAnchor constant:-10.0];
    NSLayoutConstraint *subtextLabelCenterXAnchor     = [subtextLabel.centerXAnchor constraintEqualToAnchor:headerLabel.centerXAnchor];
    NSLayoutConstraint *subtextLabelWidthAnchor       = [subtextLabel.widthAnchor constraintEqualToAnchor:containerView.widthAnchor];
    NSLayoutConstraint *subtextLabelVerticalSpacing   = [subtextLabel.topAnchor constraintEqualToAnchor:headerLabel.bottomAnchor constant:10.0];
    [NSLayoutConstraint activateConstraints:@[headerLabelCenterXAnchor, headerLabelAlignBottonCenterY, subtextLabelCenterXAnchor, subtextLabelWidthAnchor, subtextLabelVerticalSpacing]];
}

@end
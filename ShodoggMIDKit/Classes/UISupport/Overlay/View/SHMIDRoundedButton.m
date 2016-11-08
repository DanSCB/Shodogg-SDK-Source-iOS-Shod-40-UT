//
//  SHMIDRoundedButton.m
//  Pods
//
//  Created by Aamir Khan on 2/23/16.
//
//

#import "SHMIDRoundedButton.h"
#import <QuartzCore/QuartzCore.h>

@interface SHMIDRoundedButton()
@end

@implementation SHMIDRoundedButton

- (instancetype)initWithFrame:(CGRect)frame appearance:(SHMIDButtonAppearance)appearance {
    if (self = [super initWithFrame:frame]) {
        [self setMidAppearance:appearance];
    }
    return self;
}

- (void)setMidAppearance:(SHMIDButtonAppearance)midAppearance {
    _midAppearance = midAppearance;
    [self configure];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)awakeFromNib {
    [self configure];
}

- (void)configure {
    CGFloat radius = CGRectGetHeight(self.frame)/2.f;
    UIColor *blueAppearanceColor = [UIColor colorWithRed:0.0f/255.0f green:198.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    UIColor *appearanceColor = _midAppearance == SHMIDButtonAppearanceBlue ? blueAppearanceColor : [UIColor whiteColor];
    [[self layer] setMasksToBounds:YES];
    [[self layer] setCornerRadius:radius];
    [[self layer] setBorderWidth:1.0f];
    [[self layer] setBorderColor:appearanceColor.CGColor];
    [self setTitleColor:appearanceColor forState:UIControlStateNormal];
    [self setBackgroundImage:[self generateImageFromColor:appearanceColor] forState:UIControlEventTouchDown];
}

- (UIImage *)generateImageFromColor:(UIColor *)color {
    UIColor *colorWithAlpha = [color colorWithAlphaComponent:0.6];
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [colorWithAlpha setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
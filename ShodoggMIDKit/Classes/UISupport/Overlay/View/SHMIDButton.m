//
//  SHMIDButton.m
//  Pods
//
//  Created by Aamir Khan on 12/10/15.
//
//

#import "SHMIDButton.h"
#import "SHMIDScreen.h"
#import "SHMIDUtilities.h"

NSString* const kMIDButtonNeedsAppearanceUpdateNotification = @"MIDButtonNeedsAppearanceUpdateNotificationKey";

@interface SHMIDButton()
@end

@implementation SHMIDButton

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self configureButton];
    }
    return self;
}

- (void)awakeFromNib {
    [self configureButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setIconImageNameOff:(NSString *)iconImageNameOff {
    _iconImageNameOff = iconImageNameOff;
    [self setImage:[SHMIDUtilities imageNamed:iconImageNameOff] forState:UIControlStateNormal];
}

- (void)configureButton {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(SHMIDButtonNeedsAppearanceUpdateNotification:)
                                                 name:kMIDButtonNeedsAppearanceUpdateNotification object:nil];
}

- (void)SHMIDButtonNeedsAppearanceUpdateNotification:(NSNotification *)notification {
    if ([SHMIDScreen sharedScreen].state == SHMIDScreenStateSynced) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setImage:[SHMIDUtilities imageNamed:_iconImageNameOn] forState:UIControlStateNormal];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setImage:[SHMIDUtilities imageNamed:_iconImageNameOff] forState:UIControlStateNormal];
        });
    }
}
@end
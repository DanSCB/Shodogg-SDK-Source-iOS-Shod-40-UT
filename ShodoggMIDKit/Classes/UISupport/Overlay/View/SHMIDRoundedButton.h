//
//  SHMIDRoundedButton.h
//  Pods
//
//  Created by Aamir Khan on 2/23/16.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SHMIDButtonAppearance) {
    SHMIDButtonAppearanceWhite,
    SHMIDButtonAppearanceBlue
};

@interface SHMIDRoundedButton : UIButton

@property (nonatomic) SHMIDButtonAppearance midAppearance;

- (instancetype)initWithFrame:(CGRect)frame appearance:(SHMIDButtonAppearance)appearance;
@end
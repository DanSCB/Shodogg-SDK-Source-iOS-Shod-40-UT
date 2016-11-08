//
//  SHMIDButton.h
//  Pods
//
//  Created by Aamir Khan on 12/10/15.
//
//

#import <UIKit/UIKit.h>

extern NSString* const kMIDButtonNeedsAppearanceUpdateNotification;

@interface SHMIDButton : UIButton

@property (nonatomic, copy) NSString *iconImageNameOn;
@property (nonatomic, copy) NSString *iconImageNameOff;

@end
//
//  SHMIDRadialMenu.h
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 8/24/16.
//
//

#import <UIKit/UIKit.h>
#import "SHMIDRadialSubMenu.h"

typedef NS_ENUM(NSInteger, SHMIDRadialMenuState) {
    SHMIDRadialMenuClosed,
    SHMIDRadialMenuOpening,
    SHMIDRadialMenuOpened,
    SHMIDRadialMenuHighlighted,
    SHMIDRadialMenuUnHighlighted,
    SHMIDRadialMenuActivated,
    SHMIDRadialMenuClosing
};

@class SHMIDRadialMenu;

@protocol SHMIDRadiaMenuDelegate <NSObject>

- (void)radialMenuDidActivate:(SHMIDRadialSubMenu *)subMenu;
- (void)radialMenuDidHighlight:(SHMIDRadialSubMenu *)subMenu;
- (void)radialMenuDidUnHighlight:(SHMIDRadialSubMenu *)subMenu;
- (void)radialMenuDidClose;

@end

@interface SHMIDRadialMenu : UIView

@property (weak) id<SHMIDRadiaMenuDelegate> delegate;

@property (nonatomic, readonly) SHMIDRadialMenuState state;

@property (nonatomic) UIView *backgroundView;

@property (nonatomic) int minAngle;
@property (nonatomic) int maxAngle;
@property (nonatomic) CGFloat radiusStep;
@property (nonatomic) CGFloat openDelayStep;
@property (nonatomic) CGFloat closeDelayStep;
@property (nonatomic) CGFloat activatedDelay;
@property (nonatomic) CGFloat highlightDistance;
@property (nonatomic) BOOL allowsMultipleHighlights;

- (instancetype)initWithMenus:(NSArray *)menus;
- (instancetype)initWithMenus:(NSArray *)menus radius:(CGFloat)radius;

- (void)openAtPosition:(CGPoint)position;
- (void)moveAtPosition:(CGPoint)position;
- (void)close;
@end
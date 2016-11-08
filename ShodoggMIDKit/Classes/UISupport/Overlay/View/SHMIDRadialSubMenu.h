//
//  SHMIDRadialSubMenu.h
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 8/23/16.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SHMIDRadialSubMenuState) {
    SHMIDRadialSubMenuClosed,
    SHMIDRadialSubMenuOpening,
    SHMIDRadialSubMenuOpened,
    SHMIDRadialSubMenuHighlighted,
    SHMIDRadialSubMenuUnHighlighted,
    SHMIDRadialSubMenuActivated,
    SHMIDRadialSubMenuClosing
};

@class SHMIDRadialSubMenu;

@protocol SHMIDRadiaSubMenuDelegate <NSObject>

- (void)subMenuDidOpen:(SHMIDRadialSubMenu *)subMenu;
- (void)subMenuDidHighlight:(SHMIDRadialSubMenu *)subMenu;
- (void)subMenuDidActivate:(SHMIDRadialSubMenu *)subMenu;
- (void)subMenuDidUnHighlight:(SHMIDRadialSubMenu *)subMenu;
- (void)subMenuDidClose:(SHMIDRadialSubMenu *)subMenu;

@end

@interface SHMIDRadialSubMenu : UIView

@property (weak) id<SHMIDRadiaSubMenuDelegate> delegate;
@property (nonatomic, readonly) SHMIDRadialSubMenuState state;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic) double distance;

- (instancetype)initWithImageView:(UIImageView *)imageView;

- (void)openAtPosition:(CGPoint)position fromPosition:(CGPoint)fromPosition delay:(double)delay;
- (void)activate:(double)delay;
- (void)highlight;
- (void)unhighlight;
- (void)close:(double)delay;
- (void)removeAllAnimations;

@end
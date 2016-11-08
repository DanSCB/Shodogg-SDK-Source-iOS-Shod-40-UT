//
//  SHMIDRadialMenuViewController.h
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 8/25/16.
//
//

#import <UIKit/UIKit.h>
#import "SHMIDRadialMenu.h"
#import "SHMIDRadialSubMenu.h"

@protocol SHMIDRadialMenuViewControllerDelegate <NSObject>
- (void)radialMenu:(SHMIDRadialMenu *)menu didSelectSubMenuAtIndex:(NSInteger)index;
@end

@interface SHMIDRadialMenuViewController : UIViewController

@property (weak) id<SHMIDRadialMenuViewControllerDelegate> delegate;
@property (nonatomic) CGPoint openingPosition;

- (void)moveAtPosition:(CGPoint)position;
- (void)close;

@end
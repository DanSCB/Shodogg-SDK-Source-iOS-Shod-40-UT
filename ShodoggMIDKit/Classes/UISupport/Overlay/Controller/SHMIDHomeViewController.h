//
//  SHMIDHomeViewController.h
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 5/19/16.
//
//

#import <UIKit/UIKit.h>

@protocol SHMIDHomeViewControllerDelegate <NSObject>
- (void)castControlsViewNeedsLayout;
@end

@interface SHMIDHomeViewController : UIViewController
@property (weak) id <SHMIDHomeViewControllerDelegate> delegate;

@property (nonatomic, assign) BOOL showSelectedContext;
@property (nonatomic, assign) BOOL shouldShowCastDestinations;

- (void)switchToToolbarFromController:(UIViewController *)controller openOnPresentation:(BOOL)open;
- (void)dismissToolbar;
@end
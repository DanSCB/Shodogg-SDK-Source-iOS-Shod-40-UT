//
//  SHMIDSettingsViewController.h
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 4/6/16.
//
//

#import <UIKit/UIKit.h>

@protocol SHMIDSettingsViewControllerDelegate <NSObject>
- (void)didDismissController:(UIViewController *)controller;
@end

@interface SHMIDSettingsViewController : UITableViewController
@property (weak) id <SHMIDSettingsViewControllerDelegate> delegate;
@end

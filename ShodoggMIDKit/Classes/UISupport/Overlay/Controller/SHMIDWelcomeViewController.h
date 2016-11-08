//
//  SHMIDWelcomeViewController.h
//  Pods
//
//  Created by Aamir Khan on 5/13/16.
//
//

#import <UIKit/UIKit.h>

@protocol SHMIDWelcomeViewControllerDelegate <NSObject>
- (void)didFinishFirstTimeUserExperience:(UIViewController *)controller;
@end

@interface SHMIDWelcomeViewController : UIViewController
@property (weak) id<SHMIDWelcomeViewControllerDelegate> delegate;
@end

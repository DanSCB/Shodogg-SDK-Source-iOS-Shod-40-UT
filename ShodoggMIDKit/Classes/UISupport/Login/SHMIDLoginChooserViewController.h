//
//  SHMIDLoginChooserViewController.h
//  Pods
//
//  Created by Aamir Khan on 2/25/16.
//
//

#import <UIKit/UIKit.h>

typedef void(^SHLoginChooserDoneBlock)(NSError *error);

@interface SHMIDLoginChooserViewController : UIViewController

+ (instancetype)controllerWithCompletionBlock:(SHLoginChooserDoneBlock)completion;

@end
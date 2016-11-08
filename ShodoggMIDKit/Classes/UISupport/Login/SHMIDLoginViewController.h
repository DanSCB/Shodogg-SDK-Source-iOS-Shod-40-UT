//
//  SHMIDLoginViewController.h
//  Pods
//
//  Created by Aamir Khan on 12/11/15.
//
//

#import <UIKit/UIKit.h>

typedef void(^SHLoginDoneBlock)(NSError *error);

@interface SHMIDLoginViewController : UIViewController

+ (SHMIDLoginViewController *)controllerWithModalPresentationStyle:(UIModalPresentationStyle)presentationStyle
                                              loginCompletionBlock:(SHLoginDoneBlock)block;

@property (nonatomic, copy) NSString *emailAddress;

@end
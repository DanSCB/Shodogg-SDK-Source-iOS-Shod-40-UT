//
//  SHMIDAuthViewController.h
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 10/30/15.
//  Copyright (c) 2015 Shodogg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHMIDAuth.h"

typedef void(^SHAuthControllerDoneBlock)(void);

@interface SHMIDAuthViewController : UIViewController <SHMIDAuthDelegate>

- (instancetype)initWithAuthProvider:(SHAuthProvider)provider
                authorizationURL:(NSURL *)url
                 completionBlock:(SHAuthControllerDoneBlock)block;
@end
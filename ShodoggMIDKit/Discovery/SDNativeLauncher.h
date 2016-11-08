//
//  SDNativeLauncher.h
//  ShodoggSDK
//
//  Created by stepukaa on 11/5/15.
//  Copyright © 2015 stepukaa. All rights reserved.
//

#import "SDLauncher.h"

@class LaunchSession;

@interface SDNativeLauncher : SDLauncher

@property(nonatomic, strong)LaunchSession *session;

@end

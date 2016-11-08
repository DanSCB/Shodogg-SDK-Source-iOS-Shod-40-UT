//
//  SDWebLauncher.h
//  ShodoggSDK
//
//  Created by stepukaa on 11/5/15.
//  Copyright © 2015 stepukaa. All rights reserved.
//

#import "SDLauncher.h"

@class WebAppSession;

@interface SDWebLauncher : SDLauncher

@property(nonatomic, strong)WebAppSession *session;

@end

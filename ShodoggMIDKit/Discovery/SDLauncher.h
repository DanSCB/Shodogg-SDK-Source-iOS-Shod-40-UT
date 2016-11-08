//
//  SDLauncher.h
//  ShodoggSDK
//
//  Created by stepukaa on 11/2/15.
//  Copyright © 2015 stepukaa. All rights reserved.
//

@import Foundation;

#import "SDRemoteReceiver.h"
#import "SDConnectableDevice.h"

@class ConnectableDevice;

@interface SDLauncher : NSObject

+ (instancetype)launcherForDevice:(ConnectableDevice*)device;

- (NSString*)remoteRecieverIdentificator:(SDRemoteReceiver*)receiver;

- (void)installApplication:(SDRemoteReceiver*)receiver
                  onDevice:(ConnectableDevice*)device
            withCompletion:(SDConnectableDeviceActionCompletion)completion;

- (void)launchApplication:(SDRemoteReceiver*)receiver
                 onDevice:(ConnectableDevice*)device
           withCompletion:(SDConnectableDeviceActionCompletion)completion;

- (void)closeApplication:(SDRemoteReceiver*)receiver
                onDevice:(ConnectableDevice*)device
          withCompletion:(SDConnectableDeviceActionCompletion)completion;
@end
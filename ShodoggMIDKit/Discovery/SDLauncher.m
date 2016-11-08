//
//  SDLauncher.m
//  ShodoggSDK
//
//  Created by stepukaa on 11/2/15.
//  Copyright © 2015 stepukaa. All rights reserved.
//

#import "SDLauncher.h"
#import "SDDeviceTypeDetector.h"
#import "SDFireTVLauncher.h"
#import "SDLGTVLauncher.h"
#import "SDChromcastLauncher.h"
#import "SDSamsungLauncher.h"

@implementation SDLauncher

+ (instancetype)launcherForDevice:(ConnectableDevice*)device {
    
    SDConnectableDeviceType type = [SDDeviceTypeDetector deviceTypeFromDevice:device];
    
    switch (type) {
        case SDConnectableDeviceChromecast:
            return [SDChromcastLauncher new];
            
        case SDConnectableDeviceFireTV:
            return [SDFireTVLauncher new];
            
        case  SDConnectableDeviceLG:
            return [SDLGTVLauncher new];

        case SDConnectableDeviceSamsung:
            return [SDSamsungLauncher new];
        
        default:
            NSAssert(NO, @"Device is not supported.");
            return nil;
    }
}

- (NSString*)remoteRecieverIdentificator:(SDRemoteReceiver *)receiver {
    NSAssert(NO, @"Has to be overriden");
    return nil;
}

- (void)installApplication:(SDRemoteReceiver*)receiver
                  onDevice:(ConnectableDevice*)device
            withCompletion:(SDConnectableDeviceActionCompletion)completion {
    NSAssert(NO, @"Has to be overriden");
}

- (void)launchApplication:(SDRemoteReceiver*)receiver
                 onDevice:(ConnectableDevice*)device
           withCompletion:(SDConnectableDeviceActionCompletion)completion {
    NSAssert(NO, @"Has to be overriden");
}

- (void)closeApplication:(SDRemoteReceiver*)receiver
                onDevice:(ConnectableDevice*)device
          withCompletion:(SDConnectableDeviceActionCompletion)completion {
    NSAssert(NO, @"Has to be overriden");
}

@end

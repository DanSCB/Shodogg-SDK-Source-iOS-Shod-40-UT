//
//  SDLGTVLauncher.m
//  ShodoggSDK
//
//  Created by stepukaa on 11/3/15.
//  Copyright © 2015 stepukaa. All rights reserved.
//

#import "SDLGTVLauncher.h"
#import "SDRemoteReceiverLG.h"

@interface SDLGTVLauncher()

@end

@implementation SDLGTVLauncher

- (NSString*)remoteRecieverIdentificator:(SDRemoteReceiver*)receiver {
    if (![receiver isMemberOfClass:[SDRemoteReceiverLG class]]) {
        [NSException raise:@"Wrong receiver format."
                    format:@"SDRemoteReceiverLG should be used on SDConnectableDeviceLG device"];
    }
    
    SDRemoteReceiverLG *lgReceiver = (SDRemoteReceiverLG*)receiver;
    return lgReceiver.identifier;
}

- (void)installApplication:(SDRemoteReceiver*)receiver
                  onDevice:(ConnectableDevice*)device
            withCompletion:(SDConnectableDeviceActionCompletion)completion {
    NSAssert(NO, @"Not implemented");
}

@end

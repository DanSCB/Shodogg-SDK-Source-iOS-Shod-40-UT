//
//  SDFireTVLauncher.m
//  ShodoggSDK
//
//  Created by stepukaa on 11/3/15.
//  Copyright © 2015 stepukaa. All rights reserved.
//

#import "SDFireTVLauncher.h"
#import "SDRemoteReceiverFireTV.h"

@implementation SDFireTVLauncher

- (NSString*)remoteRecieverIdentificator:(SDRemoteReceiver*)receiver {
    if (![receiver isMemberOfClass:[SDRemoteReceiverFireTV class]]) {
        [NSException raise:@"Wrong receiver format."
                    format:@"SDRemoteReceiverFireTV should be used on \
                             SDConnectableDeviceFireTV device"];
    }
    
    SDRemoteReceiverFireTV *fireReceiver = (SDRemoteReceiverFireTV *)receiver;
    return fireReceiver.identifier;
}

- (void)installApplication:(SDRemoteReceiver*)receiver
                  onDevice:(ConnectableDevice*)device
            withCompletion:(SDConnectableDeviceActionCompletion)completion {
    NSAssert(NO, @"Not implemented");
}

@end

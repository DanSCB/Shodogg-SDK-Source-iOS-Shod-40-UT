//
//  SDNativeLauncher.m
//  ShodoggSDK
//
//  Created by stepukaa on 11/5/15.
//  Copyright © 2015 stepukaa. All rights reserved.
//

#import "SDNativeLauncher.h"

@implementation SDNativeLauncher

- (void)launchApplication:(SDRemoteReceiver*)receiver
                 onDevice:(ConnectableDevice*)device
           withCompletion:(SDConnectableDeviceActionCompletion)completion {
    NSString *appIdentifier = [self remoteRecieverIdentificator:receiver];
    AppInfo *appInfo = [AppInfo appInfoForId:appIdentifier];
    
    __weak typeof(self) weakSelf = self;
    
    [device.launcher launchAppWithInfo:appInfo
                                params:receiver.parameters
                               success:^(LaunchSession *launchSession) {
        weakSelf.session = launchSession;
        if (completion) {
            completion(YES, nil);
        }
    } failure:^(NSError *error) {
        if (completion) {
            completion(NO, error);
        }
    }];
}

- (void)closeApplication:(SDRemoteReceiver*)receiver
                onDevice:(ConnectableDevice*)device
          withCompletion:(SDConnectableDeviceActionCompletion)completion {
    [self.session closeWithSuccess:^(id responseObject) {
        if (completion) {
            completion(YES, nil);
        }
    } failure:^(NSError *error) {
        if (completion) {
            completion(NO, error);
        }
    }];
    
    self.session = nil;
}

@end

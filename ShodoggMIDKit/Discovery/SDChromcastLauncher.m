//
//  SDChromcastLauncher.m
//  ShodoggSDK
//
//  Created by stepukaa on 11/3/15.
//  Copyright © 2015 stepukaa. All rights reserved.
//

#import "SDChromcastLauncher.h"
#import "SDRemoteReceiverChromecast.h"

@implementation SDChromcastLauncher

- (NSString*)remoteRecieverIdentificator:(SDRemoteReceiver*)receiver {
    if (![receiver isMemberOfClass:[SDRemoteReceiverChromecast class]]) {
        [NSException raise:@"Wrong receiver format."
                    format:@"SDRemoteReceiverChromecast should be used on \
                             SDConnectableDeviceChromecast device"];
    }
    
    SDRemoteReceiverChromecast *chromeReceive = (SDRemoteReceiverChromecast*)receiver;
    return chromeReceive.identifier;
}

- (void)installApplication:(SDRemoteReceiver*)receiver
                  onDevice:(ConnectableDevice*)device
            withCompletion:(SDConnectableDeviceActionCompletion)completion {
    NSAssert(NO, @"Not applicable.");
}

- (void)launchApplication:(SDRemoteReceiver*)receiver
                 onDevice:(ConnectableDevice*)device
           withCompletion:(SDConnectableDeviceActionCompletion)completion {
    NSString *appIdentifier = [self remoteRecieverIdentificator:receiver];
    
    __weak typeof(self) weakSelf = self;

    [device.webAppLauncher launchWebApp:appIdentifier
                      relaunchIfRunning:YES
                                success:^(WebAppSession *webAppSession) {
        weakSelf.session = webAppSession;
        
        [webAppSession connectWithSuccess:^(id responseObject) {
            
            [webAppSession sendJSON:receiver.parameters success:^(id responseObject) {
                
                if (completion) {
                    completion(YES, nil);
                }
            } failure:^(NSError *error) {
                if (completion) {
                    completion(NO, error);
                }
            }];
        } failure:^(NSError *error) {
            if (completion) {
                completion(NO, error);
            }
        }];
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

#pragma mark -

@end

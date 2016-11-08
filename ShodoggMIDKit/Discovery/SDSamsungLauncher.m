//
//  SDSamsungLauncher.m
//  ShodoggSDK
//
//  Created by stepukaa on 11/3/15.
//  Copyright © 2015 stepukaa. All rights reserved.
//

#import "SDSamsungLauncher.h"
#import "SDRemoteReceiverSamsung.h"

static NSString *const kSamsungApplicationTypeKey = @"apptype";
static NSString *const kSamsungCloudApplicationTypeValue = @"Shodogg-SamsungTizenTV-CloudApp";

@implementation SDSamsungLauncher

- (NSString*)remoteRecieverIdentificator:(SDRemoteReceiver*)receiver {
    if (![receiver isMemberOfClass:[SDRemoteReceiverSamsung class]]) {
        [NSException raise:@"Wrong receiver format."
                    format:@"SDRemoteReceiverSamsung should be used on \
         SDConnectableDeviceSamsung device"];
    }
    
    SDRemoteReceiverSamsung *samsungReceiver = (SDRemoteReceiverSamsung*)receiver;
    return samsungReceiver.cloudIdentifier;
}

- (void)launchApplication:(SDRemoteReceiver*)receiver
                 onDevice:(ConnectableDevice*)device
           withCompletion:(SDConnectableDeviceActionCompletion)completion {
    NSString *appIdentifier = [self remoteRecieverIdentificator:receiver];
    
    SDRemoteReceiverSamsung *samsungReceiver = (SDRemoteReceiverSamsung*)receiver;
    NSString *channelURI = samsungReceiver.channelURI;
    
    NSMutableDictionary *parameters =
        [NSMutableDictionary dictionaryWithDictionary:receiver.parameters];
    parameters[kSamsungChannelURI] = channelURI;
    parameters[kSamsungApplicationTypeKey] = kSamsungCloudApplicationTypeValue;
    
    NSLog(@"%s - Attempt launching SamsungTVApp: \n\tid:%@, %@\n", __PRETTY_FUNCTION__, appIdentifier, parameters);
    
    __weak typeof(self) weakSelf = self;
    [device.webAppLauncher launchWebApp:appIdentifier
                                 params:parameters
                                success:^(WebAppSession *webAppSession) {
        NSLog(@"%s - success launching SamsungTVApp. WebAppSession: %@", __PRETTY_FUNCTION__, webAppSession);
        weakSelf.session = webAppSession;
        if (completion) {
            completion(YES, nil);
        }
    } failure:^(NSError *error) {
        NSLog(@"%s - failed to launch SamsungTVApp. Error: %@", __PRETTY_FUNCTION__, error);
        if (completion) {
            completion(NO, error);
        }
    }];
}

- (void)closeApplication:(SDRemoteReceiver*)receiver
                onDevice:(ConnectableDevice*)device
          withCompletion:(SDConnectableDeviceActionCompletion)completion {
    
    NSLog(@"%s - Attempt closing SamsungTVApp", __PRETTY_FUNCTION__);
    
    [device.webAppLauncher closeWebApp:nil success:^(id responseObject) {
        NSLog(@"%s - success closing SamsungTVApp, response: %@", __PRETTY_FUNCTION__, responseObject);
        if (completion) {
            completion(YES, nil);
        }
    } failure:^(NSError *error) {
        NSLog(@"%s - failed to close SamsungTVApp. Error: %@", __PRETTY_FUNCTION__, error);
        if (completion) {
            completion(NO, error);
        }
    }];

    self.session = nil;
}

@end

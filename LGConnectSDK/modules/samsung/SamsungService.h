//
//  SamsungService.h
//  ConnectSDK
//
//  Created by Artem Stepuk on 11/13/15.
//  Copyright © 2015 LG Electronics. All rights reserved.
//

#import "DeviceService.h"
#import "WebAppLauncher.h"

extern NSString * const kSamsungServiceId;
extern NSString * const kSamsungChannelURI;

@interface SamsungService : DeviceService <WebAppLauncher>

@end

//
//  SHMIDNetUtil.h
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 7/1/16.
//
//

#import <Foundation/Foundation.h>

@interface SHMIDNetUtil : NSObject

+ (NSString *)getDefaultGatewayIPAddress;
+ (NSString *)getDefaultGatewayMacAddress;
+ (NSString *)getMACAddressForDeviceWithIP:(NSString *)ipAddress;
+ (NSString *)getCurrentAPMacAddress;
+ (NSString *)getCurrentAPSSIDString;

@end
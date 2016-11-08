//
//  SHMobileDeviceInfoDTO.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 11/13/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import "SHMobileDeviceInfoDTO.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "UIDevice-Hardware.h"
#import <Reachability/Reachability.h>
#import "SHUtilities.h"

@interface SHMobileDeviceInfoDTO()
@property (nonatomic, readwrite, copy) NSString *udidString;
@property (nonatomic, readwrite, copy) NSString *modelString;
@property (nonatomic, readwrite, copy) NSString *modelNameString;
@property (nonatomic, readwrite, copy) NSString *systemNameString;
@property (nonatomic, readwrite, copy) NSString *systemVersionString;
@property (nonatomic, readwrite, copy) NSString *appNameString;
@property (nonatomic, readwrite, copy) NSString *appVersionString;
@property (nonatomic, readwrite, copy) NSString *carrierString;
@property (nonatomic, readwrite, copy) NSString *deviceNameString;
@property (nonatomic, readwrite, copy) NSString *bundleIdentifierString;
@property (nonatomic, readwrite, copy) NSString *modelIdentifierString;
@property (nonatomic, readwrite, assign) BOOL cellularConnection;
@end

@implementation SHMobileDeviceInfoDTO


+ (instancetype)sharedInstance
{
    static SHMobileDeviceInfoDTO *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[SHMobileDeviceInfoDTO alloc] initWithMobileDeviceInfo];
    });
    return _instance;
}

+ (NSDictionary *)mobileInfoDictionary
{
    SHMobileDeviceInfoDTO *deviceInfo = [SHMobileDeviceInfoDTO sharedInstance];
    return @{@"deviceId"                  : deviceInfo.udid,
             @"type"                      : deviceInfo.model,
             @"version"                   : deviceInfo.modelName,
             @"operatingSys"              : deviceInfo.systemName,
             @"operatingSysVersion"       : deviceInfo.systemVersion,
             @"appName"                   : NilToEmptyString(deviceInfo.appName),
             @"appVersion"                : NilToEmptyString(deviceInfo.appVersion),
             @"connectedByMobileNetwork"  : deviceInfo.cellular,
             @"mobileNetworkProvider"     : deviceInfo.carrier,
             @"addlDeviceInfo"            : deviceInfo.addlInfo};
}

- (instancetype)initWithMobileDeviceInfo
{
    self = [super init];
    if (!self) {
        return nil;
    }
    CTCarrier *carrier = [[[CTTelephonyNetworkInfo alloc] init] subscriberCellularProvider];
    self.udidString             = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    self.modelString            = [[UIDevice currentDevice] model];
    self.modelNameString        = [[UIDevice currentDevice] modelName];
    self.systemNameString       = [[UIDevice currentDevice] systemName];
    self.systemVersionString    = [[UIDevice currentDevice] systemVersion];
    self.appNameString          = [self extractAppNameFromInfoPlist];
    self.appVersionString       = [self infoPlistObjectForKey:@"CFBundleShortVersionString"];
    self.carrierString          = NilToEmptyString([carrier carrierName]);
    self.cellularConnection     = [self checkCellularConnectionStatus];
    self.deviceNameString       = [[UIDevice currentDevice] name];
    self.modelIdentifierString  = [[UIDevice currentDevice] modelIdentifier];
    self.bundleIdentifierString = [self infoPlistObjectForKey:@"CFBundleIdentifier"];
    return self;
}

- (NSString *)udid
{
    return _udidString;
}

- (NSString *)model
{
    return _modelString;
}

- (NSString *)modelName
{
    return _modelNameString;
}

- (NSString *)systemName
{
    return _systemNameString;
}

- (NSString *)systemVersion
{
    return _systemVersionString;
}

- (NSString *)appName
{
    return _appNameString;
}

- (NSString *)appVersion
{
    return _appVersionString;
}

- (NSString *)cellular
{
    return _cellularConnection ? @"true" : @"false";
}

- (NSString *)carrier
{
    return _carrierString;
}

- (NSDictionary *)addlInfo
{
    return @{@"device_name"        : self.deviceNameString,
             @"bundle_identifier"  : self.bundleIdentifierString,
             @"model_identifier"   : self.modelIdentifierString};
}

#pragma mark - Reachability
- (BOOL)checkCellularConnectionStatus
{
    Reachability *reachability  = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    if (networkStatus == ReachableViaWWAN) {
        return YES;
    }
    return NO;
}

#pragma mark - InfoPlist
- (NSString *)infoPlistObjectForKey:(NSString *)key
{
    NSDictionary *infoPlistDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoPlistDictionary objectForKey:key];
}

- (NSString *)descriptionAsString {
    return [NSString stringWithFormat:@"\n\tudid: %@;\n\tmodel: %@;\n\tmodelName: %@;\n\tsystemName: %@;\n\tsystemVersion: %@;\n\tappName: %@;\n\tappVersion: %@;\n\tcellular: %@;\n\tcarrier: %@;\n\taddlinfo: %@;\n",
            self.udid, self.model, self.modelName, self.systemName, self.systemVersion, self.appName, self.appVersion, self.cellular, self.carrier, self.addlInfo];
}

- (NSString *)extractAppNameFromInfoPlist {
    NSString *name;
    if ([self infoPlistObjectForKey:@"CFBundleDisplayName"]) {
        name = [self infoPlistObjectForKey:@"CFBundleDisplayName"];
    } else {
        name = [self infoPlistObjectForKey:@"CFBundleName"];
    }
    return name;
}
@end
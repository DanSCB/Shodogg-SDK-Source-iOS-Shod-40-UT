//
//  SHMIDMTLTargetCastDevice.m
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 7/26/16.
//
//

#import "SHMIDMTLTargetCastDevice.h"
#import "SDConnectableDevicePrivate.h"
#import "SHMIDNetUtil.h"
#import "SHMIDUtilities.h"
#import "SHMIDRealmManager.h"

@interface SHMIDMTLTargetCastDevice()
@property (readwrite, assign) unsigned long long firstDiscovered;
@end

@implementation SHMIDMTLTargetCastDevice

#pragma mark - Mantle JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"friendlyName"            : @"f_name",
             @"modelName"               : @"mod_name",
             @"modelNumber"             : @"mod_num",
             @"operatingSystem"         : @"os",
             @"operatingSystemVersion"  : @"os_ver",
             @"macAddress"              : @"mac_addr",
             @"ipAddress"               : @"ip_addr",
             @"ip6Address"              : @"ip6_addr",
             @"firstDiscovered"         : @"dsc_f",
             @"lastDiscovered"          : @"dsc_l"};
}

#pragma mark - Initializer

- (instancetype)initWithConnectableDevice:(SDConnectableDevice *)device {
    
    self = [super init];
    if (!self) {return nil;}

    _friendlyName   = device.friendlyName;
    _modelName      = device.modelName;
    _modelNumber    = device.modelNumber;
    _ipAddress      = device.ipAddr;
    _macAddress     = [SHMIDNetUtil getMACAddressForDeviceWithIP:device.ipAddr];
    _lastDiscovered = [@(device.connectSDKDevice.lastDetection*1000) unsignedLongLongValue];
    
    RLMResults<SHMIDRLMTargetCastDevice *> *syncedDevices = [SHMIDRLMTargetCastDevice objectsWhere:@"macAddress = %@", _macAddress];
    if (syncedDevices.count) {
        SHMIDRLMTargetCastDevice *device = [syncedDevices firstObject];
        _firstDiscovered = device.firstDiscovered;
        NSLog(@"%s - Found a match: %@, first discovered at %@", __PRETTY_FUNCTION__, device.friendlyName, dateString(device.firstDiscovered));
    } else {
        _firstDiscovered = [SHMIDUtilities currentTimeInMilliseconds];
    }
    
    return self;
}

- (instancetype)initWithRLMModel:(SHMIDRLMTargetCastDevice *)rlmModel {
    
    self = [super init];
    if (!self) {return nil;}
    
    _friendlyName    = rlmModel.friendlyName;
    _modelName       = rlmModel.modelName;
    _modelNumber     = rlmModel.modelNumber;
    _ipAddress       = rlmModel.ipAddress;
    _macAddress      = rlmModel.macAddress;
    _firstDiscovered = rlmModel.firstDiscovered;
    _lastDiscovered  = rlmModel.lastDiscovered;
    
    return self;
}

#pragma mark - Convenience

- (BOOL)hasValidJson {
    if (!self.macAddress.length) {
        return NO;
    }
    return YES;
}

#pragma mark - Realm

- (void)save {
    if (![self hasValidJson]) {
        return;
    }
    SHMIDRLMHousehold *household = [[SHMIDMTLHousehold alloc] initCurrentHousehold];
    SHMIDRLMTargetCastDevice *toRLMModel = [[SHMIDRLMTargetCastDevice alloc] initWithMTLModel:self];
    if (household) {
        toRLMModel.household = household;
    }
    if (toRLMModel) {
        [[SHMIDRealmManager defaultManager] addOrUpdateObject:toRLMModel];
    }
}
@end

//
//  SHMIDMTLHousehold.m
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 7/26/16.
//
//

#import "SHMIDMTLHousehold.h"
#import "SHMIDNetUtil.h"
#import "SHMIDRealmManager.h"

@implementation SHMIDMTLHousehold

#pragma mark - Mantle JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"ssid" : @"ssid", @"ipAddress"  : @"ip_addr", @"ip6Address" : @"ip6_addr", @"macAddress" : @"mac_addr"};
}

#pragma mark - Initializer

- (instancetype)initCurrentHousehold {
    self = [super init];
    if (!self) {return nil;}
    _ssid       = [SHMIDNetUtil getCurrentAPSSIDString];
    _ipAddress  = [SHMIDNetUtil getDefaultGatewayIPAddress];
    _macAddress = [SHMIDNetUtil getDefaultGatewayMacAddress];
    return self;
}

- (instancetype)initWithRLMModel:(SHMIDRLMHousehold *)rlmModel {
    self = [super init];
    if (!self) {return nil;}
    _ssid       = rlmModel.ssid;
    _ipAddress  = rlmModel.ipAddress;
    _macAddress = rlmModel.macAddress;
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
    SHMIDRLMHousehold *toRLMModel = [[SHMIDRLMHousehold alloc] initWithMTLModel:self];
    if (toRLMModel) {
        [[SHMIDRealmManager defaultManager] addOrUpdateObject:toRLMModel];
    }
}

@end
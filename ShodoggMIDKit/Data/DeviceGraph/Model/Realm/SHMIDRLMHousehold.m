//
//  SHMIDRLMHousehold.m
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 8/2/16.
//
//

#import "SHMIDRLMHousehold.h"

@implementation SHMIDRLMHousehold

#pragma mark - Realm

+ (NSString *)primaryKey {
    return @"macAddress";
}

+ (NSDictionary<NSString *,RLMPropertyDescriptor *> *)linkingObjectsProperties {
    return @{
        @"tcds" : [RLMPropertyDescriptor descriptorWithClass:SHMIDRLMTargetCastDevice.class propertyName:@"household"],
    };
}

#pragma mark - Initializer

- (instancetype)initWithMTLModel:(SHMIDMTLHousehold *)mtlModel {
    self = [super init];
    if (!self) {return nil;}
    _ssid       = mtlModel.ssid;
    _ipAddress  = mtlModel.ipAddress;
    _macAddress = mtlModel.macAddress;
    return self;
}

@end

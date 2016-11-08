//
//  SHMIDRLMTargetCastDevice.m
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 8/1/16.
//
//

#import "SHMIDRLMTargetCastDevice.h"
#import "SHMIDUtilities.h"

@implementation SHMIDRLMTargetCastDevice

+ (NSString *)primaryKey {
    return @"macAddress";
}

- (instancetype)initWithMTLModel:(SHMIDMTLTargetCastDevice *)mtlModel {
    
    self = [super init];
    if (!self) {return nil;}
    
    _friendlyName           = mtlModel.friendlyName;
    _modelName              = mtlModel.modelName;
    _modelNumber            = mtlModel.modelNumber;
    _operatingSystem        = mtlModel.operatingSystem;
    _operatingSystemVersion = mtlModel.operatingSystemVersion;
    _macAddress             = mtlModel.macAddress;
    _ipAddress              = mtlModel.ipAddress;
    _ip6Address             = mtlModel.ip6Address;
    _lastDiscovered         = mtlModel.lastDiscovered;
    _firstDiscovered        = mtlModel.firstDiscovered;
    
    return self;
}

@end

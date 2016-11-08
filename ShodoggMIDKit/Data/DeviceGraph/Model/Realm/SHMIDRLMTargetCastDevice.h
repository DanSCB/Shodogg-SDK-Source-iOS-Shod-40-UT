//
//  SHMIDRLMTargetCastDevice.h
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 8/1/16.
//
//

#import <Realm/Realm.h>
#import "SHMIDMTLTargetCastDevice.h"
#import "SHMIDRLMHousehold.h"

@class SHMIDRLMHousehold;
@class SHMIDMTLTargetCastDevice;

@interface SHMIDRLMTargetCastDevice : RLMObject

@property NSString *friendlyName;
@property NSString *modelName;
@property NSString *modelNumber;
@property NSString *operatingSystem;
@property NSString *operatingSystemVersion;
@property NSString *macAddress;
@property NSString *ipAddress;
@property NSString *ip6Address;
@property long long firstDiscovered;
@property long long  lastDiscovered;

@property SHMIDRLMHousehold *household;

- (instancetype)initWithMTLModel:(SHMIDMTLTargetCastDevice *)mtlModel;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<SHMIDRLMTargetCastDevice>
RLM_ARRAY_TYPE(SHMIDRLMTargetCastDevice)

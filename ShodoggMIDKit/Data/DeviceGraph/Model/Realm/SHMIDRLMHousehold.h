//
//  SHMIDRLMHousehold.h
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 8/2/16.
//
//

#import <Realm/Realm.h>
#import "SHMIDMTLHousehold.h"
#import "SHMIDRLMTargetCastDevice.h"

@class SHMIDMTLHousehold;
@class SHMIDRLMTargetCastDevice;

@interface SHMIDRLMHousehold : RLMObject

@property NSString *ssid;
@property NSString *ipAddress;
@property NSString *ip6Address;
@property NSString *macAddress;

@property (readonly) RLMLinkingObjects *tcds;

- (instancetype)initWithMTLModel:(SHMIDMTLHousehold *)mtlModel;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<SHMIDRLMHousehold>
RLM_ARRAY_TYPE(SHMIDRLMHousehold)

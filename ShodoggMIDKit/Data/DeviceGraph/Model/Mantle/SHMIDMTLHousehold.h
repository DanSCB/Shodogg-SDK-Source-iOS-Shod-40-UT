//
//  SHMIDMTLHousehold.h
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 7/26/16.
//
//

#import <Mantle/Mantle.h>
#import "SHMIDRLMHousehold.h"

@class SHMIDRLMHousehold;

@interface SHMIDMTLHousehold : MTLModel <MTLJSONSerializing>

@property (readonly, nonatomic, copy) NSString *ssid;
@property (readonly, nonatomic, copy) NSString *ipAddress;
@property (readonly, nonatomic, copy) NSString *ip6Address;
@property (readonly, nonatomic, copy) NSString *macAddress;

@property (readonly, nonatomic, assign, getter = hasValidJson) BOOL validJson;

- (instancetype)initCurrentHousehold;
- (instancetype)initWithRLMModel:(SHMIDRLMHousehold *)rlmModel;

- (void)save;

@end

//
//  SHMIDMTLTargetCastDevice.h
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 7/26/16.
//
//

#import <Mantle/Mantle.h>
#import "SDConnectableDevice.h"
#import "SHMIDRLMTargetCastDevice.h"

@class SHMIDRLMTargetCastDevice;

@interface SHMIDMTLTargetCastDevice : MTLModel <MTLJSONSerializing>

@property (readonly, nonatomic,   copy) NSString *friendlyName;
@property (readonly, nonatomic,   copy) NSString *modelName;
@property (readonly, nonatomic,   copy) NSString *modelNumber;
@property (readonly, nonatomic,   copy) NSString *operatingSystem;
@property (readonly, nonatomic,   copy) NSString *operatingSystemVersion;
@property (readonly, nonatomic,   copy) NSString *macAddress;
@property (readonly, nonatomic,   copy) NSString *ipAddress;
@property (readonly, nonatomic,   copy) NSString *ip6Address;
@property (readonly, assign) unsigned long long firstDiscovered;
@property (readonly, assign) unsigned long long  lastDiscovered;

@property (readonly, nonatomic, assign, getter = hasValidJson) BOOL validJson;

- (instancetype)initWithConnectableDevice:(SDConnectableDevice *)device;
- (instancetype)initWithRLMModel:(SHMIDRLMTargetCastDevice *)rlmModel;

- (void)save;

@end
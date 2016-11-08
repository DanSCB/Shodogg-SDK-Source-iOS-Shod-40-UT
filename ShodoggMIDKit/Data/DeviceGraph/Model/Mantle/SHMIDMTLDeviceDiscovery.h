//
//  SHMIDMTLDeviceDiscovery.h
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 7/26/16.
//
//

#import <Mantle/Mantle.h>
#import "SHMIDMTLHousehold.h"

@interface SHMIDMTLDeviceDiscovery : MTLModel <MTLJSONSerializing>

@property (readonly, nonatomic, readonly) SHMIDMTLHousehold *household;
@property (readonly, nonatomic, readonly) NSArray *targetCastDevices;
@property (readonly, assign) unsigned long long timestamp;

@property (readonly, nonatomic, assign, getter = hasValidJson) BOOL validJson;

- (instancetype)initWithDiscoveredCastDevices:(NSArray *)devices;
- (BOOL)isDuplicateOfPreviousSyncedEvent;
@end
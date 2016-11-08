//
//  SHMIDMTLDeviceDiscovery.m
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 7/26/16.
//
//

#import "SHMIDMTLDeviceDiscovery.h"
#import "SHMIDMTLTargetCastDevice.h"
#import "SDConnectableDevice.h"
#import "SHMIDUtilities.h"
#import "SHMIDRLMDeviceGraphEvent.h"

@implementation SHMIDMTLDeviceDiscovery

#pragma mark - Mantle JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"timestamp": @"timestamp", @"household": @"hh", @"targetCastDevices": @"tcds"};
}

#pragma mark - JSON Transformers

+ (NSValueTransformer *)targetCastDevicesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:SHMIDMTLTargetCastDevice.class];
}

+ (NSValueTransformer *)householdJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:SHMIDMTLHousehold.class];
}

#pragma mark - Initializer

- (instancetype)initWithDiscoveredCastDevices:(NSArray *)devices {
    self = [super init];
    if (self) {
        _timestamp = [SHMIDUtilities currentTimeInMilliseconds];
        _household = [[SHMIDMTLHousehold alloc] initCurrentHousehold];
        NSMutableArray *targets = [[NSMutableArray alloc] initWithCapacity:devices.count];
        for (SDConnectableDevice *device in devices) {
            SHMIDMTLTargetCastDevice *target = [[SHMIDMTLTargetCastDevice alloc] initWithConnectableDevice:device];
            if (target && target.hasValidJson) {
                [targets addObject:target];
            }
        }
        _targetCastDevices = [[NSArray alloc] initWithArray:targets];
        targets = nil;
    }
    return self;
}

#pragma mark - Validation

- (BOOL)hasValidJson {
    if (![self.household hasValidJson]) {
        return NO;
    }
    return YES;
}

- (BOOL)isDuplicateOfPreviousSyncedEvent {
    NSError *error = nil;
    NSMutableDictionary *newDeviceDiscoveryJson =
    [[NSMutableDictionary alloc] initWithDictionary:[MTLJSONAdapter JSONDictionaryFromModel:self error:&error]];
    [newDeviceDiscoveryJson removeObjectForKey:@"timestamp"];
    if (error) {return NO;}
    NSMutableDictionary *prevDeviceDiscoveryJson =
    [[NSMutableDictionary alloc] initWithDictionary:[SHMIDRLMDeviceGraphEvent lastSyncedEventAsDictionary]];
    [prevDeviceDiscoveryJson removeObjectForKey:@"timestamp"];
    if ([newDeviceDiscoveryJson isEqualToDictionary:prevDeviceDiscoveryJson]) {
        NSLog(@"%s - FOUND DUPLICATE (SKIPPING EVENT)", __PRETTY_FUNCTION__);
        return YES;
    }
    return NO;
}
@end

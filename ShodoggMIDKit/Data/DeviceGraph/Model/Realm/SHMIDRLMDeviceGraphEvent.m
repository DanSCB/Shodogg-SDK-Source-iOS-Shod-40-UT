//
//  SHMIDRLMDeviceGraphEvent.m
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 8/2/16.
//
//

#import "SHMIDRLMDeviceGraphEvent.h"
#import "SHMIDRealmManager.h"

@implementation SHMIDRLMDeviceGraphEvent

#pragma mark - Realm

- (void)save {
    [super save];
    if (!self.data) {
        return;
    }
    NSLog(@"%s - A new device graph event recorded.", __PRETTY_FUNCTION__);
    [[SHMIDRealmManager defaultManager] addOrUpdateObject:self];
}

#pragma mark - Queries

+ (SHMIDRLMDeviceGraphEvent *)lastSyncedEvent {
    RLMResults<SHMIDRLMDeviceGraphEvent *> *events
    = [[SHMIDRLMDeviceGraphEvent allObjects] sortedResultsUsingProperty:@"timestamp" ascending:NO];
    if (events.count > 0) {
        return [events firstObject];
    }
    return nil;
}

+ (NSDictionary *)lastSyncedEventAsDictionary {
    NSDictionary *asDictionary = @{};
    SHMIDRLMDeviceGraphEvent *lastSyncedEvent = [SHMIDRLMDeviceGraphEvent lastSyncedEvent];
    if (lastSyncedEvent.data) {
        asDictionary = [NSJSONSerialization JSONObjectWithData:lastSyncedEvent.data options:kNilOptions error:nil];
    }
    return asDictionary;
}

+ (SHMIDMTLDeviceDiscovery *)lastSyncedEventAsMTLModel {
    return [MTLJSONAdapter modelOfClass:SHMIDMTLDeviceDiscovery.class
                     fromJSONDictionary:[[self class] lastSyncedEventAsDictionary]
                                  error:nil];
}

@end
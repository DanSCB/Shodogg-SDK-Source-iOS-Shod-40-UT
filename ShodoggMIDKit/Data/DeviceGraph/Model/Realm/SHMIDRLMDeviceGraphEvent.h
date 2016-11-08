//
//  SHMIDRLMDeviceGraphEvent.h
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 8/2/16.
//
//

#import "SHMIDMTLDeviceDiscovery.h"
#import "SHMIDRLMBaseEvent.h"
#import "SHMIDMTLDeviceDiscovery.h"

@interface SHMIDRLMDeviceGraphEvent : SHMIDRLMBaseEvent

+ (SHMIDRLMDeviceGraphEvent *)lastSyncedEvent;
+ (NSDictionary *)lastSyncedEventAsDictionary;
+ (SHMIDMTLDeviceDiscovery *)lastSyncedEventAsMTLModel;

@end
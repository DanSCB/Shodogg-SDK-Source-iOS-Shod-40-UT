//
//  SHMIDClient+DataRecorder.m
//  Pods
//
//  Created by Aamir Khan on 12/9/15.
//
//

#import "SHMIDClient+DataRecorder.h"
#import "SHMIDDataRecorder.h"
#import "SHMIDRealmManager.h"

#import "SHMIDRLMDeviceGraphEvent.h"

@implementation SHMIDClient (DataRecorder)

#pragma mark - Content Consumption

- (void)saveDTContentRequested:(SHMIDMTLDataTrackingEventMetadata *)metadata completionBlock:(SHMIDDataCompletionBlock)block {
    metadata.eventType = SHMIDDataTrackEventTypeContentRequested;
    [self saveDTEventWithMetadata:metadata completionBlock:block];
}

- (void)saveDTContentEvent:(SHMIDMTLDataTrackingEventMetadata *)metadata completionBlock:(SHMIDDataCompletionBlock)block {
    if (!metadata.eventType) {
        NSString *description = @"The event type is a required field on the SHMIDEventMetadata object.";
        NSError *error = [NSError errorWithLocalizedDescription:description];
        block(nil, error);
        return;
    }
    [self saveDTEventWithMetadata:metadata completionBlock:block];
}

- (void)saveDTEventWithMetadata:(SHMIDMTLDataTrackingEventMetadata *)metadata completionBlock:(SHMIDDataCompletionBlock)block {
    if (!metadata.valid) {
        if (block) {block(nil, [metadata error]);}
        return;
    }
    [metadata save];
}

#pragma mark - Casting

- (void)saveDTCastingDeviceConnectedEventWithMetadata:(SHMIDMTLDataTrackingEventMetadata *)metadata {
    [self saveDTCastingEventWithMetadata:metadata eventType:SHMIDDataTrackEventTypeCastingConnectDevice];
}

- (void)saveDTCastingDeviceDisconnectedEventWithMetadata:(SHMIDMTLDataTrackingEventMetadata *)metadata {
    [self saveDTCastingEventWithMetadata:metadata eventType:SHMIDDataTrackEventTypeCastingDisconnectDevice];
}

- (void)saveDTCastingEventWithMetadata:(SHMIDMTLDataTrackingEventMetadata *)metadata eventType:(SHMIDDataTrackEventType)eventType {
    metadata.eventType = eventType;
    [self saveDTEventWithMetadata:metadata completionBlock:nil];
}

#pragma mark - 

- (void)submitDataTrackingEvents {
    [[SHMIDRealmManager defaultManager] submitDataTrackingEvents];
}

#pragma mark - Device Graph

- (void)saveDGEventWithMetadata:(SHMIDMTLDeviceDiscovery *)metadata {
    if (metadata.validJson && ![metadata isDuplicateOfPreviousSyncedEvent]) {
        [[[SHMIDRLMDeviceGraphEvent alloc] initWithMTLModelObject:metadata] save];
    }
}

- (void)submitDeviceGraphEvents {
    [[SHMIDRealmManager defaultManager] submitDeviceGraphEvents];
}
@end
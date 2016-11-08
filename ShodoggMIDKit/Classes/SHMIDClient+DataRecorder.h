//
//  SHMIDClient+DataRecorder.h
//  Pods
//
//  Created by Aamir Khan on 12/9/15.
//
//

#import <ShodoggMIDKit/ShodoggMIDKit.h>
#import "SHMIDMTLDeviceDiscovery.h"

@interface SHMIDClient (DataRecorder)

- (void)saveDTContentRequested:(SHMIDMTLDataTrackingEventMetadata *)metadata completionBlock:(SHMIDDataCompletionBlock)block;
- (void)saveDTContentEvent:(SHMIDMTLDataTrackingEventMetadata *)metadata completionBlock:(SHMIDDataCompletionBlock)block;
- (void)saveDTCastingDeviceConnectedEventWithMetadata:(SHMIDMTLDataTrackingEventMetadata *)metadata;
- (void)saveDTCastingDeviceDisconnectedEventWithMetadata:(SHMIDMTLDataTrackingEventMetadata *)metadata;
- (void)submitDataTrackingEvents;

- (void)saveDGEventWithMetadata:(SHMIDMTLDeviceDiscovery *)metadata;
- (void)submitDeviceGraphEvents;

@end
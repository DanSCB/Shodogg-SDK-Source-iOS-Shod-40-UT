//
//  SHMIDClient+DataTracking.h
//  Pods
//
//  Created by Aamir Khan on 11/12/15.
//  Copyright © 2015 Shodogg. All rights reserved.
//

#import "SHMIDClient.h"
#import "SHMIDMTLDataTrackingEventMetadata.h"

typedef void(^SHMIDDataCompletionBlock)(id data, NSError *error);

@interface SHMIDClient (DataTracking)

- (void)logInitialStateWithCompletionBlock:(SHMIDDataCompletionBlock)block;
- (void)logContentRequested:(SHMIDMTLDataTrackingEventMetadata *)metadata completionBlock:(SHMIDDataCompletionBlock)block;
- (void)logAdEvent:(SHMIDMTLDataTrackingEventMetadata *)metadata completionBlock:(SHMIDDataCompletionBlock)block;
- (void)logContentEvent:(SHMIDMTLDataTrackingEventMetadata *)metadata completionBlock:(SHMIDDataCompletionBlock)block;
- (void)logCastingDeviceConnectedEventWithMetadata:(SHMIDMTLDataTrackingEventMetadata *)metadata completionBlock:(SHMIDDataCompletionBlock)block;
- (void)logCastingDeviceDisconnectedEventWithMetadata:(SHMIDMTLDataTrackingEventMetadata *)metadata completionBlock:(SHMIDDataCompletionBlock)block;

- (void)postDataTrackingEvents:(NSArray *)events completionBlock:(SHMIDDataCompletionBlock)block;
- (void)postDeviceGraphEvents:(NSArray *)events completionBlock:(SHMIDDataCompletionBlock)block;
@end

//
//  SHMIDClient+DataTracking.m
//  Pods
//
//  Created by Aamir Khan on 11/12/15.
//  Copyright © 2015 Shodogg. All rights reserved.
//

#import "SHMIDClient+DataTracking.h"
#import "SHMIDDataRecorder.h"
#import <Mantle/Mantle.h>

@implementation SHMIDClient (DataTracking)

#pragma mark - Content Consumption

- (void)logInitialStateWithCompletionBlock:(void(^)(id data, NSError *error))block {
    SHMIDMTLDataTrackingEventMetadata *metadata = [[SHMIDMTLDataTrackingEventMetadata alloc] init];
    [self logEventWithMetadata:metadata completionBlock:block];
}

- (void)logContentRequested:(SHMIDMTLDataTrackingEventMetadata *)metadata completionBlock:(SHMIDDataCompletionBlock)block {
    metadata.eventType = SHEventTypeContentRequested;
    [self logEventWithMetadata:metadata completionBlock:block];
}

- (void)logAdEvent:(SHMIDMTLDataTrackingEventMetadata *)metadata completionBlock:(SHMIDDataCompletionBlock)block {
    if (!metadata.eventType) {
        NSString *description = @"The event type is a required field on the SHMIDEventMetadata object.";
        NSError *error = [NSError errorWithLocalizedDescription:description];
        block(nil, error);
        return;
    }
    [self logEventWithMetadata:metadata completionBlock:block];
}

- (void)logContentEvent:(SHMIDMTLDataTrackingEventMetadata *)metadata completionBlock:(SHMIDDataCompletionBlock)block {
    if (!metadata.eventType) {
        NSString *description = @"The event type is a required field on the SHMIDEventMetadata object.";
        NSError *error = [NSError errorWithLocalizedDescription:description];
        block(nil, error);
        return;
    }
    [self logEventWithMetadata:metadata completionBlock:block];
}

#pragma mark - Casting

- (void)logCastingDeviceDisconnectedEventWithMetadata:(SHMIDMTLDataTrackingEventMetadata *)metadata completionBlock:(SHMIDDataCompletionBlock)block {
    [self logCastingEventWithMetadata:metadata eventType:SHMIDDataTrackEventTypeCastingDisconnectDevice completionBlock:block];
}

- (void)logCastingDeviceConnectedEventWithMetadata:(SHMIDMTLDataTrackingEventMetadata *)metadata completionBlock:(SHMIDDataCompletionBlock)block {
    [self logCastingEventWithMetadata:metadata eventType:SHMIDDataTrackEventTypeCastingConnectDevice completionBlock:block];
}

- (void)logCastingEventWithMetadata:(SHMIDMTLDataTrackingEventMetadata *)metadata eventType:(SHMIDDataTrackEventType)eventType completionBlock:(SHMIDDataCompletionBlock)block {
    metadata.eventType = eventType;
    [self logEventWithMetadata:metadata completionBlock:block];
}

#pragma mark - API

- (void)logEventWithMetadata:(SHMIDMTLDataTrackingEventMetadata *)metadata completionBlock:(SHMIDDataCompletionBlock)block {
    if (!metadata.valid) {
        if (block) {
            block(nil, [metadata error]);
        }
        return;
    }
    NSError *error;
    NSDictionary *toDictionary = [MTLJSONAdapter JSONDictionaryFromModel:metadata error:&error];
    if (error) {
        if (block) {
            block(nil, error);
        }
        return;
    }
    [self postDataTrackingEvents:@[toDictionary] completionBlock:block];
}

#pragma mark - Data Tracking

- (void)postDataTrackingEvents:(NSArray *)events completionBlock:(SHMIDDataCompletionBlock)block {
    NSData *eventData = [self dataWithJSONObject:events];
    if (eventData == nil) {
        return;
    }
    NSString *pathComponent = @"/api/mid/track";
    [[SHUbeAPIClient sharedClient]
        dataTaskPOST:pathComponent
                data:eventData
     completionBlock:^(NSURLResponse *response, id responseObject, NSError *error) {
         NSLog(@"%s {\n\tResponse:%@\n\tError:%@\n}", __PRETTY_FUNCTION__,
               [responseObject description], [error getFailureMessageInResponseData]);
         if (block) block(responseObject, error);
     }];
}

#pragma mark - Device Graph

- (void)postDeviceGraphEvents:(NSArray *)events completionBlock:(SHMIDDataCompletionBlock)block {
    NSData *deviceData = [self dataWithJSONObject:events];
    if (deviceData == nil) {
        return;
    }
    [[SHUbeAPIClient sharedClient]
        dgPOSTDataTaskWithRequestURL:[self dgTrackingURL]
            unauthorizedSessionToken:[self umsCookieValue]
                      dataInHttpBody:deviceData
                     completionBlock:^(NSURLResponse *response, id responseObject, NSError *error) {
                         NSLog(@"%s {\n\tResponse:%@\n\tError:%@\n}", __PRETTY_FUNCTION__,
                               [responseObject description], [error getFailureMessageInResponseData]);
                         if (block) block(responseObject, error);
                     }];
}

#pragma mark - Convenience 

- (NSData *)dataWithJSONObject:(NSArray *)json {
    NSError *error = nil;
    NSData *toJSONSerializedData = nil;
    toJSONSerializedData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"%s - ", __PRETTY_FUNCTION__);
    }
    return toJSONSerializedData;
}
@end
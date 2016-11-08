//
//  SHMIDMTLDataTrackingEventMetadata.m
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 8/31/16.
//
//

#import "SHMIDMTLDataTrackingEventMetadata.h"
#import "SHMIDRLMDataTrackingEvent.h"
#import "SHMIDRealmManager.h"
#import "SHMIDUtilities.h"
#import "SHMIDClient.h"

NSString *const SHMIDDataTrackingErrorDomain = @"com.shodogg.datatracking";

@interface SHMIDMTLDataTrackingEventMetadata()
@end

@implementation SHMIDMTLDataTrackingEventMetadata

#pragma mark - Mantle

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"mID" : @"mid",
             @"mcoID" : @"mcoId",
             @"mcoAppID" : @"mcoAppId",
             @"mcoAppPublicKey" : @"mcoAppPublicKey",
             @"assetID" : @"assetId",
             @"mcoAssetID" : @"mcoAssetId",
             @"eventValue": @"eventValue",
             @"eventValueOld": @"eventValueOld",
             @"label": @"label",
             @"sessionToken" : @"sessionToken",
             @"eventType": @"eventType",
             @"timestampUTC": @"timestampUTC",
             @"casting": @"cs"};
}

+ (NSValueTransformer *)eventTypeJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
       @"cn_requested"          : @(SHMIDDataTrackEventTypeContentRequested),
       @"cn_play"               : @(SHMIDDataTrackEventTypeContentPlay),
       @"cn_pause"              : @(SHMIDDataTrackEventTypeContentPause),
       @"cn_seek"               : @(SHMIDDataTrackEventTypeContentSeek),
       @"cn_volume"             : @(SHMIDDataTrackEventTypeContentVolume),
       @"cn_ended"              : @(SHMIDDataTrackEventTypeContentEnded),
       @"cn_stopped"            : @(SHMIDDataTrackEventTypeContentStopped),
       @"cn_buffer_start"       : @(SHMIDDataTrackEventTypeContentBufferStart),
       @"cn_buffer_end"         : @(SHMIDDataTrackEventTypeContentBufferEnd),
       @"cs_connect_to_device"  : @(SHMIDDataTrackEventTypeCastingConnectDevice),
       @"cs_disconnect_device"  : @(SHMIDDataTrackEventTypeCastingDisconnectDevice)
    }];
}

#pragma mark - Initializer

- (instancetype)init {
    self = [super init];
    if (self) {
        _mID             = [[SHMIDClient sharedClient] getMID];
        _mcoID           = [[SHMIDClient sharedClient] getMCOID];
        _mcoAppID        = [[SHMIDClient sharedClient] getMCOAppID];
        _mcoAppPublicKey = [[SHMIDClient sharedClient] getMCOAppPublicKey];
        _sessionToken    = [[SHMIDClient sharedClient] getMIDSessionToken];
        _timestampUTC    = [SHMIDUtilities currentTimeInMilliseconds];
    }
    return self;
}

- (instancetype)initWithTargetCastDeviceMetadata:(SHMIDMTLTargetCastDevice *)tcdMetadata {
    self = [self init];
    if (self) {
        NSDictionary *tcdMetaDictionary = [MTLJSONAdapter JSONDictionaryFromModel:tcdMetadata error:nil];
        _casting = @{@"tcd_id": @"", @"tcd_state" : @"", @"attrs": @{@"tcd": tcdMetaDictionary}};
    }
    return self;
}

#pragma mark - Validation

- (BOOL)isValid {
    if (!self.timestampUTC) {
        self.timestampUTC = [SHMIDUtilities currentTimeInMilliseconds];
    }
    BOOL result = !self.mcoID || !self.mcoAppID || !self.mcoAppPublicKey;
    return !result;
}

- (NSString *)failureMessage {
    NSString *message;
    if (!self.mcoID) {
        message = @"The MCO ID is a required field on the SHMIDEventMetadata object.";
    }
    if (!self.mcoAppID) {
        message = @"The MCO App ID is a required field on the SHMIDEventMetadata object.";
    }
    if (!self.mcoAppPublicKey) {
        message = @"The public key is a required field on the SHMIDEventMetadata object.";
    }
    return message;
}

- (NSError *)error {
    if (!self.isValid) {
        return [NSError errorWithDomain:SHMIDDataTrackingErrorDomain
                   localizedDescription:[self failureMessage]
                          failureReason:nil
                     recoverySuggestion:nil];
    }
    return nil;
}

#pragma mark - Persistence

- (void)save {
    if (!self.valid) {
        return;
    }
    [[[SHMIDRLMDataTrackingEvent alloc] initWithMTLModelObject:self] save];
}

@end
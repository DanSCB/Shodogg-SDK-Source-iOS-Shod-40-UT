//
//  SHMIDMTLDataTrackingEventMetadata.h
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 8/31/16.
//
//

#import <Mantle/Mantle.h>
#import "SHMIDMTLTargetCastDevice.h"

typedef NS_ENUM(NSUInteger, SHMIDDataTrackEventType) {
    SHMIDDataTrackEventTypeContentRequested,
    SHMIDDataTrackEventTypeContentPlay,
    SHMIDDataTrackEventTypeContentPause,
    SHMIDDataTrackEventTypeContentSeek,
    SHMIDDataTrackEventTypeContentVolume,
    SHMIDDataTrackEventTypeContentEnded,
    SHMIDDataTrackEventTypeContentStopped,
    SHMIDDataTrackEventTypeContentBufferStart,
    SHMIDDataTrackEventTypeContentBufferEnd,
    SHMIDDataTrackEventTypeCastingConnectDevice,
    SHMIDDataTrackEventTypeCastingDisconnectDevice
};

@interface SHMIDMTLDataTrackingEventMetadata : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *mID;
@property (nonatomic, copy, readonly) NSString *mcoID;
@property (nonatomic, copy, readonly) NSString *mcoAppID;
@property (nonatomic, copy, readonly) NSString *mcoAppPublicKey;
@property (nonatomic,           copy) NSString *assetID;
@property (nonatomic,           copy) NSString *mcoAssetID;
@property (nonatomic,           copy) NSString *eventValue;
@property (nonatomic,           copy) NSString *eventValueOld;
@property (nonatomic,           copy) NSString *label;
@property (nonatomic,           copy) NSString *sessionToken;
@property (nonatomic,         assign) SHMIDDataTrackEventType eventType;
@property (nonatomic,         assign) unsigned long long timestampUTC;
@property (nonatomic,strong,readonly) NSDictionary *casting;

@property (readonly, nonatomic, assign, getter = isValid) BOOL valid;

- (instancetype)initWithTargetCastDeviceMetadata:(SHMIDMTLTargetCastDevice *)tcdMetadata;
- (NSString *)failureMessage;
- (NSError *)error;
- (void)save;
@end
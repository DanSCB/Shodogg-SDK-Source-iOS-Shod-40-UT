//
//  SHMIDEventMetadata.h
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 11/11/15.
//  Copyright © 2015 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kSHEventTypeAllNames @[@"unknown", @"cn_requested", @"cn_play", @"cn_pause", @"cn_seek", @"cn_volume", @"cn_ended", @"cn_stopped", @"cn_buffer_start", @"cn_buffer_end"]

typedef NS_ENUM(NSInteger, SHEventType) {
    SHEventTypeUnknown,
    SHEventTypeContentRequested,
    SHEventTypeContentPlay,
    SHEventTypeContentPause,
    SHEventTypeContentSeek,
    SHEventTypeContentVolume,
    SHEventTypeContentEnded,
    SHEventTypeContentStopped,
    SHEventTypeContentBufferStart,
    SHEventTypeContentBufferEnd
};

NSString *SHEventTypeAsString(SHEventType type);

@interface SHMIDEventMetadata : NSObject

@property (nonatomic, readonly) NSString *mid;
@property (nonatomic, readonly) NSString *mcoId;
@property (nonatomic, readonly) NSString *mcoAppId;
@property (nonatomic, readonly) NSString *mcoAppPublicKey;
@property (nonatomic,     copy) NSString *assetId;
@property (nonatomic,     copy) NSString *mcoAssetId;
@property (nonatomic,     copy) NSString *eventValue;
@property (nonatomic,     copy) NSString *eventValueOld;
@property (nonatomic,     copy) NSString *label;
@property (nonatomic,     copy) NSString *sessionToken;
@property (assign) SHEventType eventType;
@property (assign) unsigned long long timestampUTC;

- (NSDictionary *)toDictionary;
- (BOOL)isValid;
- (NSString *)failureMessage;
- (NSError *)error;
@end

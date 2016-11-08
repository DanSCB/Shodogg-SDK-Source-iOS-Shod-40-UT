//
//  SHMIDScreen.h
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 5/13/16.
//
//

#import <Foundation/Foundation.h>
#import "SHMIDMediaItem.h"

extern NSString* const kMIDScreenPlaybackChangedNotification;
extern NSString* const kMIDScreenDisconnectedNotification;

extern NSString* const kMIDCastingBeganNotification;
extern NSString* const kMIDCastingEndedNotification;

typedef NS_ENUM(NSInteger, SHMIDScreenState) {
    SHMIDScreenStateUnknown = 0,
    SHMIDScreenStateSynced = 1
};

@class SHMIDScreen;

@protocol SHMIDScreenDelegate <NSObject>

- (void)screen:(SHMIDScreen *)screen didChangeState:(SHMIDScreenState)state;
- (void)screen:(SHMIDScreen *)screen didChangePlayback:(SHMIDMediaItemPlayback)playback;

@end

@interface SHMIDScreen : NSObject

@property (weak) id <SHMIDScreenDelegate> delegate;

@property (nonatomic, readonly) SHScreenSesssion *castingSession;

@property (nonatomic, readonly) NSURL *castingURL;

@property (nonatomic, readonly) SHMIDScreenState state;

@property (nonatomic, strong) SHMIDMediaItem *nowPlaying;

+ (instancetype)sharedScreen;
+ (void)setSharedScreen:(SHMIDScreen *)screen;
- (void)requestPreSyncedScreenUrl;
- (void)disconnect;
- (void)play;
- (void)pause;
- (void)adjustVolumeLevel:(NSInteger)level;
- (void)seekToSeconds:(NSNumber *)seconds;
- (void)seekBySeconds:(NSNumber *)seconds;
@end
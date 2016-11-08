//
//  SHMIDScreen.m
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 5/13/16.
//
//

#import "SHMIDScreen.h"
#import "SHMIDCastController.h"
#import "SHMIDClient.h"

NSString* const kMIDScreenPlaybackChangedNotification   = @"MIDScreenPlaybackChangedNotificationKey";
NSString* const kMIDScreenDisconnectedNotification      = @"MIDScreenDisconnectedNotificationKey";
NSString* const kMIDCastingBeganNotification            = @"MIDCastingBeganNotificationKey";
NSString* const kMIDCastingEndedNotification            = @"MIDCastingEndedNotificationKey";

@interface SHMIDScreen()
@property (nonatomic, strong, readwrite) NSURL *castingURL;
@property (nonatomic, strong, readwrite) SHScreenSesssion *castingSession;
@property (nonatomic, readwrite) SHMIDScreenState state;
@end

static SHMIDScreen *_sharedScreen = nil;

@implementation SHMIDScreen

+ (instancetype)sharedScreen {
    return _sharedScreen;
}

+ (void)setSharedScreen:(SHMIDScreen *)screen {
    if (screen == _sharedScreen) return;
    _sharedScreen = nil;
    _sharedScreen = screen;
}

- (instancetype)init {
    if (self = [super init]) {
        _castingURL = nil;
        _nowPlaying = nil;
        _state = SHMIDScreenStateUnknown;
    }
    return self;
}

- (void)setCastingURL:(NSURL *)castingURL {
    if (_castingURL == castingURL) {
        return;
    }
    _castingURL = castingURL;
    _state = SHMIDScreenStateSynced;
}

- (SHMIDMediaItem *)currentMediaItem {
    return [[SHMIDCastController sharedInstance] contextItem];
}

#pragma mark - Screen Connection

- (void)requestPreSyncedScreenUrl {
    if ([SHScreenSesssion getCurrentScreenSessionId].length) {
        [self getCurrentPreSyncedScreenUrl];
    } else {
        [self requestNewPreSyncedScreenUrl];
    }
}

- (void)getCurrentPreSyncedScreenUrl {
    __weak typeof(self) wself = self;
    SHMIDClient *client = [SHMIDClient sharedClient];
    NSArray *mid = [client getMID];
    NSString *ustId = [client getPreviousUSTId];
    typedef void (^ScreenURLBlock)(NSURL *screenUrl, NSError *error);
    ScreenURLBlock screenUrlBlock = ^(NSURL *screenUrl, NSError *error) {
        if (screenUrl) {
            [wself setCastingURL:screenUrl];
            if ([wself.delegate respondsToSelector:@selector(screen:didChangeState:)]) {
                [wself.delegate screen:wself didChangeState:SHMIDScreenStateSynced];
            }
        } else if (error) {
            NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
            if (response.statusCode == 403) {
                NSLog(@"%s ##### Looks like the last screen session expired, UBE returned error with MESSAGE #=> %@ <=#",
                      __PRETTY_FUNCTION__, [error getFailureMessageInResponseData]);
                NSLog(@"%s ##### Attempting start a new screen session ...", __PRETTY_FUNCTION__);
                [wself requestNewPreSyncedScreenUrl];
            }
        } else {
            [wself requestNewPreSyncedScreenUrl];
        }
    };
    if ([client canResumeSession]) {
        NSLog(@"%s ##### Checking if screen session exists for userId #=> %@ <=#", __PRETTY_FUNCTION__, mid);
        [SHScreen checkScreenSessionExitsForMID:mid withCompletionBlock:screenUrlBlock];
    } else {
        NSLog(@"%s ##### Checking if screen session exists for ustId #=> %@ <=#", __PRETTY_FUNCTION__, ustId);
        [SHScreen checkScreenSessionExistsForUSTId:ustId withCompletionBlock:screenUrlBlock];
    }
}

- (void)requestNewPreSyncedScreenUrl {
    __weak typeof(self) weakself = self;
    __weak SHMIDClient *wClient = [SHMIDClient sharedClient];
    [SHScreen getPresyncedScreenUrlWithCompletionBlock:^(NSDictionary *result, NSError *error) {
        NSLog(@"%s - Result: \n%@, \nError: %@", __PRETTY_FUNCTION__, result, error);
        if (!error) {
            [weakself setCastingURL:[NSURL URLWithString:result[@"screenUrl"]]];
            if ([weakself.delegate respondsToSelector:@selector(screen:didChangeState:)]) {
                [weakself.delegate screen:weakself didChangeState:SHMIDScreenStateSynced];
            }
        }
    }];
}

- (void)disconnect {
    __weak typeof(self) weakself = self;
    [SHScreen disconnectWithCompletionBlock:^(NSError *error) {
        _state = SHMIDScreenStateUnknown;
        _castingURL = nil;
        _nowPlaying = nil;
        [[SHMIDClient sharedClient] removePreviousUSTId];
        if ([weakself.delegate respondsToSelector:@selector(screen:didChangeState:)]) {
            [weakself.delegate screen:weakself didChangeState:SHMIDScreenStateUnknown];
        }
    }];
}

#pragma mark - Screen Commands

- (void)play {
    if (!self.nowPlaying) {
        return;
    }
    __weak typeof(self) weakself = self;
    [SHScreen videoCommandPlayWithURL:_nowPlaying.url completionBlock:^(BOOL success, NSError *error) {
        if ([weakself.delegate respondsToSelector:@selector(screen:didChangePlayback:)]) {
            _nowPlaying.playback = SHMIDMediaItemPlaying;
            [weakself.delegate screen:weakself didChangePlayback:SHMIDMediaItemPlaying];
        }
    }];
}

- (void)pause {
    if (!self.nowPlaying) {
        return;
    }
    __weak typeof(self) weakself = self;
    [SHScreen videoCommandPauseWithURL:_nowPlaying.url completionBlock:^(BOOL success, NSError *error) {
        if ([weakself.delegate respondsToSelector:@selector(screen:didChangePlayback:)]) {
            _nowPlaying.playback = SHMIDMediaItemPaused;
            [weakself.delegate screen:weakself didChangePlayback:SHMIDMediaItemPaused];
        }
    }];
}

- (void)adjustVolumeLevel:(NSInteger)level {
    if (!self.nowPlaying) {
        return;
    }
    [SHScreen videoCommandVolumeWithURL:_nowPlaying.url volume:level completionBlock:nil];
}

- (void)seekToSeconds:(NSNumber *)seconds {
    if (!self.nowPlaying) {
        return;
    }
    [SHScreen videoCommandSeekWithURL:_nowPlaying.url seekToSeconds:seconds completionBlock:nil];
}

- (void)seekBySeconds:(NSNumber *)seconds {
    if (!self.nowPlaying) {
        return;
    }
    [SHScreen videoCommandSeekWithURL:_nowPlaying.url seekBySeconds:seconds completionBlock:nil];
}

@end
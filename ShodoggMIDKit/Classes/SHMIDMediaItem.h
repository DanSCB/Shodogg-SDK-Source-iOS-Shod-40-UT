//
//  SHMIDMediaItem.h
//  Pods
//
//  Created by Aamir Khan on 2/10/16.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SHMIDMediaItemPlayback) {
    SHMIDMediaItemPlaybackUnknown = 0,
    SHMIDMediaItemPlaying = 1,
    SHMIDMediaItemPaused = 2,
    SHMIDMediaItemBuffering = 3,
};

@interface SHMIDMediaItem : NSObject

@property (nonatomic, copy) NSString *itemID;

@property (nonatomic, copy) NSString *mcoAssetID;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *show;

@property (nonatomic, copy) NSString *publisher;

@property (nonatomic, strong) NSString *thumbnailURL;

@property (nonatomic, strong) NSString *posterURL;

@property (nonatomic, strong) NSString *url;

@property (nonatomic) NSTimeInterval duration;

@property (nonatomic) SHMIDMediaItemPlayback playback;

@end
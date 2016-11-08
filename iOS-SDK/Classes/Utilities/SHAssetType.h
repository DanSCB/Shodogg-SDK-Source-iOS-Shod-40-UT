//
//  SHAssetType.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 9/16/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>

// ASSET TYPES
#define kSHAssetTypeAllNames @[@"UNKNOWN", @"IMAGE", @"VIDEO", @"AUDIO", @"CROCODOC", @"BOX", @"SLIDESHOW", @"WEB_PAGE", @"LINK", @"OEMBED"]

typedef NS_ENUM(NSInteger, SHAssetType) {
    SHAssetTypeUnknown,
    SHAssetTypeImage,
    SHAssetTypeVideo,
    SHAssetTypeAudio,
    SHAssetTypeCrocodoc,
    SHAssetTypeBox,
    SHAssetTypeSlideshow,
    SHAssetTypeWebpage,
    SHAssetTypeLink,
    SHAssetTypeOEmbed
};

NSArray *SHAssetTypeAllNames();
NSDictionary *SHAssetAllTypeNamesAsDictionary();
SHAssetType SHAssetTypeFromString(NSString *type);
NSString *SHAssetTypeAsString(SHAssetType assetType);
BOOL SHAssetTypeIsStringValid(NSString *type);

// FILE TYPES
#define kSHFileTypeAllNames @[@"UNKNOWN", @"PDF", @"PPT", @"PPTX", @"DOC", @"DOCX", @"XLS", @"XLSX", @"YOUTUBE", @"MP4", @"MP3", @"COMMS_FACTORY", @"JPEG", @"JPG", @"PNG", @"GIF", @"SVG", @"WEBLINK"]

typedef NS_ENUM(NSInteger, SHFileType){
    SHFileTypeUnknown,
    SHFileTypePDF,
    SHFileTypePPT,
    SHFileTypePPTX,
    SHFileTypeDOC,
    SHFileTypeDOCX,
    SHFileTypeXLS,
    SHFileTypeXLSX,
    SHFileTypeYouTube,
    SHFileTypeMP4,
    SHFileTypeMP3,
    SHFileTypeCF,
    SHFileTypeJPEG,
    SHFileTypeJPG,
    SHFileTypePNG,
    SHFileTypeGIF,
    SHFileTypeSVG,
    SHFileTypeWebLink
};

NSArray *SHFileTypeAllNames();
SHFileType SHFileTypeFromString(NSString *type);
NSString *SHFileTypeAsString(SHFileType fileType);
BOOL SHFileTypeIsStringValid(NSString *type);

// ASSET STATUS
#define kSHAssetStatusAllNames @[@"UNKNOWN", @"QUEUED", @"CONVERTING", @"COMPLETE", @"ERROR"]

typedef NS_ENUM(NSInteger, SHAssetStatus) {
    SHAssetStatusUnknown,
    SHAssetStatusQueued,
    SHAssetStatusConversionInProgress,
    SHAssetStatusConversionCompleted,
    SHAssetStatusError
};

NSArray *SHAssetStatusAllNames();
SHAssetStatus SHAssetStatusFromString(NSString *status);
NSString *SHAssetStatusAsString(SHAssetStatus assetStatus);
BOOL SHAssetStatusIsStringValid(NSString *status);

// ASSET STATES
#define kSHAssetStateAllNames @[@"UNKNOWN", @"PLAY", @"PAUSE", @"SEEK", @"VOLUME", @"BUFFERING", @"LOADING", @"VIEWING", @"CONVERTING", @"STARTED", @"STOPPED"]

typedef NS_ENUM(NSInteger, SHAssetState) {
    SHAssetStateUnknown,
    SHAssetStatePlay,
    SHAssetStatePause,
    SHAssetStateSeek,
    SHAssetStateVolume,
    SHAssetStateBuffering,
    SHAssetStateLoading,
    SHAssetStateViewing,
    SHAssetStateConvertwing,
    SHAssetStateStarted,
    SHAssetStateStopped
};

NSArray *SHAssetStateAllNames();
SHAssetState SHAssetStateFromString(NSString *name);
NSString *SHAssetStateAsString(SHAssetState assetState);
BOOL SHAssetStateIsStringValid(NSString *state);
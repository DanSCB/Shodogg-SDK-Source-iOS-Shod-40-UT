//
//  SHYoutubeDTO.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 1/2/14.
//  Copyright (c) 2014 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHAssetType.h"
#import "SHAssetMinimalDTO.h"

@interface SHYoutubeDTO : NSObject
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *authorUri;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *ubeDescription;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *sThumbnailUrl; //90x120
@property (nonatomic, copy) NSString *lThumbnailUrl; //360x480
@property (nonatomic, copy) NSString *thumbnailUrl;
@property (nonatomic, retain) NSArray *assetIdArray;
@property (nonatomic, copy) NSString *viewCount;

@property (nonatomic, retain) SHAssetMinimalDTO *asset; //saves ref to asset object
@property (nonatomic, assign) SHAssetStatus status; //for local use - not returned by server

+ (SHYoutubeDTO *)fromJSON:(id)JSON;
@end
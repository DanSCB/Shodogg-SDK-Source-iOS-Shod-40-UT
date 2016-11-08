//
//  SHAssetMinimalDTO.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 9/24/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHAssetType.h"
#import "SHAssetRepoMetadata.h"

@interface SHAssetMinimalDTO : NSObject

@property (nonatomic,   copy) NSString              *ID;
@property (nonatomic,   copy) NSString              *userID;
@property (nonatomic,   copy) NSString              *displayName;
@property (nonatomic,   copy) NSString              *ubeDescription;
@property (nonatomic,   copy) NSString              *originalURL;
@property (nonatomic,   copy) NSString              *originalFilename;
@property (nonatomic,   copy) NSString              *thumbnailURL;
@property (nonatomic,   copy) NSString              *version;
@property (nonatomic, strong) NSDate                *createdAt;
@property (nonatomic, strong) NSDate                *updatedAt;
@property (nonatomic, assign) int                   pageCount;
@property (nonatomic, assign) int                   noteCount;
@property (nonatomic, assign) BOOL                  readOnly;
@property (nonatomic, assign) BOOL                  active;
@property (nonatomic, assign) SHAssetType           assetType;
@property (nonatomic, assign) SHFileType            fileType;
@property (nonatomic, retain) SHAssetRepoMetadata   *repoMetadata;
//Local use only
@property (nonatomic,   copy) NSString              *path;
@property (nonatomic,   copy) NSString              *iconImageName;
@property (nonatomic, assign) SHAssetStatus         status;
@property (nonatomic, strong) NSMutableDictionary   *attributes;

+ (SHAssetMinimalDTO *)fromJSON:(id)JSON;
+ (SHAssetMinimalDTO *)fromDictionary:(id)dictionary; //local use
@end
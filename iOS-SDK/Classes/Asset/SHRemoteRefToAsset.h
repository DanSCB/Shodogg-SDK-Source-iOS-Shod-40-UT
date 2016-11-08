//
//  SHRemoteRefToAsset.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 9/25/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import "SHAssetMinimalDTO.h"
#import "SHAssetRepoMetadata.h"

@interface SHRemoteRefToAsset : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *ubeDescription;
@property (nonatomic, copy) NSString *originalURL;
@property (nonatomic, copy) NSString *originalFilename;
@property (nonatomic, copy) NSString *thumbnailURL;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, assign) BOOL readOnly;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, assign) int pageCount;
@property (nonatomic, assign) int noteCount;
@property (nonatomic, assign) SHAssetType assetType;
@property (nonatomic, assign) SHFileType fileType;
@property (nonatomic, retain) NSMutableArray *eventIds;
@property (nonatomic, retain) NSMutableArray *groupIds;
@property (nonatomic, retain) NSMutableArray *folderIds;
@property (nonatomic, retain) NSMutableArray *pages;
@property (nonatomic, retain) NSMutableArray *smallThumbnailURLArray;
@property (nonatomic, retain) NSMutableArray *thumbnailURLArray;
@property (nonatomic, retain) NSMutableArray *hqThumbnailURLArray;
@property (nonatomic, retain) NSMutableArray *userNotes;
@property (nonatomic, retain) NSMutableArray *embeddedNotes;
@property (nonatomic, retain) SHAssetRepoMetadata *repoMetadata;
@property (nonatomic, retain) NSMutableDictionary *attributes;
@property (nonatomic, strong) NSMutableDictionary *augmentedPages;

//local use
@property (copy, nonatomic) NSString *path;
@property (copy, nonatomic) NSString *iconImageName;
@property (assign, nonatomic) SHAssetStatus status;
@property (assign, nonatomic) NSInteger rating; //1 to 5
@property (assign, nonatomic) BOOL liked; //true or flase
@property (assign, nonatomic) BOOL unliked;

+ (SHRemoteRefToAsset *)createFromJSON:(id)JSON;
+ (SHRemoteRefToAsset *)fromDictionary:(id)dictionary;
@end
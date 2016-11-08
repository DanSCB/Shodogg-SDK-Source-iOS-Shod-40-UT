//
//  SHDropboxEntryDTO.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 12/10/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHAssetType.h"

@interface SHDropboxEntryDTO : NSObject

@property (nonatomic, assign) BOOL isDIR;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *root;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *mimeType;
@property (nonatomic, copy) NSString *rev;
@property (nonatomic, assign) BOOL thumbExists;
@property (nonatomic, assign) BOOL isDeleted;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *assetId;
@property (copy, nonatomic) NSString *updatedAt;
@property (nonatomic, assign) SHAssetStatus status;
@property (nonatomic, copy) NSString *statusMessage;

@property (nonatomic, assign) SHFileType fileType;
@property (nonatomic, copy) NSString *iconImageName;

+ (SHDropboxEntryDTO *)fromJSON:(id)JSON;
@end
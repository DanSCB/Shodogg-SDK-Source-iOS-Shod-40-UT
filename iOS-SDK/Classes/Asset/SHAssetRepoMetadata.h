//
//  SHAssetRepoMetadata.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 9/16/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHAssetType.h"
#import "SHRepoUtilities.h"

@interface SHAssetRepoMetadata : NSObject

@property (nonatomic,   copy) NSString              *ID;
@property (nonatomic,   copy) NSString              *displayMessage;
@property (nonatomic,   copy) NSString              *path;
@property (nonatomic, assign) SHAssetStatus         status;
@property (nonatomic, assign) SHRepoProvider        repoProvider;
@property (nonatomic, assign) SHRepoType            repoType;
@property (nonatomic, strong) NSDate                *createdAt;
@property (nonatomic, strong) NSDate                *updatedAt;
@property (nonatomic, strong) NSMutableDictionary   *attributes;
@property (nonatomic, assign) BOOL                  isShared;
@property (nonatomic, assign) int                   internalState;

+ (SHAssetRepoMetadata *)create:(NSDictionary *)metadata;

@end
//
//  SHUserLinkedRepoMetadata.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 9/16/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import "SHAssetType.h"
#import "SHRepoUtilities.h"

@interface SHUserLinkedRepoMetadata : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *createdAt;
@property (nonatomic, copy) NSString *updatedAt;
@property (nonatomic, assign) SHRepoProvider repoProvider;
@property (nonatomic, assign) SHRepoType repoType;
@property (nonatomic, strong) NSDictionary *authenticationParams;
@property (nonatomic, strong) NSDictionary *attributes;

+(SHUserLinkedRepoMetadata *)create:(id)metadata;
@end
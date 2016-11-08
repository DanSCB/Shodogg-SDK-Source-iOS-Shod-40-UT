//
//  SHAssetRepoMetadata.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 9/16/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import "SHAssetRepoMetadata.h"
#import "SHUtilities.h"

@implementation SHAssetRepoMetadata

+ (SHAssetRepoMetadata *)create:(NSDictionary *)metadata {
    
    SHAssetRepoMetadata *repoMeta = [[SHAssetRepoMetadata alloc] init];
    [repoMeta setID:NilToEmptyString(metadata[@"id"])];
    [repoMeta setDisplayMessage:NilToEmptyString(metadata[@"displayMessage"])];
    [repoMeta setPath:NilToEmptyString(metadata[@"path"])];
    [repoMeta setStatus:SHAssetStatusFromString([metadata[@"status"] uppercaseString])];
    [repoMeta setRepoProvider:SHRepoProviderFromString([metadata[@"repoProvider"] uppercaseString])];
    [repoMeta setRepoType:SHRepoTypeFromString([metadata[@"repoType"] uppercaseString])];
    [repoMeta setCreatedAt:dateFromTimeInterval([metadata[@"createdAt"] doubleValue])];
    [repoMeta setCreatedAt:dateFromTimeInterval([metadata[@"updatedAt"] doubleValue])];
    [repoMeta setAttributes:metadata[@"attrs"]];
    [repoMeta setIsShared:[metadata[@"shared"] boolValue]];
    [repoMeta setInternalState:[metadata[@"internalState"] intValue]];
    
    return repoMeta;
}
@end
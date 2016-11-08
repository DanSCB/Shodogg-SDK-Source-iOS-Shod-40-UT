//
//  SHUserLinkedRepoMetadata.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 9/16/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import "SHUserLinkedRepoMetadata.h"
#import "SHUtilities.h"

@implementation SHUserLinkedRepoMetadata
+(SHUserLinkedRepoMetadata *)create:(id)metadata{
    SHUserLinkedRepoMetadata *repoMetadata = [[SHUserLinkedRepoMetadata alloc] init];
    [repoMetadata setID:NilToEmptyString([metadata objectForKey:@"id"])];
    [repoMetadata setRepoProvider:SHRepoProviderFromString(NilToEmptyString([metadata objectForKey:@"repoProvider"]))];
    [repoMetadata setRepoType:SHRepoTypeFromString(NilToEmptyString([metadata objectForKey:@"repoType"]))];
    [repoMetadata setCreatedAt:[metadata objectForKey:@"createdAt"]];
    [repoMetadata setCreatedAt:[metadata objectForKey:@"updatedAt"]];
    [repoMetadata setAttributes:[metadata objectForKey:@"attributes"]];
    [repoMetadata setAuthenticationParams:[metadata objectForKey:@"authenticationParams"]];

    return repoMetadata;
}
@end
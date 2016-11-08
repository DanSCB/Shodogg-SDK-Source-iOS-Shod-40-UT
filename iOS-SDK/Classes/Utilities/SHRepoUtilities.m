//
//  SHRepoUtilities.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 9/25/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import "SHRepoUtilities.h"

#pragma mark - SHRepoProvider Utils
BOOL SHRepoProviderIsStringValid(NSString *provider) {
    if (!provider) {
        return NO;
    }
    static NSSet *set = nil;
    if (set == nil) {
        set = [NSSet setWithArray:SHRepoProviderAllNames()];
    }
    return [set containsObject:provider];
}

NSString *SHRepoProviderAsString(SHRepoProvider repoProvider) {
    if (repoProvider < [SHRepoProviderAllNames() count]) {
        return [SHRepoProviderAllNames() objectAtIndex:repoProvider];
    }
    //[NSException raise:NSGenericException format:@"SHUtilities: Unexpected RepoProvider(%ld)", (long)repoProvider];
    return @"INVALID";
}

SHRepoProvider SHRepoProviderFromString(NSString *provider) {
    if ([provider isEqualToString:@""]) {
        return SHRepoProviderInvalid;
    }
    return (SHRepoProvider)[SHRepoProviderAllNames() indexOfObject:provider];
}

NSArray *SHRepoProviderAllNames() {
    static NSArray *repoProviderNames = nil;
    if (repoProviderNames == nil) {
        repoProviderNames = kSHRepoProviderAllNames;
    }
    return repoProviderNames;
}

#pragma mark - SHRepoType Utils
BOOL SHRepoTypeIsStringValid(NSString *type) {
    if (!type) {
        return NO;
    }
    static NSSet *set = nil;
    if (set == nil) {
        set = [NSSet setWithArray:SHRepoTypeAllNames()];
    }
    return [set containsObject:type];
}

NSString *SHRepoTypeAsString(SHRepoType repoType) {
    if (repoType < [SHRepoTypeAllNames() count]) {
        return [SHRepoTypeAllNames() objectAtIndex:repoType];
    }
    //[NSException raise:NSGenericException format:@"SHUtilities: Unexpected RepoType(%ld)", (long)repoType];
    return @"INVALID";
}

SHRepoType SHRepoTypeFromString(NSString *type) {
    if ([type isEqualToString:@""]) {
        return SHRepoTypeInvalid;
    }
    return (SHRepoType)[SHRepoTypeAllNames() indexOfObject:type];
}

NSArray *SHRepoTypeAllNames() {
    static NSArray *repoTypeNames = nil;
    if (repoTypeNames == nil) {
        repoTypeNames = kSHRepoTypeAllNames;
    }
    return repoTypeNames;
}
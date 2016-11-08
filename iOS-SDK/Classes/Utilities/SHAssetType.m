//
//  SHAssetType.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 9/16/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import "SHAssetType.h"
#import <AssetsLibrary/AssetsLibrary.h>

#pragma mark - SHAssetType

NSArray *SHAssetTypeAllNames() {
    static NSArray *assetNames = nil;
    if (assetNames == nil) {
        assetNames = kSHAssetTypeAllNames;
    }
    return assetNames;
}

NSDictionary *SHAssetAllTypeNamesAsDictionary() {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    for (NSString *typeName in SHAssetTypeAllNames()) {
        [result setValue:typeName forKey:typeName];
    }
    return result;
}

SHAssetType SHAssetTypeFromString(NSString *type) {
    return (SHAssetType)[SHAssetTypeAllNames() indexOfObject:type];
}

NSString *SHAssetTypeAsString(SHAssetType assetType) {
    if (assetType < [SHAssetTypeAllNames() count]) {
        return [SHAssetTypeAllNames() objectAtIndex:assetType];
    }
    return @"UNKNOWN";
}

BOOL SHAssetTypeIsStringValid(NSString *type) {
    if (!type) {
        return NO;
    }
    static NSSet *set = nil;
    if (set == nil) {
        set = [NSSet setWithArray:SHAssetTypeAllNames()];
    }
    return [set containsObject:type];
}

#pragma mark - SHFileType

NSArray *SHFileTypeAllNames() {
    static NSArray *assetNames = nil;
    if (assetNames == nil) {
        assetNames = kSHFileTypeAllNames;
    }
    return assetNames;
}

SHFileType SHFileTypeFromString(NSString *type) {
    return (SHFileType)[SHFileTypeAllNames() indexOfObject:type];
}

NSString *SHFileTypeAsString(SHFileType fileType) {
    if (fileType < [SHFileTypeAllNames() count]) {
        return [SHFileTypeAllNames() objectAtIndex:fileType];
    }
    return @"UNKNOWN";
}

BOOL SHFileTypeIsStringValid(NSString *type) {
    if (!type) {
        return NO;
    }
    static NSSet *set = nil;
    if (set == nil) {
        set = [NSSet setWithArray:SHFileTypeAllNames()];
    }
    return [set containsObject:type];
}

#pragma mark - SHAssetStatus

NSArray *SHAssetStatusAllNames() {
    static NSArray *statusNames = nil;
    if (statusNames == nil) {
        statusNames = kSHAssetStatusAllNames;
    }
    return statusNames;
}

SHAssetStatus SHAssetStatusFromString(NSString *status) {
    return (SHAssetStatus)[SHAssetStatusAllNames() indexOfObject:status];
}

NSString *SHAssetStatusAsString(SHAssetStatus assetStatus) {
    if (assetStatus < [SHAssetStatusAllNames() count]) {
        return [SHAssetStatusAllNames() objectAtIndex:assetStatus];
    }
    return @"UNKNOWN";
}

BOOL SHAssetStatusIsStringValid(NSString *status) {
    if (!status) {
        return NO;
    }
    static NSSet *set = nil;
    if (set == nil) {
        set = [NSSet setWithArray:SHAssetTypeAllNames()];
    }
    return [set containsObject:status];
}

#pragma mark - SHAssetState

NSArray *SHAssetStateAllNames(){
    static NSArray *stateNames = nil;
    if (stateNames == nil) {
        stateNames = kSHAssetStateAllNames;
    }
    return stateNames;
}

SHAssetState SHAssetStateFromString(NSString *state) {
    return (SHAssetState)[SHAssetStateAllNames() indexOfObject:state];
}

NSString *SHAssetStateAsString(SHAssetState assetState) {
    if (assetState < [SHAssetStateAllNames() count]) {
        return [SHAssetStateAllNames() objectAtIndex:assetState];
    }
    return @"UNKNOWN";
}

BOOL SHAssetStateIsStringValid(NSString *state) {
    if (!state) {
        return NO;
    }
    static NSSet *set = nil;
    if (set == nil) {
        set = [NSSet setWithArray:SHAssetStateAllNames()];
    }
    return [set containsObject:state];
}
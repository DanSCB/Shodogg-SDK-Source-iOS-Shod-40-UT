//
//  SHScreenAssetState.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 10/3/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import "SHScreenAssetState.h"
#import "SHUtilities.h"

@implementation SHScreenAssetState

+ (SHScreenAssetState *)fromJSON:(id)JSON
{
    SHScreenAssetState *assetState = [[SHScreenAssetState alloc] init];
    [assetState setId:NilToEmptyString(JSON[@"id"])];
    [assetState setAssetId:NilToEmptyString(JSON[@"assetId"])];
    NSString *stateString = NilToEmptyString(JSON[@"state"]);
    [assetState setState:SHAssetStateFromString([stateString uppercaseString])];
    [assetState setAssetType:SHAssetTypeFromString(JSON[@"assetType"])];
    [assetState setCreatedAt:NilToEmptyString(JSON[@"createdAt"])];
    [assetState setUpdatedAt:NilToEmptyString(JSON[@"updatedAt"])];
    [assetState setAttributes:JSONToDictionaryOrEmpty(JSON[@"attrs"])];
    
    return assetState;
}

+ (instancetype)forState:(SHAssetState)state
                    type:(SHAssetType)assetType
              attributes:(NSDictionary *)attributes {

    return [[self alloc] initWithState:state
                               assetId:nil
                             assetType:assetType
                           atttributes:attributes];
}

+ (instancetype)forState:(SHAssetState)state
                 assetId:(NSString *)assetId
              attributes:(NSDictionary *)attributes {
    return [[self alloc] initWithState:state
                               assetId:assetId
                             assetType:SHAssetTypeUnknown
                           atttributes:attributes];
}

- (instancetype)initWithState:(SHAssetState)state
                      assetId:(NSString *)assetId
                    assetType:(SHAssetType)assetType
                  atttributes:(NSDictionary *)attributes {
    
    if (self = [super init]) {
        self.assetId = assetId;
        self.state = state;
        self.assetType = assetType;
        self.attributes = attributes;
    }
    
    return self;
}

- (NSDictionary *)toDictionary {
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    dictionary[@"assetId"]   = NilToEmptyString(self.assetId);
    dictionary[@"state"]     = SHAssetStateAsString(self.state);
    dictionary[@"attrs"]     = self.attributes;
    NSString *typeAsString = SHAssetTypeAsString(self.assetType);
    if (![typeAsString isEqual:@"UNKNOWN"]) {
        dictionary[@"assetType"] = typeAsString;
    }
    
    return dictionary;
}

@end
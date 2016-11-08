//
//  SHScreenAssetState.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 10/3/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHAssetType.h"

@interface SHScreenAssetState : NSObject

@property (nonatomic,   copy) NSString      *Id;
@property (nonatomic,   copy) NSString      *assetId;
@property (nonatomic,   copy) NSString      *createdAt;
@property (nonatomic,   copy) NSString      *updatedAt;
@property (nonatomic, strong) NSDictionary  *attributes;
@property (nonatomic, assign) SHAssetType   assetType;
@property (nonatomic, assign) SHAssetState 	state;

+ (SHScreenAssetState *)fromJSON:(id)JSON;
+ (instancetype)forState:(SHAssetState)state
                    type:(SHAssetType)assetType
              attributes:(NSDictionary *)attributes;
+ (instancetype)forState:(SHAssetState)state
                 assetId:(NSString *)assetId
              attributes:(NSDictionary *)attributes;
- (NSDictionary *)toDictionary;

@end
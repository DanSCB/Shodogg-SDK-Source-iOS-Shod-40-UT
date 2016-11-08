//
//  SHAssetStatusRef.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 12/30/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHAssetType.h"

@interface SHAssetStatusRef : NSObject
@property (nonatomic, copy) NSString *assetId;
@property (nonatomic, assign) SHAssetStatus assetStatus;
@property (nonatomic, copy) NSString *errorMessage;

+ (SHAssetStatusRef *)fromJSON:(id)JSON;
@end

//
//  SHAssetStatusRef.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 12/30/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import "SHAssetStatusRef.h"
#import "SHUtilities.h"

@implementation SHAssetStatusRef
+ (SHAssetStatusRef *)fromJSON:(id)JSON {
    SHAssetStatusRef *ref = [[SHAssetStatusRef alloc] init];
    [ref setAssetId:NilToEmptyString([JSON objectForKey:@"assetId"])];
    [ref setAssetStatus:SHAssetStatusFromString(NilToEmptyString([JSON objectForKey:@"status"]))];
    [ref setErrorMessage:NilToEmptyString([JSON objectForKey:@"error"])];
    return ref;
}
@end
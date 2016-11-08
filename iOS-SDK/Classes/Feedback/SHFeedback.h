//
//  SHFeedback.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 3/13/15.
//  Copyright (c) 2015 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHFeedback : NSObject

+ (void)submitRating:(NSInteger)rating forAssetWithId:(NSString *)assetId pageNumber:(NSInteger)pageNum completionBlock:(void (^)(BOOL success, NSError *error))completion;
+ (void)submitLike:(BOOL)like forAssetWithId:(NSString *)assetId pageNumber:(NSInteger)pageNum completionBlock:(void(^)(BOOL success, NSError *error))completion;
@end
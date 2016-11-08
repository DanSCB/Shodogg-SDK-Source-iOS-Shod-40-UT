//
//  SHFeedback.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 3/13/15.
//  Copyright (c) 2015 Shodogg. All rights reserved.
//

#import "SHFeedback.h"
#import "SHUbeAPIClient.h"

static NSString *baseFeedbackPathString = @"/api/POC/feedback/asset";

@implementation SHFeedback

#pragma mark - 

+ (void)postFeedbackWithPath:(NSString *)path parameters:(NSDictionary *)params completionBlock:(void (^)(BOOL success, NSError *error))completion {
    [[SHUbeAPIClient sharedClient] POST:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(YES, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(NO, error);
    }];
}

+ (void)submitRating:(NSInteger)rating forAssetWithId:(NSString *)assetId pageNumber:(NSInteger)pageNum completionBlock:(void (^)(BOOL, NSError *))completion {
    NSString        *pathURLString  = [baseFeedbackPathString stringByAppendingFormat:@"/%@/rating", assetId];
    NSDictionary    *parameters     = @{@"page": @(pageNum),@"rating":@(rating)};
    [self postFeedbackWithPath:pathURLString parameters:parameters completionBlock:completion];
}

+ (void)submitLike:(BOOL)like forAssetWithId:(NSString *)assetId pageNumber:(NSInteger)pageNum completionBlock:(void (^)(BOOL, NSError *))completion {
    NSString        *pathURLString  = [baseFeedbackPathString stringByAppendingFormat:@"/%@/like", assetId];
    NSDictionary    *parameters     = @{@"page": @(pageNum),@"value":@(like)};
    [self postFeedbackWithPath:pathURLString parameters:parameters completionBlock:completion];
}
@end
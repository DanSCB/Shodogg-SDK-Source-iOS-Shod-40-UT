//
//  SHYoutube.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 1/2/14.
//  Copyright (c) 2014 Shodogg. All rights reserved.
//

#import "SHYoutube.h"
#import "SHUtilities.h"
#import "SHUbeAPIClient.h"
#import "SHAssetMinimalDTO.h"
#import "SHYoutubeDTO.h"

@implementation SHYoutube

#pragma mark - APIs

+ (void)youtubeSearchWithQueryString:(NSString *)query resultsPageNumber:(NSInteger)pageNum completionBlock:(void (^)(NSArray *, NSError *))completion
{
    NSString        *URLString  = @"/api/youtube/searchdto";
    NSDictionary    *parameters = @{@"query" : query, @"page.size" : @(15), @"page.page" : @(pageNum)};
    [[SHUbeAPIClient sharedClient] GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"\n[%@ - %@] {\n\tJSON: %@,\n\tError:%@\n}", @"GET", URLString, responseObject, [task.error localizedDescription]);
        NSArray         *allEntries         = JSONToArrayOrEmpty([responseObject[@"results"] allObjects]);
        NSMutableArray  *youtubeEntryArray  = [[NSMutableArray alloc] initWithCapacity:[allEntries count]];
        [allEntries enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SHYoutubeDTO *youtubeEntry = (SHYoutubeDTO *)[SHYoutubeDTO fromJSON:obj];
            if (youtubeEntry) {
                [youtubeEntryArray addObject:youtubeEntry];
            }
        }];
        completion(youtubeEntryArray, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
}

+ (void)youtubeImportAssetWithURLString:(NSString *)url inFolderWithId:(NSString *)folderId completionBlock:(void (^)(SHAssetMinimalDTO *, NSError *))completion
{
    NSString *URLString  = @"/api/youtube/asset";

    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:url forKey:@"url"];
    if (folderId.length > 0) {
        [parameters setObject:folderId forKey:@"folder_id"];
    }
    
    [[SHUbeAPIClient sharedClient] POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        id                  assetObj    = responseObject[@"data"];
        SHAssetMinimalDTO   *asset      = [SHAssetMinimalDTO fromJSON:assetObj];
        completion(asset, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
}
@end
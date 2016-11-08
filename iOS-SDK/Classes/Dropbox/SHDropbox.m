//
//  SHDropbox.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 12/10/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import "SHDropbox.h"
#import "SHUbeAPIClient.h"
#import "SHDropboxEntryDTO.h"
#import "SHAssetMinimalDTO.h"
#import "SHUtilities.h"

@implementation SHDropbox

#pragma mark - APIs

+ (void)dropboxLinkAccountWithAccessToken:(NSString *)token tokenSecret:(NSString *)secret completionBlock:(void (^)(BOOL, NSError *))completion {
    NSString        *URLString  = @"/api/dropbox/link";
    NSDictionary    *parameters = @{@"key":token, @"secret":secret};
    [[SHUbeAPIClient sharedClient] POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(YES, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(NO, error);
    }];
}

+ (void)dropboxUnlinkAccountWithCompletion:(void (^)(BOOL, NSError *))completion {
    NSString *URLString = @"/api/dropbox/link";
    [[SHUbeAPIClient sharedClient] DELETE:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(YES, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(NO, error);
    }];
}

+ (void)dropboxGetAccountInfoWithCompletion:(void (^)(NSDictionary *, NSError *))completion {
    NSString *URLString = @"/api/dropbox/acctinfo";
    [[SHUbeAPIClient sharedClient] GET:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *info = (NSDictionary *)responseObject;
        completion(info, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
}

+ (void)dropboxSearchFilesWithQuery:(NSString *)query completion:(void (^)(NSArray *, NSError *))completion {
    NSString        *URLString  = @"/api/dropbox/search";
    NSDictionary    *parameters = @{@"query":query};
    [[SHUbeAPIClient sharedClient] GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray         *allObjects = (NSArray *)[responseObject allObjects];
        NSMutableArray  *entries    = [[NSMutableArray alloc] initWithCapacity:allObjects.count];
        [allObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SHDropboxEntryDTO *dbEntry = (SHDropboxEntryDTO *)[SHDropboxEntryDTO fromJSON:obj];
            if (dbEntry) {
                [entries addObject:dbEntry];
            }
        }];
        [entries sortUsingDescriptors:@[[SHUtilities sortDescriptor:@"displayName"]]];
        completion(entries, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
}

+ (void)dropboxShareFiles:(NSArray *)files completionBlock:(void (^)(NSArray *, NSError *))completion {
    NSString            *URLString  = @"/api/dropbox/share";
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [files enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SHAssetMinimalDTO *asset = (SHAssetMinimalDTO *)obj;
        [parameters setValue:asset.path         forKey:[NSString stringWithFormat:@"file_%lu_path", (unsigned long)idx]];
        [parameters setValue:asset.originalURL  forKey:[NSString stringWithFormat:@"file_%lu_url", (unsigned long)idx]];
    }];
    [[SHUbeAPIClient sharedClient] POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *allAssets = (NSArray *)[responseObject allObjects];
        NSMutableArray *assetsArray = [[NSMutableArray alloc] initWithCapacity:allAssets.count];
        [allAssets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SHAssetMinimalDTO *sharedAsset = [SHAssetMinimalDTO fromJSON:obj];
            if (sharedAsset) {
                [assetsArray addObject:sharedAsset];
            }
        }];
        completion(assetsArray, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
}
@end
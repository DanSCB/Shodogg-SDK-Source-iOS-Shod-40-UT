//
//  SHAsset.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 10/10/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import "SHAsset.h"
#import "SHUbeAPIClient.h"
#import "SHRemoteRefToAsset.h"
#import "SHAssetStatusRef.h"
#import "SHNote.h"
#import "SHUtilities.h"

static NSString *baseAssetPathString = @"/api/asset";

@implementation SHAsset

- (instancetype)initWithAttributes:(id)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    return self;
    
}

#pragma mark - APIs

+ (void)getAssetsWithResultsPerPage:(NSInteger)pageSize pageNumber:(NSInteger)pageNumber completionBlock:(void (^)(NSArray *, NSError *))completion {
    NSDictionary    *parameters     = @{@"page.page" : @(pageNumber), @"page.size" : @(pageSize)};
    [[SHUbeAPIClient sharedClient] GET:baseAssetPathString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *allAssets = (NSArray *)[responseObject allObjects];
        NSMutableArray *assets = [[NSMutableArray alloc] initWithCapacity:allAssets.count];
        [allAssets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SHRemoteRefToAsset *asset = [SHRemoteRefToAsset createFromJSON:obj];
            if (asset) {
                [assets addObject:asset];
            }
        }];
        completion(assets, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
}

+ (void)getAssetWithId:(NSString *)assetId completionBlock:(void (^)(SHRemoteRefToAsset *, NSError *))completion {
    NSString *pathString = [baseAssetPathString stringByAppendingPathComponent:assetId];
    [[SHUbeAPIClient sharedClient] GET:pathString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"\n[%@ - %@] {\n\tHeaders:%@,\n\tJSON: %@,\n\tError:%@\n}", @"POST", pathString, [response allHeaderFields], responseObject, [task.error localizedDescription]);
        SHRemoteRefToAsset *asset = [SHRemoteRefToAsset createFromJSON:responseObject];
        completion(asset, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
}

+ (void)deleteAssetWithId:(NSString *)assetId completionBlock:(void (^)(BOOL, NSError *))completion {
    NSString *path = [baseAssetPathString stringByAppendingPathComponent:assetId];
    [SHAsset performDELETEWithURLPath:path completionBlock:completion];
}

+ (void)addNoteWithText:(NSString *)text toAssetWithId:(NSString *)assetId atPageNumber:(NSInteger)pageNumber completionBlock:(void (^)(SHNote *, NSError *))completion {
    NSDictionary    *parameters     = @{@"note": text};
    NSString        *path           = [baseAssetPathString stringByAppendingFormat:@"/%@/page/%ld/note", assetId, (long)pageNumber];
    [SHAsset performNoteRequestWithMethod:@"POST" urlPathComponent:path parameters:parameters completionBlock:completion];
}

+ (void)editNoteWithId:(NSString *)noteId forAssetWithId:(NSString *)assetId modifiedText:(NSString *)text atPageNumber:(NSInteger)pageNumber completionBlock:(void (^)(SHNote *, NSError *))completion {
    NSDictionary    *parameters = @{@"note": text};
    NSString        *path       = [baseAssetPathString stringByAppendingFormat:@"/%@/page/%ld/note/%@", assetId, (long)pageNumber, noteId];
    [SHAsset performNoteRequestWithMethod:@"PUT" urlPathComponent:path parameters:parameters completionBlock:completion];
}

+ (void)deleteNoteWithId:(NSString *)noteId forAssetWithId:(NSString *)assetId atPageNumber:(NSInteger)pageNumber completionBlock:(void (^)(BOOL, NSError *))completion {
    NSString *path = [baseAssetPathString stringByAppendingFormat:@"/%@/page/%ld/note/%@", assetId, (long)pageNumber, noteId];
    [SHAsset performDELETEWithURLPath:path completionBlock:completion];
}

+ (void)addNoteWithText:(NSString *)text toAssetWithId:(NSString *)assetId completionBlock:(void (^)(SHNote *, NSError *))completion {
    NSDictionary    *parameters = @{@"note": text};
    NSString        *path       = [baseAssetPathString stringByAppendingFormat:@"/%@/note", assetId];
    [SHAsset performNoteRequestWithMethod:@"POST" urlPathComponent:path parameters:parameters completionBlock:completion];
}

+ (void)editNoteWithId:(NSString *)noteId forAssetWithId:(NSString *)assetId modifiedText:(NSString *)text completionBlock:(void (^)(SHNote *, NSError *))completion {
    NSDictionary    *parameters = @{@"note": text};
    NSString        *path       = [baseAssetPathString stringByAppendingFormat:@"/%@/note/%@", assetId, noteId];
    [SHAsset performNoteRequestWithMethod:@"PUT" urlPathComponent:path parameters:parameters completionBlock:completion];
}

+ (void)deleteNoteWithId:(NSString *)noteId forAssetWithId:(NSString *)assetId completionBlock:(void (^)(BOOL, NSError *))completion {
    NSString *path = [baseAssetPathString stringByAppendingFormat:@"/%@/note/%@", assetId, noteId];
    [SHAsset performDELETEWithURLPath:path completionBlock:completion];
}

+ (void)getConversionStatusUpdatesForAssetsWithIds:(NSArray *)assetIds completionBlock:(void (^)(NSArray *, NSError *))completion {
    NSDictionary *parameters = @{@"asset_ids": [assetIds componentsJoinedByString:@","]};
    NSString            *path = [baseAssetPathString stringByAppendingPathComponent:@"status"];
    [[SHUbeAPIClient sharedClient] GET:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"\n[GET - %@] {\n\tJSON: %@, \n\tError:%@\n", path, responseObject, [task.error localizedDescription]);
        NSArray *assetNodes = (NSArray *)[responseObject allObjects];
        NSMutableArray *assetStatusObjs = [[NSMutableArray alloc] initWithCapacity:assetNodes.count];
        [assetNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SHAssetStatusRef *ref = (SHAssetStatusRef *)[SHAssetStatusRef fromJSON:obj];
            if (ref) {
                [assetStatusObjs addObject:ref];
            }
        }];
        completion(assetStatusObjs, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
}

+ (void)shareAssetWithId:(NSString *)assetId toEmailAddress:(NSString *)email messageToInclude:(NSString *)message completionBlock:(void (^)(BOOL, NSError *))completion {
    NSString *path = [baseAssetPathString stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/slideshare/email", assetId]];
    NSDictionary *params = @{@"email" : email, @"message" : message};
    [[SHUbeAPIClient sharedClient] POST:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(YES, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(NO, error);
    }];
}
#pragma mark - 

+ (void)performNoteRequestWithMethod:(NSString *)method urlPathComponent:(NSString *)pathComponent parameters:(NSDictionary *)parameters completionBlock:(void(^)(SHNote *note, NSError *error))completion {
    SHUbeAPIClient          *httpClient = [SHUbeAPIClient sharedClient];
    NSString                *baseURL    = [httpClient.baseURL absoluteString];
    NSString                *pathString = [baseURL stringByAppendingPathComponent:pathComponent];
    NSURLRequest            *request    = [[httpClient requestSerializer] requestWithMethod:method URLString:pathString parameters:parameters error:nil];
    NSURLSessionDataTask    *task       = [httpClient dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        SHNote *note = [SHNote fromJSON:responseObject];
        NSLog(@"\n[%@ - %@] {\n\tJSON: %@,\n\tError:%@\n}", request.HTTPMethod, request.URL.absoluteString, responseObject, [error localizedDescription]);
        if (note) {
            completion(note, error);
        } else {
            completion(nil, error);
        }
    }];
    [task resume];
}

+ (void)performDELETEWithURLPath:(NSString *)path completionBlock:(void(^)(BOOL success, NSError *error))completion {
    [[SHUbeAPIClient sharedClient] DELETE:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"\n[%@ - %@] {\n\tJSON: %@,\n\tError:%@\n}", @"DELETE", path, responseObject, [task.error localizedDescription]);
        completion(YES, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(NO, error);
    }];
}
@end
//
//  SHFolder.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 9/16/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import "SHFolder.h"
#import "SHUbeAPIClient.h"
#import "SHAssetMinimalDTO.h"
#import "SHUtilities.h"

static NSString *baseFolderPathString    = @"/api/folder";
static NSString *baseUserFoldePathString = @"/api/user/folder";

@implementation SHFolder

- (instancetype)initWithAttributes:(id)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.Id             = NilToEmptyString(attributes[@"id"]);
    self.displayName    = NilToEmptyString(attributes[@"name"]);
    self.folders        = [self convertToFolderRef:JSONToArrayOrEmpty(attributes[@"folders"])];
    self.repoProvider   = SHRepoProviderFromString(NilToEmptyString(attributes[@"repositoryProvider"]));
    self.createdAt      = dateFromTimeInterval([attributes[@"createdAt"] doubleValue]);
    self.updatedAt      = dateFromTimeInterval([attributes[@"updatedAt"] doubleValue]);
    self.addlAttributes = JSONToDictionaryOrEmpty(attributes[@"attributes"]);
    
    return self;
}

- (NSArray *)convertToFolderRef:(NSArray *)folders
{
    NSMutableArray *folderArray = [[NSMutableArray alloc] initWithCapacity:folders.count];
    [folders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SHFolder *folder = [[SHFolder alloc] initWithAttributes:obj];
        if (folder) {
            [folderArray addObject:folder];
        }
    }];

    return folderArray;
}

+ (NSDictionary *)parseFolderContentsResponse:(id)responseObject
{
    NSArray     *folders    = JSONToArrayOrEmpty([responseObject[@"folders"] allObjects]);
    NSArray     *assets     = JSONToArrayOrEmpty([responseObject[@"assets"] allObjects]);
    NSString    *folderId   = NilToEmptyString(responseObject[@"id"]);
    NSString    *folderName = NilToEmptyString(responseObject[@"name"]);
    NSMutableArray *foldersArray    = [[NSMutableArray alloc] initWithCapacity:folders.count];
    NSMutableArray *assetsArray     = [[NSMutableArray alloc] initWithCapacity:assets.count];
    [folders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SHFolder *folder = [[SHFolder alloc] initWithAttributes:obj];
        if (folder) {
            [foldersArray addObject:folder];
        }
    }];
    [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SHAssetMinimalDTO *asset = [SHAssetMinimalDTO fromJSON:obj];
        if (asset) {
            [assetsArray addObject:asset];
        }
    }];
    
    return @{@"folderId" : folderId, @"folderName" : folderName, @"folders" : foldersArray, @"assets" : assetsArray};
}

#pragma mark - APIs
#pragma mark - Folder

+ (void)getRootFolderContentsExcludingRepositories:(BOOL)exludeRepos completionBlock:(void (^)(NSArray *, NSError *))completion
{
    NSString *pathString = [baseFolderPathString stringByAppendingPathComponent:@"root"];
    [[SHUbeAPIClient sharedClient] GET:pathString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray         *allFolders             = JSONToArrayOrEmpty([responseObject allObjects]);
        NSMutableArray  *foldersArray           = [[NSMutableArray alloc] init];
        NSMutableArray  *foldersToExcludeArray  = [[NSMutableArray alloc] init];
        [allFolders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SHFolder        *folder         = [[SHFolder alloc] initWithAttributes:obj];
            SHRepoProvider  repoProvider    = folder.repoProvider;
            if (repoProvider == SHRepoProviderDropbox || repoProvider == SHRepoProviderYoutube) {
                [foldersToExcludeArray addObject:folder];
            }
            [foldersArray addObject:folder];
        }];
        
        if (exludeRepos) {
            [foldersArray removeObjectsInArray:foldersToExcludeArray];
        }
        completion(foldersArray, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
}

+ (void)getFolderContentsAtPath:(NSString *)path completionBlock:(void (^)(NSDictionary *, NSError *))completion
{
    [[SHUbeAPIClient sharedClient] GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"\n[%@ - %@] {\n\tHeaders:%@,\n\tJSON: %@,\n\tError:%@\n}", @"GET", path, [response allHeaderFields], responseObject, [task.error localizedDescription]);
        NSDictionary *contents = [SHFolder parseFolderContentsResponse:responseObject];
        completion(contents, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
}

+ (void)getDropboxFolderContentsWithCompletion:(void (^)(NSDictionary *, NSError *))completion
{
    NSString *path = [baseUserFoldePathString stringByAppendingPathComponent:@"dropbox"];
    [SHFolder getFolderContentsAtPath:path completionBlock:completion];
}

+ (void)getYouTubeFolderContentsWithCompletion:(void (^)(NSDictionary *, NSError *))completion
{
    NSString *path = [baseUserFoldePathString stringByAppendingPathComponent:@"youtube"];
    [SHFolder getFolderContentsAtPath:path completionBlock:completion];
}

+ (void)getUploadFolderContentsWithCompletion:(void (^)(NSDictionary *, NSError *))completion
{
    NSString *path = [baseUserFoldePathString stringByAppendingPathComponent:@"upload"];
    [SHFolder getFolderContentsAtPath:path completionBlock:completion];
}

+ (void)getContentsOfFolderWithId:(NSString *)folderId completionBlock:(void (^)(NSDictionary *, NSError *))completion {
    NSString *path = [baseFolderPathString stringByAppendingPathComponent:folderId];
    [SHFolder getFolderContentsAtPath:path completionBlock:completion];
}

+ (void)deleteFolderWithId:(NSString *)folderId completionBlock:(void (^)(BOOL, NSError *))completion
{
    NSString *pathString = [baseUserFoldePathString stringByAppendingPathComponent:folderId];
    [[SHUbeAPIClient sharedClient] DELETE:pathString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(YES, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(NO, error);
    }];
}

#pragma mark - Upload
+ (void)uploadFileWithURLString:(NSString *)url inFolderWithId:(NSString *)folderId fileName:(NSString *)filename completionBlock:(void (^)(SHAssetMinimalDTO *, NSError *))completion
{
    NSDictionary *parameters = @{@"fileURL" : url, @"fileName" : filename, @"folder_id" : folderId};
    [[SHUbeAPIClient sharedClient] POST:@"/api/upload/fileURL" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        SHAssetMinimalDTO *asset = [SHAssetMinimalDTO fromJSON:responseObject];
        completion(asset, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
}
@end
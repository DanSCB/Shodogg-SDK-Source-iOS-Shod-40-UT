//
//  SHFolder.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 9/16/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHAssetType.h"
#import "SHRepoUtilities.h"

@class SHAssetMinimalDTO;

@interface SHFolder : NSObject

@property (nonatomic,   copy) NSString          *Id;
@property (nonatomic,   copy) NSString          *displayName;
@property (nonatomic, strong) NSDate            *createdAt;
@property (nonatomic, strong) NSDate            *updatedAt;
@property (nonatomic, strong) NSArray           *folders;
@property (nonatomic, strong) NSDictionary      *addlAttributes;
@property (nonatomic, assign) SHRepoProvider    repoProvider;

- (instancetype)initWithAttributes:(id)attributes;

+ (void)getRootFolderContentsExcludingRepositories:(BOOL)exludeRepos completionBlock:(void(^)(NSArray *folders, NSError *error))completion;
+ (void)getUploadFolderContentsWithCompletion:(void (^)(NSDictionary *contents, NSError *error))completion;
+ (void)getDropboxFolderContentsWithCompletion:(void (^)(NSDictionary *contents, NSError *error))completion;
+ (void)getYouTubeFolderContentsWithCompletion:(void (^)(NSDictionary *contents, NSError *error))completion;
+ (void)getContentsOfFolderWithId:(NSString *)folderId completionBlock:(void(^)(NSDictionary *contents, NSError *error))completion;
+ (void)deleteFolderWithId:(NSString *)folderId completionBlock:(void(^)(BOOL success, NSError *error))completion;
+ (void)uploadFileWithURLString:(NSString *)url inFolderWithId:(NSString *)folderId fileName:(NSString *)filename completionBlock:(void (^)(SHAssetMinimalDTO *asset, NSError *error))completion;
@end
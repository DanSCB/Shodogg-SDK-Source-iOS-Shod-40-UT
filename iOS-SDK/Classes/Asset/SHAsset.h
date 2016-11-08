//
//  SHAsset.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 10/10/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SHRemoteRefToAsset;
@class SHNote;

@interface SHAsset : NSObject

- (instancetype)initWithAttributes:(id)attributes;

//Asset
+ (void)getAssetsWithResultsPerPage:(NSInteger)pageSize pageNumber:(NSInteger)pageNumber completionBlock:(void(^)(NSArray *assets, NSError *error))completion;
+ (void)getAssetWithId:(NSString *)assetId completionBlock:(void(^)(SHRemoteRefToAsset *asset, NSError *error))completion;
+ (void)deleteAssetWithId:(NSString *)assetId completionBlock:(void(^)(BOOL success, NSError *error))completion;
//PageNotes
+ (void)addNoteWithText:(NSString *)text toAssetWithId:(NSString *)assetId atPageNumber:(NSInteger)pageNumber completionBlock:(void(^)(SHNote *note, NSError *error))completion;
+ (void)editNoteWithId:(NSString *)noteId forAssetWithId:(NSString *)assetId modifiedText:(NSString *)text atPageNumber:(NSInteger)pageNumber completionBlock:(void(^)(SHNote *note, NSError *error))completion;
+ (void)deleteNoteWithId:(NSString *)noteId forAssetWithId:(NSString *)assetId atPageNumber:(NSInteger)pageNumber completionBlock:(void(^)(BOOL success, NSError *error))completion;
//AssetNotes
+ (void)addNoteWithText:(NSString *)text toAssetWithId:(NSString *)assetId completionBlock:(void (^)(SHNote *note, NSError *error))completion;
+ (void)editNoteWithId:(NSString *)noteId forAssetWithId:(NSString *)assetId modifiedText:(NSString *)text completionBlock:(void (^)(SHNote *note, NSError *error))completion;
+ (void)deleteNoteWithId:(NSString *)noteId forAssetWithId:(NSString *)assetId completionBlock:(void (^)(BOOL success, NSError *error))completion;
//AssetStatus
+ (void)getConversionStatusUpdatesForAssetsWithIds:(NSArray *)assetIds completionBlock:(void(^)(NSArray *results, NSError *error))completion;
//ShareAsset
+ (void)shareAssetWithId:(NSString *)assetId toEmailAddress:(NSString *)email messageToInclude:(NSString *)message completionBlock:(void(^)(BOOL success, NSError *error))completion;
@end
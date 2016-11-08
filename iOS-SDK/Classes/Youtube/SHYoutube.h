//
//  SHYoutube.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 1/2/14.
//  Copyright (c) 2014 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SHAssetMinimalDTO;

@interface SHYoutube : NSObject

+ (void)youtubeSearchWithQueryString:(NSString *)query resultsPageNumber:(NSInteger)pageNum completionBlock:(void(^)(NSArray *results, NSError *error))completion;
+ (void)youtubeImportAssetWithURLString:(NSString *)url inFolderWithId:(NSString *)folderId completionBlock:(void (^)(SHAssetMinimalDTO *, NSError *))completion;
@end
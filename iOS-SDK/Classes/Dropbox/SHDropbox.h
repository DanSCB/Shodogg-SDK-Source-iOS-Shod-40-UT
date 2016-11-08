//
//  SHDropbox.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 12/10/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHDropbox : NSObject

+ (void)dropboxLinkAccountWithAccessToken:(NSString *)token tokenSecret:(NSString *)secret completionBlock:(void(^)(BOOL success, NSError *error))completion;
+ (void)dropboxUnlinkAccountWithCompletion:(void(^)(BOOL success, NSError *error))completion;
+ (void)dropboxGetAccountInfoWithCompletion:(void(^)(NSDictionary *info, NSError *error))completion;
+ (void)dropboxSearchFilesWithQuery:(NSString *)query completion:(void(^)(NSArray *items, NSError *error))completion;
+ (void)dropboxShareFiles:(NSArray *)files completionBlock:(void(^)(NSArray *sharedItems, NSError *error))completion;
@end
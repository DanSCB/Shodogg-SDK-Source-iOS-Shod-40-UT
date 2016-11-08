//
//  SHAnalytics.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 11/13/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SHMobileDeviceInfoDTO;

@interface SHAnalytics : NSObject

+ (void)applicationLinkDevice:(NSString *)deviceId completionBlock:(void(^)(BOOL success, NSError *error))completion;
+ (void)applicationDidOpen:(BOOL)fromBackground completionBlock:(void(^)(BOOL success, NSError *error))completion;
+ (void)applicationDidClose:(BOOL)toBackground deviceUDID:(NSString *)udid completionBlock:(void(^)(BOOL success, NSError *error))completion;
+ (void)applicationDidCrashWithErrorMessage:(NSString *)message stackTrace:(NSString *)trace completionBlock:(void(^)(BOOL success, NSError *error))completion;
+ (void)applicationCheckVersion:(NSString *)version completionBlock:(void(^)(NSDictionary *result, NSError *error))completion;
@end
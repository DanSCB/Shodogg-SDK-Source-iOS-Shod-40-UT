//
//  SHAnalytics.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 11/13/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import "SHAnalytics.h"
#import "SHUbeAPIClient.h"
#import "SHMobileDeviceInfoDTO.h"
#import "SHUtilities.h"

static NSString *baseAnalyticsURLPath = @"/api/analytics/mobile";

@implementation SHAnalytics

#pragma mark - Analytics

+ (void)applicationLinkDevice:(NSString *)deviceId completionBlock:(void (^)(BOOL, NSError *))completion
{
    NSString        *pathURLString  = [baseAnalyticsURLPath stringByAppendingPathComponent:@"userDevice"];
    NSDictionary    *parameters     = @{@"device_id" : deviceId};
    [self postAnalyticsForPath:pathURLString parameters:parameters completionBlock:completion];
}

+ (void)applicationDidOpen:(BOOL)fromBackground completionBlock:(void (^)(BOOL, NSError *))completion
{
    NSString        *pathURLString  = [baseAnalyticsURLPath stringByAppendingPathComponent:@"appOpen"];
    NSDictionary    *parameters     = @{@"fromBackground" : @(fromBackground), @"deviceInfo" : [SHMobileDeviceInfoDTO mobileInfoDictionary]};
    [self postAnalyticsForPath:pathURLString parameters:parameters completionBlock:completion];
}

+ (void)applicationDidClose:(BOOL)toBackground deviceUDID:(NSString *)udid completionBlock:(void (^)(BOOL, NSError *))completion
{
    NSString        *pathURLString  = [baseAnalyticsURLPath stringByAppendingPathComponent:@"appClose"];
    NSDictionary    *parameters     = @{@"toBackground" : @(toBackground), @"deviceId" : udid};
    [self postAnalyticsForPath:pathURLString parameters:parameters completionBlock:completion];
}

+ (void)applicationDidCrashWithErrorMessage:(NSString *)message stackTrace:(NSString *)trace completionBlock:(void (^)(BOOL, NSError *))completion
{
    NSString        *pathURLString  = [baseAnalyticsURLPath stringByAppendingPathComponent:@"appCrash"];
    NSDictionary    *parameters     = @{@"errorMessage"  : message,
                                        @"stackTrace"    : trace,
                                        @"mobileInfo"    : [SHMobileDeviceInfoDTO mobileInfoDictionary]};
    [self postAnalyticsForPath:pathURLString parameters:parameters completionBlock:completion];
}

+ (void)applicationCheckVersion:(NSString *)version completionBlock:(void (^)(NSDictionary *, NSError *))completion
{
    NSDictionary *parameters = @{@"version" : version, @"platform" : @"IOS", @"product" : @"SHODOGG_CONNECT"};
    [[SHUbeAPIClient sharedClient] POST:@"/api/version/check" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = @{@"status"  : NilToEmptyString(responseObject[@"status"]),
                                 @"message" : NilToEmptyString(responseObject[@"message"])};
        completion(result, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
}

#pragma mark - convenience

+ (void)postAnalyticsForPath:(NSString *)path parameters:(NSDictionary *)params completionBlock:(void(^)(BOOL success, NSError *error))completion {
    [[SHUbeAPIClient sharedClient] POST:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(YES, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(NO, error);
    }];
}
@end
//
//  SHOAuth.m
//  Pods
//
//  Created by Aamir Khan on 10/30/15.
//
//

#import "SHOAuth.h"
#import "SHUbeAPIClient.h"
#import "SHUtilities.h"
#import "NSError+SHAPIError.h"

static NSString *const kSHAPBaseURL = @"/api";

@implementation SHOAuth

+ (void)fetchAuthorizationURLWithQueryParameters:(NSDictionary *)parameters completionBlock:(void (^)(NSURL *, NSError *))block
{
    NSString *provider = parameters[@"provider"];
    NSString *version  = parameters[@"version"];
    NSString *appId    = parameters[@"appId"];
    
    NSString *oauthComponent = [NSString stringWithFormat:@"/oauth/%@/%@/authorizationUrl", provider, version];
    NSString *endpoint = [kSHAPBaseURL stringByAppendingString:oauthComponent];
    if (appId.length > 0) {
        endpoint = [kSHAPBaseURL stringByAppendingFormat:@"/mid/%@%@", appId, oauthComponent];
    }
    NSDictionary *requestParameters = @{@"platform" : @"IOS"};
    
    [[SHUbeAPIClient sharedClient] GET:endpoint parameters:requestParameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"\n[%@ - %@] {\n\tJSON: %@,\n\tError:%@\n}", @"GET", endpoint, responseObject, [task.error getFailureMessageInResponseData]);
        NSURL *url = [NSURL URLWithString:NilToEmptyString(responseObject[@"url"])];
        block(url, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"\n[%@ - %@] {\n\tJSON: %@,\n\tError:%@\n}", @"GET", endpoint, task.response, [error getFailureMessageInResponseData]);
        block(nil, error);
    }];
}

+ (void)authenticateWithProviderInfo:(NSDictionary *)info completionBlock:(void (^)(SHUser *, NSError *))block
{
    NSString *provider  = info[@"provider"];
    NSString *version   = info[@"version"];
    NSString *code      = info[@"code"];
    NSString *appId     = info[@"appId"];

    NSString *oauthComponent = [NSString stringWithFormat:@"/oauth/%@/%@/auth", provider, version];
    NSString *endpoint = [kSHAPBaseURL stringByAppendingString:oauthComponent];
    if (appId.length > 0) {
        endpoint = [kSHAPBaseURL stringByAppendingFormat:@"/mid/%@%@", appId, oauthComponent];
    }
    NSDictionary *parameters = @{@"code": code, @"platform": @"IOS"};
    
    [[SHUbeAPIClient sharedClient] POST:endpoint parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"\n[%@ - %@] {\n\tJSON: %@,\n\tError:%@\n}", @"POST", endpoint, responseObject, [task.error localizedDescription]);
        SHUser *user = [[SHUser alloc] initWithAttributes:responseObject];
        block(user, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"\n[%@ - %@] {\n\tJSON: %@,\n\tError:%@\n}", @"POST", endpoint, task.response, [error localizedDescription]);
        block(nil, error);
    }];
}

@end
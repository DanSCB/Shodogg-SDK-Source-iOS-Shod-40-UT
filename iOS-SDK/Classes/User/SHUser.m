//
//  SHUser.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 9/16/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import "SHUser.h"
#import "SHUbeAPIClient.h"
#import "SHUserLinkedRepoMetadata.h"
#import "SHUserAddress.h"
#import "SHClientInformation.h"
#import "SHSecurityUtilities.h"
#import "SHUtilities.h"

static NSString *baseUserPathString = @"/api/user";
static NSString *baseAuthPathString = @"/api/auth";
static NSString *baseOauthPathString = @"/api/oauth";

@implementation SHUser

- (instancetype)initWithAttributes:(id)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    SHUbeAPIClient *client = [SHUbeAPIClient sharedClient];
    
    NSArray *repoMetadata           = (NSArray      *)JSONToArrayOrEmpty([attributes[@"repoMetadata"] allObjects]);
    NSArray *userAddresses          = (NSArray      *)JSONToArrayOrEmpty([attributes[@"addresses"] allObjects]);
    NSArray *clientInfo             = (NSArray      *)JSONToArrayOrEmpty([attributes[@"clientInformation"] allObjects]);
    NSDictionary *addlAttributes    = (NSDictionary *)JSONToDictionaryOrEmpty(attributes[@"attrs"]);
    
    self.Id                 = NilToEmptyString(attributes[@"id"]);
    self.firstName          = NilToEmptyString(attributes[@"firstName"]);
    self.lastName           = NilToEmptyString(attributes[@"lastName"]);
    self.title              = NilToEmptyString(attributes[@"title"]);
    self.email              = NilToEmptyString(attributes[@"email"]);
    self.lastLoginTime      = NilToEmptyString(attributes[@"lastLoginTime"]);
    self.eventUrlId         = NilToEmptyString(attributes[@"eventUrlId"]);
    self.screenSessionId      = NilToEmptyString(attributes[@"screenSessionId"]);
    self.currentUserAuthToken = NilToEmptyString(attributes[@"currentUserAuthToken"]);
    self.repoMetadata       = [self convertToRepoRefs:repoMetadata];
    self.userAddresses      = [self convertToAddressRefs:userAddresses];
    self.clientInformation  = [self convertToClientInfoRefs:clientInfo];
    self.isActive           = [attributes[@"active"] boolValue];
    self.isAdmin            = [attributes[@"admin"] boolValue];
    self.firstTimeUser      = [attributes[@"firstTimeUser"] boolValue];
    self.addlAttributes     = [[NSMutableDictionary alloc] initWithDictionary:addlAttributes];
    NSString *wsProtocol    = NilToEmptyString(attributes[@"wsProto"]);
    NSString *wsPort        = NilToEmptyString(attributes[@"wsPort"]);
    NSString *wsHost        = NilToEmptyString(attributes[@"wsHost"]);
    if (wsHost.length <= 0) {
        wsHost = client.baseURL.host;
    }
    self.webSocketURLString = [NSString stringWithFormat:@"%@://%@:%@", wsProtocol, wsHost, wsPort];

    return self;
}

- (NSMutableArray *)convertToRepoRefs:(NSArray *)inputArray {
    NSMutableArray *linkedRepoMetaArray = [[NSMutableArray alloc] initWithCapacity:inputArray.count];
    for (id object in inputArray) {
        SHUserLinkedRepoMetadata *linkedRepoMeta = [SHUserLinkedRepoMetadata create:object];
        if (linkedRepoMeta) {
            [linkedRepoMetaArray addObject:linkedRepoMeta];
        }
    }
    return linkedRepoMetaArray;
}

- (NSMutableArray *)convertToAddressRefs:(NSArray *)inputArray {
    NSMutableArray *userAddresses = [[NSMutableArray alloc] initWithCapacity:inputArray.count];
    for (id object in inputArray) {
        SHUserAddress *userAddress = [SHUserAddress fromJSON:object];
        if (userAddress) {
            [userAddresses addObject:userAddress];
        }
    }
    return userAddresses;
}

- (NSMutableArray *)convertToClientInfoRefs:(NSArray *)inputArray {
    NSMutableArray *clientInfoArray = [[NSMutableArray alloc] initWithCapacity:inputArray.count];
    for (id object in inputArray) {
        SHClientInformation *clientInfo = [SHClientInformation fromJSON:object];
        if (clientInfo) {
            [clientInfoArray addObject:clientInfo];
        }
    }
    return clientInfoArray;
}

#pragma mark - APIs
#pragma mark - Authentication

+ (void)loginUserWithEmail:(NSString *)email password:(NSString *)password completionBlock:(void (^)(SHUser *, NSError *))completion {
    NSString *path = [baseAuthPathString stringByAppendingPathComponent:@"user"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"email"]    = email;
    parameters[@"password"] = [SHSecurityUtilities
                               saltAndHashPassword:password
                               forUserWithEmail:email];
    parameters[@"pass_hash"]= [SHSecurityUtilities
                               caseInsensitiveHashedPassword:password
                               forEmail:email];
    [[SHUbeAPIClient sharedClient] POST:path  parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"\n[%@ - %@] {\n\tHeaders:%@,\n\tJSON: %@,\n\tError:%@\n}", @"POST", path, [response allHeaderFields], responseObject, [task.error localizedDescription]);
        SHUser *user = [[SHUser alloc] initWithAttributes:responseObject];
        if (completion) completion(user, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"\n[%@ - %@] {\n\tJSON: %@,\n\tError:%@\n}", @"POST", path, task.response, [error localizedDescription]);
        if (completion) completion(nil, error);
    }];
}

+ (void)logoutUserWithCompletionBlock:(void (^)(BOOL, NSError *))completion {
    NSString *path = [baseUserPathString stringByAppendingPathComponent:@"logout"];
    [SHUser performUserPOSTWithURLPath:path parameters:nil completionBlock:completion];
}

+ (void)oauthAuthorizationUrlWithProviderInfo:(NSDictionary *)info completionBlock:(void (^)(NSURL *url, NSError *error))completion {
    
    NSString *provider = info[@"provider"];
    NSString *version  = info[@"version"];
    NSString *path = [baseOauthPathString stringByAppendingFormat:@"/%@/%@/authorizationUrl", provider, version];
    NSDictionary *parameters = @{@"platform" : @"IOS"};
    
    [[SHUbeAPIClient sharedClient] GET:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"\n[%@ - %@] {\n\tJSON: %@,\n\tError:%@\n}", @"GET", path, responseObject, [task.error localizedDescription]);
        NSURL *url = [NSURL URLWithString:NilToEmptyString(responseObject[@"url"])];
        completion(url, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"\n[%@ - %@] {\n\tJSON: %@,\n\tError:%@\n}", @"GET", path, task.response, [error localizedDescription]);
        completion(nil, error);
    }];
}

+ (void)oauthAuthenticateWithProviderInfo:(NSDictionary *)info completionBlock:(void(^)(SHUser *user, NSError *error))completion {
    
    NSString *provider  = info[@"provider"];
    NSString *version   = info[@"version"];
    NSString *code      = info[@"code"];
    NSString *path      = [baseOauthPathString stringByAppendingFormat:@"/%@/%@/auth", provider, version];
    NSDictionary *parameters = @{@"code": code, @"platform": @"IOS"};
    
    [[SHUbeAPIClient sharedClient] POST:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"\n[%@ - %@] {\n\tJSON: %@,\n\tError:%@\n}", @"POST", path, responseObject, [task.error localizedDescription]);
        SHUser *user = [[SHUser alloc] initWithAttributes:responseObject];
        completion(user, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"\n[%@ - %@] {\n\tJSON: %@,\n\tError:%@\n}", @"POST", path, task.response, [error localizedDescription]);
        completion(nil, error);
    }];
}

#pragma mark - User
+ (void)signUpUserWithEmail:(NSString *)email firstName:(NSString *)firstname lastName:(NSString *)lastname password:(NSString *)password completionBlock:(void (^)(BOOL, NSError *))completion {
    NSString        *hashedPassword = [SHSecurityUtilities saltAndHashPassword:password forUserWithEmail:email];
    NSDictionary    *params         = @{@"first_name" : firstname, @"last_name" : lastname, @"email" : email, @"encrypted_password" : hashedPassword};
    NSString        *path           = [baseUserPathString stringByAppendingPathComponent:@"signup"];
    [SHUser performUserPOSTWithURLPath:path parameters:params completionBlock:completion];
}

+ (void)getUserWithCompletionBlock:(void (^)(SHUser *, NSError *))completion {
    NSString *path = [baseUserPathString stringByAppendingPathComponent:@"me"];
    [SHUser performUserGETWithURLPath:path parameters:nil completionBlock:completion];
}

+ (void)updateUserInfo:(NSDictionary *)info completionBlock:(void (^)(SHUser *, NSError *))completion {
    [[SHUbeAPIClient sharedClient] PUT:baseUserPathString parameters:info success:^(NSURLSessionDataTask *task, id responseObject) {
        SHUser *user = [[SHUser alloc] initWithAttributes:responseObject];
        completion(user, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
}

+ (void)changePasswordForUserWithEmail:(NSString *)email password:(NSString *)password newPassword:(NSString *)newPassword completionBlock:(void (^)(BOOL, NSError *))completion {
    NSString        *hashedPassword     = [SHSecurityUtilities saltAndHashPassword:password forUserWithEmail:email];
    NSString        *hashedNewPassword  = [SHSecurityUtilities saltAndHashPassword:newPassword forUserWithEmail:email];
    NSDictionary    *params             = @{@"original_password" : hashedPassword, @"new_password" : hashedNewPassword};
    NSString        *path               = [baseUserPathString stringByAppendingPathComponent:@"password"];
    [[SHUbeAPIClient sharedClient] PUT:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"\n[%@ - %@] {\n\tJSON: %@,\n\tError:%@\n}", @"PUT", path, responseObject, [task.error localizedDescription]);
        completion(YES, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"\n[%@ - %@] {\n\tJSON: %@,\n\tError:%@\n}", @"PUT", path, task.response, [task.error localizedDescription]);
        completion(NO, error);
    }];
}

+ (void)resetPasswordForUserWithEmail:(NSString *)email completionBlock:(void (^)(BOOL, NSError *))completion {
    NSDictionary    *params = @{@"email" : email};
    NSString        *path   = [baseUserPathString stringByAppendingPathComponent:@"reset"];
    [SHUser performUserPOSTWithURLPath:path parameters:params completionBlock:completion];
}

+ (void)resendVerificationEmailForUserWithEmail:(NSString *)email completionBlock:(void (^)(BOOL, NSError *))completion {
    NSDictionary    *params = @{@"email" : email};
    NSString        *path   = [baseUserPathString stringByAppendingPathComponent:@"resendVerification"];
    [SHUser performUserPOSTWithURLPath:path parameters:params completionBlock:completion];
}

+ (void)getUnreadNotificationCountSinceTime:(long)time completionBlock:(void (^)(NSInteger, NSError *))completion {
    NSDictionary *parameter = @{@"start_time": @(time)};
    NSString          *path = @"/api/notifications/count";
    [[SHUbeAPIClient sharedClient] GET:path parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"\n[%@ - %@] {\n\tHeaders:%@,\n\tJSON: %@,\n\tError:%@\n}", @"POST", path, [response allHeaderFields], responseObject, [task.error localizedDescription]);
        NSInteger count = [responseObject[@"count"] integerValue];
        completion(count, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(0, error);
    }];
}

+ (void)initializeMobileClientInfoWithCompletion:(void(^)(NSDictionary *info, NSError *error))completion {
    
    SHUbeAPIClient *client = [SHUbeAPIClient sharedClient];
    
    NSString *path = @"/api/mobileClient/init";
    [client GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"\n[%@ - %@] {\n\tHeaders:%@,\n\tJSON: %@,\n\tError:%@\n}", @"POST", path, [response allHeaderFields], responseObject, [task.error localizedDescription]);
        NSString *wsURLString = @"";
        NSString *wsProtocol  = NilToEmptyString(responseObject[@"wsProto"]);
        NSString *wsPort      = NilToEmptyString(responseObject[@"wsPort"]);
        NSString *wsHost      = NilToEmptyString(responseObject[@"wsHost"]);
        if (wsHost.length <= 0) {
            wsHost = client.baseURL.host;
        }
        wsURLString = [NSString stringWithFormat:@"%@://%@:%@", wsProtocol, wsHost, wsPort];
        NSInteger unreadNotificationCount = [responseObject[@"numUnreadNotifications"] integerValue];
        NSArray *supportedUploadFileTypes = [NilToEmptyString(responseObject[@"supportedUploadFileTypes"]) componentsSeparatedByString:@","];
        NSDictionary *info = @{@"webSocketURLString": wsURLString, @"numUnreadNotifications": @(unreadNotificationCount), @"supportedUploadFileTypes" : supportedUploadFileTypes};
        completion(info, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
}

#pragma mark -
+ (void)performUserPOSTWithURLPath:(NSString *)path parameters:(NSDictionary *)parameters completionBlock:(void(^)(BOOL success, NSError *error))completion {
    [[SHUbeAPIClient sharedClient] POST:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"\n[%@ - %@] {\n\tJSON: %@,\n\tError:%@\n}", @"POST", path, responseObject, [task.error localizedDescription]);
        completion(YES, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"\n[%@ - %@] {\n\tJSON: %@,\n\tError:%@\n}", @"POST", path, task.response, [task.error localizedDescription]);
        completion(NO, error);
    }];
}

+ (void)performUserGETWithURLPath:(NSString *)path parameters:(NSDictionary *)parameters completionBlock:(void(^)(SHUser *user, NSError *error))completion {
    [[SHUbeAPIClient sharedClient] GET:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"\n[%@ - %@] {\n\tJSON: %@,\n\tError:%@\n}", @"GET", path, responseObject, [task.error localizedDescription]);
        SHUser *user = [[SHUser alloc] initWithAttributes:responseObject];
        completion(user, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"\n[%@ - %@] {\n\tJSON: %@,\n\tError:%@\n}", @"GET", path, task.response, [task.error localizedDescription]);
        completion(nil, error);
    }];
}
@end
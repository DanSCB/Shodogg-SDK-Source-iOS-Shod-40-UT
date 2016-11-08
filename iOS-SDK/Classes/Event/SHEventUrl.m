//
//  SHEventUrl.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 10/4/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import "SHEventUrl.h"
#import "SHUbeAPIClient.h"
#import "SHScreenSesssion.h"
#import "SHUtilities.h"

static NSString *baseEventPathString = @"/api/eventUrl";

@implementation SHEventUrl

- (instancetype)initWithAttributes:(id)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }

    self.Id                 = NilToEmptyString(attributes[@"id"]);
    self.userId             = NilToEmptyString(attributes[@"userId"]);
    self.name               = NilToEmptyString(attributes[@"name"]);
    self.uriPath            = NilToEmptyString(attributes[@"uriPath"]);
    self.deleted            = [attributes[@"deleted"] boolValue];
    self.createdAt          = NilToEmptyString(attributes[@"createdAt"]);
    self.updatedAt          = NilToEmptyString(attributes[@"updatedAt"]);
    self.addlAttributes     = JSONToDictionaryOrEmpty(attributes[@"attributes"]);
    self.screenSessionId    = NilToEmptyString(attributes[@"screenSessionId"]);
    
    return self;
}

- (NSString *)absoluteURLString {
    return [NSString stringWithFormat:@"%@/event/%@", [SHUbeAPIClient sharedClient].baseURL, self.uriPath];
}

#pragma mark - APIs

+ (void)getUserEventURLsWithCompletionBlock:(void (^)(NSArray *, NSError *))completion
{
    [[SHUbeAPIClient sharedClient] GET:baseEventPathString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray         *allEventUrls   = (NSArray *)JSONToArrayOrEmpty([responseObject allObjects]);
        NSMutableArray  *eventUrlsArray = [[NSMutableArray alloc] initWithCapacity:allEventUrls.count];
        [allEventUrls enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SHEventUrl *eventUrl = [[SHEventUrl alloc] initWithAttributes:obj];
            if (eventUrl) {
                [eventUrlsArray addObject:eventUrl];
            }
        }];
        completion(eventUrlsArray, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
}

+ (void)connectEventURLWithId:(NSString *)eventId enableLock:(BOOL)lock completionBlock:(void (^)(NSDictionary *, NSError *))completion
{
    SHUbeAPIClient *client = [SHUbeAPIClient sharedClient];
    NSString        *pathString     = [baseEventPathString stringByAppendingFormat:@"/%@/sync", eventId];
    NSDictionary    *params         = @{@"lockSession" : @(lock)};
    [[SHUbeAPIClient sharedClient] POST:pathString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%s - Response: {\n%@ }\nError: {\n%@\n}", __PRETTY_FUNCTION__, responseObject, [task.error localizedDescription]);
        NSString *webSocketProtocol = NilToEmptyString(responseObject[@"webSocketProtocol"]);
        NSString *webSocketPort     = NilToEmptyString(responseObject[@"webSocketPort"]);
        NSString *webSocketHost     = NilToEmptyString(responseObject[@"webSocketHost"]);
        if (webSocketHost.length <= 0) {
            webSocketHost = client.baseURL.host;
        }
        NSString    *webSocketUrlString = [NSString stringWithFormat:@"%@://%@:%@", webSocketProtocol, webSocketHost, webSocketPort];
        id                  sessionJson = responseObject[@"screenSessionDTO"];
        SHScreenSesssion    *session    = [SHScreenSesssion fromJSON:sessionJson];
        NSDictionary        *contents   = @{@"session" : session, @"websocketURLString" : webSocketUrlString};
        completion(contents, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%s - Error:%@", __PRETTY_FUNCTION__, [error localizedDescription]);
        completion(nil, error);
    }];
}

+ (void)disconnectEventURLWithId:(NSString *)eventId completionBlock:(void (^)(BOOL, NSError *))completion
{
    NSString    *pathString = [baseEventPathString stringByAppendingFormat:@"/%@/sync", eventId];
    [[SHUbeAPIClient sharedClient] DELETE:pathString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SHScreenSesssion removeCurrentScreenSessionId];
        completion(YES, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(NO, error);
    }];
}

- (void)startConnectionWithCompletionBlock:(void (^)(NSDictionary *, NSError *))completion {
    [SHEventUrl connectEventURLWithId:self.Id enableLock:NO completionBlock:completion];
}

- (void)startSecureConnectionWithCompletionBlock:(void (^)(NSDictionary *, NSError *))completion {
    [SHEventUrl connectEventURLWithId:self.Id enableLock:YES completionBlock:completion];
}

- (void)disconnectWithCompletionBlock:(void (^)(NSError *))completion {
    [SHEventUrl disconnectEventURLWithId:self.Id completionBlock:^(BOOL success, NSError *error) {
        completion(error);
    }];
}
@end
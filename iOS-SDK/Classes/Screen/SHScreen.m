//
//  SHScreen.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 10/3/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import "SHScreen.h"
#import "SHMobileCommand.h"
#import "SHScreenAssetState.h"
#import "SHScreenSesssion.h"
#import "SHRemoteRefToAsset.h"
#import "SHUbeAPIClient.h"
#import "RequestUtils.h"

static NSString *baseScreenPathString           = @"/api/screen";
static NSString *baseScreenSessionPathString    = @"/api/screenSession";

@implementation SHScreen

BOOL SHScreenStatusIsStringValid(NSString *name) {
    if (!name) {
        return NO;
    }
    static NSSet* set = nil;
    if (set == nil) {
        set = [NSSet setWithArray:SHScreenStatusAllNames()];
    }
    return [set containsObject:name];
}

NSString *SHScreenStatusAsString(SHScreenStatus screenStatus) {
    if (screenStatus < [SHScreenStatusAllNames() count]) {
        return [SHAssetStateAllNames() objectAtIndex:screenStatus];
    }
    [NSException raise:NSGenericException format:@"SHUtitilies: Unexpected assetState(%ld).", (long)screenStatus];
    return @"";
}

SHScreenStatus SHScreenStatusFromString(NSString* name) {
    return (SHScreenStatus)[SHScreenStatusAllNames() indexOfObject:name];
}

NSArray *SHScreenStatusAllNames() {
    static NSArray *statusNames = nil;
    if (statusNames == nil) {
        statusNames = kSHScreenStatusNames;
    }
    return statusNames;
}

- (instancetype)initWithAttributes:(id)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.Id                 = NilToEmptyString(attributes[@"id"]);
    self.screenId           = NilToEmptyString(attributes[@"screenId"]);
    self.screenSessionId    = NilToEmptyString(attributes[@"screenSessionId"]);
    self.userId             = NilToEmptyString(attributes[@"userId"]);
    self.eventId            = NilToEmptyString(attributes[@"eventId"]);
    self.syncCode           = NilToEmptyString(attributes[@"syncCode"]);
    self.username           = NilToEmptyString(attributes[@"userName"]);
    self.createdAt          = NilToEmptyString(attributes[@"createdAt"]);
    self.updatedAt          = NilToEmptyString(attributes[@"updatedAt"]);
    self.addlAttributes     = JSONToDictionaryOrEmpty(attributes[@"attrs"]);
    self.currentAssetsState = [self convertStateRefs:JSONToArrayOrEmpty(attributes[@"currentAssetsState"])];
    self.active             = [attributes[@"active"] boolValue];
    self.status             = SHScreenStatusFromString([attributes[@"status"] lowercaseString]);
    
    return self;
}

- (NSArray *)convertStateRefs:(NSArray *)stateRefsArray {
    if (!stateRefsArray || [stateRefsArray count] == 0) {
        return nil;
    }

    NSMutableArray *states = [[NSMutableArray alloc] initWithCapacity:[stateRefsArray count]];
    for (id object in stateRefsArray) {
        SHScreenAssetState *state = [SHScreenAssetState fromJSON:object];
        if (state) {
            [states addObject:state];
        }
    }
    
    NSArray *result = [[NSArray alloc] initWithArray:states];
    return result;
}

#pragma mark - APIs

+ (void)performRequestWithMethod:(NSString *)method
                urlPathComponent:(NSString *)pathComponent
                      parameters:(NSDictionary *)parameters
                 completionBlock:(void(^)(BOOL success, NSError *error))completion {
    [[SHUbeAPIClient sharedClient]
         performRequestWithMethod:method
                    pathComponent:pathComponent
                        parameters:parameters
                    completionBlock:^(NSURLResponse *response, id responseObject, NSError *error) {
                        NSLog(@"\n[%@ - %@] {\n\tJSON: %@,\n\tError:%@\n}",
                                method, pathComponent, responseObject, [error localizedDescription]);
                        if (error) {
                            if (completion) completion(NO, error);
                        } else {
                            if (completion) completion(YES, error);
                        }
                    }];
}

+ (void)connectScreenWithCode:(NSString *)code completionBlock:(void (^)(id, NSError *))completion {
    NSString *pathComponent  = [baseScreenPathString stringByAppendingFormat:@"/sync/%@", code];
    [[SHUbeAPIClient sharedClient]
        performRequestWithMethod:@"POST"
                   pathComponent:pathComponent
                      parameters:nil
                 completionBlock:^(NSURLResponse *response, id responseObject, NSError *error) {
                     if (completion) completion(responseObject, error);
                 }];
}

+ (void)disconnectScreenWithCode:(NSString *)code completionBlock:(void (^)(BOOL, NSError *))completion {
    NSString    *pathComponent  = [baseScreenPathString stringByAppendingFormat:@"/sync/%@", code];
    [SHScreen performRequestWithMethod:@"DELETE" urlPathComponent:pathComponent parameters:nil completionBlock:completion];
}

+ (void)autoConnectWithCompletionBlock:(void (^)(NSDictionary *, NSError *))completion {
    NSString *urlPathString = [baseScreenPathString stringByAppendingPathComponent:@"autosync"];
    [[SHUbeAPIClient sharedClient] POST:urlPathString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if (completion) completion(result, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion) completion(nil, error);
    }];
}

+ (void)checkScreenSessionExitsForMID:(NSString *)mid withCompletionBlock:(void (^)(NSURL *, NSError *))completion {
    NSString *sessionId = [SHScreenSesssion getCurrentScreenSessionId];
    [[self class] getScreenSessionWithId:sessionId completionBlock:^(SHScreenSesssion *screenSession, NSError *error) {
        NSURL *screenUrl;
        BOOL valid = screenSession.active && [screenSession.userId isEqual:mid];
        if (valid) {
            screenUrl = [SHScreenSesssion generateCurrentScreenSessionURL];
        }
        if (completion) {
            completion(screenUrl, error);
        }
    }];
}

+ (void)checkScreenSessionExistsForUSTId:(NSString *)ustId withCompletionBlock:(void (^)(NSURL *, NSError *))completion {
    NSString *sessionId = [SHScreenSesssion getCurrentScreenSessionId];
    [[self class] getScreenSessionWithId:sessionId completionBlock:^(SHScreenSesssion *screenSession, NSError *error) {
        NSURL *screenUrl;
        BOOL valid = screenSession.active && [screenSession.unauthorizedSessionTokenIds containsObject:ustId];
        if (valid) {
            screenUrl = [SHScreenSesssion generateCurrentScreenSessionURL];
        }
        if (completion) {
            completion(screenUrl, error);
        }
    }];
}

+ (void)getPresyncedScreenUrlWithCompletionBlock:(void (^)(NSDictionary *result, NSError *error))completion {
    NSString *preSyncEndpoint = @"/api/mid/screenSession/presync";
    [[SHUbeAPIClient sharedClient] performRequestWithMethod:@"POST" pathComponent:preSyncEndpoint parameters:nil completionBlock:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSDictionary *result = (NSDictionary *)responseObject;
        NSString *screenSessionId = NilToEmptyString(result[@"screenSessionId"]);
        if (screenSessionId) {
            [SHScreenSesssion saveCurrentScreenSessionId:screenSessionId];
        }
        if (completion) {
            completion(result, error);
        }
    }];
}

+ (void)disconnectWithCompletionBlock:(void (^)(NSError *))completion {
    NSString *currentScreenSessionId = [SHScreenSesssion getCurrentScreenSessionId];
    [[self class] deleteScreenSessionWithId:currentScreenSessionId completionBlock:^(BOOL success, NSError *error) {
        [SHScreenSesssion removeCurrentScreenSessionId];
        if (completion) {
            completion(error);
        }
    }];
}

+ (void)getScreenSessionWithId:(NSString *)sessionId completionBlock:(void (^)(SHScreenSesssion *, NSError *))completion {
    NSString *urlPathString = [NSString stringWithFormat:@"/api/screenSession/%@", sessionId];
    [[SHUbeAPIClient sharedClient] GET:urlPathString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"\n[%@ - %@] {\n\tJSON: %@,\n\tError:%@\n}", @"GET", urlPathString, responseObject, task.error);
        SHScreenSesssion *session = [SHScreenSesssion fromJSON:responseObject];
        if (completion) completion(session, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"\n[%@ - %@] {\n\tJSON: %@,\n\tError:%@\n}", @"GET", urlPathString, task.response, error);
        if (completion) completion(nil, error);
    }];
}

+ (void)deleteScreenSessionWithId:(NSString *)sessionId completionBlock:(void (^)(BOOL, NSError *))completion {
    NSString *path = [baseScreenSessionPathString stringByAppendingPathComponent:sessionId];
    [SHScreen performRequestWithMethod:@"DELETE" urlPathComponent:path parameters:nil completionBlock:completion];
}

+ (void)screenSession:(NSString *)sessionId enableLock:(BOOL)lock completionBlock:(void (^)(NSDictionary *, NSError *))completion {
    NSString        *pathComponent  = [baseScreenSessionPathString stringByAppendingFormat:@"/%@/lock", sessionId];
    NSDictionary    *params         = @{@"locked" : @(lock)};
    [[SHUbeAPIClient sharedClient] PUT:pathComponent parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *contents = (NSDictionary *)responseObject;
        if (completion) completion(contents, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion) completion(nil, error);
    }];
}

+ (void)screenSession:(NSString *)sessionId acceptJoinRequestWithValue:(BOOL)value screenWithId:(NSString *)screenId completionBlock:(void (^)(BOOL, NSError *))completion {
    NSString        *pathComponent  = [baseScreenSessionPathString stringByAppendingFormat:@"/%@/screen/%@/accept", sessionId, screenId];
    NSDictionary    *params         = @{@"accept" : @(value)};
    [[SHUbeAPIClient sharedClient] PUT:pathComponent parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (completion) completion(YES, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion) completion(NO, error);
    }];
}

+ (void)screenSession:(NSString *)sessionId removeScreenWithId:(NSString *)screenId completionBlock:(void (^)(BOOL, NSError *))completion {
    NSString    *pathComponent  = [baseScreenSessionPathString stringByAppendingFormat:@"/%@/screen/%@", sessionId, screenId];
    [SHScreen performRequestWithMethod:@"DELETE" urlPathComponent:pathComponent parameters:nil completionBlock:completion];
}

#pragma mark - 
#pragma mark - Screen Command

+ (void)screenSession:(NSString *)sessionId sendCommandWithParameters:(NSDictionary *)params completionBlock:(void(^)(BOOL success, NSError *error))completion {
    NSString *path = [baseScreenPathString stringByAppendingPathComponent:sessionId];
    NSLog(@"\n[%@ - %@] {\n\tCommand: %@\n}", @"PUT", path, params);
    [SHScreen performRequestWithMethod:@"PUT" urlPathComponent:path parameters:params completionBlock:completion];
}

#pragma mark - YouTube

+ (void)youtubeCommandPlayWithURL:(NSString *)url completionBlock:(void (^)(BOOL, NSError *))block {
    [[self class] sendYoutubeCommandWithURL:url
                                 assetState:SHAssetStatePlay
                                 attributes:nil
                            completionBlock:block];
}

+ (void)youtubeCommandPauseWithURL:(NSString *)url completionBlock:(void (^)(BOOL, NSError *))block {
    [[self class] sendYoutubeCommandWithURL:url
                                 assetState:SHAssetStatePause
                                 attributes:nil
                            completionBlock:block];
}

//seek by passed seek value "+ve" >> and "-ve" for <<
+ (void)youtubeCommandSeekWithURL:(NSString *)url seek:(NSNumber *)seekBySeconds completionBlock:(void (^)(BOOL, NSError *))block {
    [[self class ] sendYoutubeCommandWithURL:url
                                  assetState:SHAssetStateSeek
                                  attributes:@{@"seek": seekBySeconds}
                             completionBlock:block];
}

//0(for mute) - 100
+ (void)youtubeCommandVolumeWithURL:(NSString *)url volume:(NSInteger)volumeLevel completionBlock:(void (^)(BOOL, NSError *))block {
    [[self class] sendYoutubeCommandWithURL:url
                                 assetState:SHAssetStateVolume
                                 attributes:@{@"volume": @(volumeLevel)}
                            completionBlock:block];
}

+ (void)sendYoutubeCommandWithURL:(NSString *)url
                       assetState:(SHAssetState)assetState
                       attributes:(NSDictionary *)attributes
                  completionBlock:(void (^)(BOOL success, NSError *error))block {
    NSDictionary *queryParams = [url URLQueryParameters];
    NSString *youtubeKey = queryParams[@"v"];
    NSMutableDictionary *attrs;
    if (attributes) {
        attrs = [[NSMutableDictionary alloc] initWithDictionary:attributes];
    } else {
        attrs = [[NSMutableDictionary alloc] init];
    }
    attrs[@"youtubeKey"] = youtubeKey;
    NSString *currentScreenSessionId = [SHScreenSesssion getCurrentScreenSessionId];
    SHScreenAssetState *state = [SHScreenAssetState forState:assetState type:SHAssetTypeVideo attributes:attrs];
    NSDictionary *commandDictionary = [SHMobileCommand commandAsDictionaryForScreenAssetStates:@[[state toDictionary]]];
    [[self class] screenSession:currentScreenSessionId sendCommandWithParameters:commandDictionary completionBlock:block];
}

#pragma mark - Video

+ (void)videoCommandPlayWithURL:(NSString *)url completionBlock:(void (^)(BOOL, NSError *))block {
    [[self class] sendVideoCommandWithURL:url
                               assetState:SHAssetStatePlay
                               attributes:nil
                          completionBlock:block];
}

+ (void)videoCommandPauseWithURL:(NSString *)url completionBlock:(void (^)(BOOL, NSError *))block {
    [[self class] sendVideoCommandWithURL:url
                               assetState:SHAssetStatePause
                               attributes:nil
                          completionBlock:block];
}

//seek by passed seek value "+ve" >> and "-ve" for <<
+ (void)videoCommandSeekWithURL:(NSString *)url seekBySeconds:(NSNumber *)seekValue completionBlock:(void (^)(BOOL, NSError *))block {
    [[self class] sendVideoCommandWithURL:url
                               assetState:SHAssetStateSeek
                               attributes:@{@"seek": seekValue}
                          completionBlock:block];
}

+ (void)videoCommandSeekWithURL:(NSString *)url seekToSeconds:(NSNumber *)seekValue completionBlock:(void (^)(BOOL, NSError *))block {
    [[self class] sendVideoCommandWithURL:url
                               assetState:SHAssetStateSeek
                               attributes:@{@"seekTo": seekValue}
                          completionBlock:block];
}

//0(for mute) - 100
+ (void)videoCommandVolumeWithURL:(NSString *)url volume:(NSInteger)volumeLevel completionBlock:(void (^)(BOOL, NSError *))block {
    [[self class] sendVideoCommandWithURL:url
                               assetState:SHAssetStateVolume
                               attributes:@{@"volume": @(volumeLevel)}
                          completionBlock:block];
}

+ (void)sendVideoCommandWithURL:(NSString *)url
                     assetState:(SHAssetState)assetState
                     attributes:(NSDictionary *)attributes
                completionBlock:(void (^)(BOOL success, NSError *error))block {
    NSMutableDictionary *attrs;
    if (attributes) {
        attrs = [[NSMutableDictionary alloc] initWithDictionary:attributes];
    } else {
        attrs = [[NSMutableDictionary alloc] init];
    }
    attrs[@"url"] = url;
    NSString *currentScreenSessionId = [SHScreenSesssion getCurrentScreenSessionId];
    SHScreenAssetState *state = [SHScreenAssetState forState:assetState type:SHAssetTypeVideo attributes:attrs];
    NSDictionary *commandDictionary = [SHMobileCommand commandAsDictionaryForScreenAssetStates:@[[state toDictionary]]];
    [[self class] screenSession:currentScreenSessionId sendCommandWithParameters:commandDictionary completionBlock:block];
}

#pragma mark - Document

+ (void)tossAssetPageWithAssetId:(NSString *)assetId page:(NSNumber *)pageNumber completionBlock:(void (^)(BOOL, NSError *))block {
    [[self class] sendAssetCommandWithAssetId:assetId
                                   assetState:SHAssetStatePlay
                                   attributes:@{@"page": pageNumber}
                              completionBlock:block];
}

#pragma mark - Image

+ (void)tossImageWithURL:(NSString *)url completionBlock:(void (^)(BOOL, NSError *))block {
    NSString *currentScreenSessionId = [SHScreenSesssion getCurrentScreenSessionId];
    SHScreenAssetState *state = [SHScreenAssetState forState:SHAssetStatePlay type:SHAssetTypeImage attributes:@{@"url": url}];
    NSDictionary *command = [SHMobileCommand commandAsDictionaryForScreenAssetStates:@[[state toDictionary]]];
    [[self class] screenSession:currentScreenSessionId sendCommandWithParameters:command completionBlock:block];
}

#pragma mark - Asset

+ (void)sendAssetCommandWithAssetId:(NSString *)assetId
                         assetState:(SHAssetState)assetState
                         attributes:(NSDictionary *)attributes
                    completionBlock:(void (^)(BOOL success, NSError *error))block {
    NSString *currentScreenSessionId = [SHScreenSesssion getCurrentScreenSessionId];
    SHScreenAssetState *state = [SHScreenAssetState forState:assetState assetId:assetId attributes:attributes];
    NSDictionary *command = [SHMobileCommand commandAsDictionaryForScreenAssetStates:@[[state toDictionary]]];
    [[self class] screenSession:currentScreenSessionId sendCommandWithParameters:command completionBlock:block];
}

@end
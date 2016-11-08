//
//  SHScreenSesssion.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 10/3/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import "SHScreenSesssion.h"
#import "SHMobileCommand.h"
#import "SHScreen.h"
#import "SHUtilities.h"
#import "SHUbeAPIClient.h"

static NSString *const kCurrentScreenSessionIdKey = @"CurrentScreenSessionIdKey";

@implementation SHScreenSesssion
+ (SHScreenSesssion *)fromJSON:(id)JSON {
    SHScreenSesssion *screenSession = [[SHScreenSesssion alloc] init];
    screenSession.Id = NilToEmptyString(JSON[@"id"]);
    [SHScreenSesssion saveCurrentScreenSessionId:screenSession.Id];
    [screenSession setUserId:NilToEmptyString(JSON[@"userId"])];
    [screenSession setActive:[JSON[@"active"] boolValue]];
    [screenSession setLocked:[JSON[@"locked"] boolValue]];
    [screenSession setCreatedAt:JSON[@"createdAt"]];
    [screenSession setUpdatedAt:JSON[@"updatedAt"]];
    [screenSession setAttributes:JSONToDictionaryOrEmpty(JSON[@"attrs"])];
    [screenSession setScreens:[SHScreenSesssion convertScreenRefs:JSONToArrayOrEmpty(JSON[@"screens"])]];
    [screenSession setActiveScreens:[SHScreenSesssion convertScreenRefs:JSONToArrayOrEmpty(JSON[@"activeScreens"])]];
    [screenSession setUnauthorizedSessionTokenIds:JSONToArrayOrEmpty(JSON[@"unauthorizedSessionTokenIds"])];
    //last command sent to the session screens
    id lastCommand = JSON[@"lastCommand"];
    BOOL isNull = lastCommand == [NSNull null];
    BOOL isNil = lastCommand == nil;
    if (!isNull && !isNil) {
        [screenSession setLastCommand:[SHMobileCommand fromJSON:lastCommand]];
    }
    return screenSession;
}

+ (NSArray *)convertScreenRefs:(NSArray *)screenRefs {
    if (!screenRefs || [screenRefs count] == 0) {
        return nil;
    }
    NSMutableArray *screens = [[NSMutableArray alloc] initWithCapacity:[screenRefs count]];
    for (id object in screenRefs) {
        SHScreen *screen = [[SHScreen alloc] initWithAttributes:object];
        if (screen) {
            [screens addObject:screen];
        }
    }
    NSArray *result = [[NSArray alloc] initWithArray:screens];
    return result;
}

+ (NSURL *)generateCurrentScreenSessionURL {
    SHUbeAPIClient *client = [SHUbeAPIClient sharedClient];
    NSString *sessionId = [[self class] getCurrentScreenSessionId];
    NSString *screenURLString = [NSString stringWithFormat:@"%@/watch/%@", client.baseURL.absoluteString, sessionId];
    return [NSURL URLWithString:screenURLString];
}

#pragma mark - 

+ (void)saveCurrentScreenSessionId:(NSString *)sessionId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:sessionId forKey:kCurrentScreenSessionIdKey];
    [defaults synchronize];
}

+ (NSString *)getCurrentScreenSessionId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:kCurrentScreenSessionIdKey];
}

+ (void)removeCurrentScreenSessionId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kCurrentScreenSessionIdKey];
    [defaults synchronize];
}

@end
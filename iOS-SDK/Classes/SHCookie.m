//
//  SHCookie.m
//  Pods
//
//  Created by Aamir Khan on 12/2/15.
//
//

#import "SHCookie.h"
#import "SHUbeAPIClient.h"

NSString* const kSessionTokenCookieName  = @"session_token";
NSString* const kUMSCookieName           = @"ums";
NSString* const kOAuthProviderCookieName = @"current_oauth_provider";

@implementation SHCookie

+ (SHCookie *)cookieWithProperties:(NSDictionary *)properties {
    return [[self alloc] initWithProperties:properties];
}

- (instancetype)initWithProperties:(NSDictionary *)properties {
    if (self = [super init]) {
        self.name = properties[@"Name"];
        self.value = properties[@"Value"];
        self.domain = properties[@"Domain"];
        self.path = properties[@"Path"];
        self.expiresDate = properties[@"Expires"];
        self.created = properties[@"Created"];
        self.guid = properties[@"Guid"];
    }
    return self;
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *tokenAsDictionary = [[NSMutableDictionary alloc] init];
    tokenAsDictionary[@"Name"] = self.name;
    tokenAsDictionary[@"Value"] = self.value;
    tokenAsDictionary[@"Domain"] = self.domain;
    tokenAsDictionary[@"Path"] = self.path;
    tokenAsDictionary[@"Expires"] = self.expiresDate;
    tokenAsDictionary[@"Created"] = self.created;
    if ([self.name isEqual:kSessionTokenCookieName]) {
        tokenAsDictionary[@"Guid"] = self.guid;
    }
    return tokenAsDictionary;
}

- (BOOL)hasExpired {
    NSDate *dateAsNow = [NSDate date];
    BOOL isExpired = !([dateAsNow compare:self.expiresDate] == NSOrderedAscending);
    return isExpired;
}

- (void)saveToLocalStorage {
    [[NSUserDefaults standardUserDefaults] setObject:[self toDictionary] forKey:kSessionTokenCookieName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeFromLocalStorage {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSessionTokenCookieName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
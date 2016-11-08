//
//  SHCookieStore.m
//  Pods
//
//  Created by Aamir Khan on 12/2/15.
//
//

#import "SHCookieStore.h"
#import "SHUbeAPIClient.h"

extern NSString* kUMSCookieName;
extern NSString* kSessionTokenCookieName;
extern NSString* kOAuthProviderCookieName;
NSString *const kLastSavedUMSCookieValue = @"LastSavedUMSCookieValue";

@implementation SHCookieStore

+ (SHCookieStore *)sharedCookieStore {
    static SHCookieStore *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[SHCookieStore alloc] init];
    });
    return _instance;
}

+ (NSHTTPCookie *)getCookieWithName:(NSString *)name domain:(NSString *)domain {
    __block NSHTTPCookie *result;
    NSHTTPCookieStorage *cookieStore = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStore cookies];
    [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie *cookie, NSUInteger idx, BOOL *stop) {
        if ([cookie.domain isEqualToString:domain]
            && [cookie.name isEqualToString:name]) {
            NSLog(@"Found cookie with name: %@, value: %@, domain: %@, expiresDate: %@",
                      cookie.name, cookie.value, cookie.domain, cookie.expiresDate);
            result = cookie;
            *stop = YES;
        }
    }];
    return result;
}

+ (NSString *)UBEDomainHost {
    return [[SHUbeAPIClient sharedClient] baseURL].host;
}

#pragma mark - Session Token Cookie

- (BOOL)hasSessionToken {
    return (self.sessionToken != nil);
}

- (SHCookie *)sessionToken {
    NSString *domain = [[self class] UBEDomainHost];
    NSHTTPCookie *cookie = [[self class] getCookieWithName:kSessionTokenCookieName domain:domain];
    if (cookie) {
        SHCookie *sessionToken = [SHCookie cookieWithProperties:cookie.properties];
        NSString *guidForLastLoggedUser = [self getGuidOfLocallyStoredSession];
        sessionToken.guid = guidForLastLoggedUser;
        return sessionToken;
    }
    return nil;
}

- (BOOL)resumeSession {
    if ([self hasSessionToken]) {
        NSLog(@"UBE session exits. Checking if session is expired.");
        SHCookie *session = self.sessionToken;
        if (![session hasExpired]) {
            NSLog(@"UBE session has not expired. Expires at: %@", session.expiresDate);
            return YES;
        }
    }
    return NO;
}

- (void)saveCurrentSessionAndGUID:(NSString *)guid {
    SHCookie *session = self.sessionToken;
    if (session && ![session hasExpired]) {
        session.guid = guid;
        [session saveToLocalStorage];
    }
}

- (NSString *)getGuidOfLocallyStoredSession {
    NSDictionary *tokenDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:kSessionTokenCookieName];
    if (tokenDictionary && [tokenDictionary count]) {
        SHCookie *savedSession = [SHCookie cookieWithProperties:tokenDictionary];
        if (![savedSession hasExpired]) {
            return savedSession.guid;
        }
        [savedSession removeFromLocalStorage];
    }
    return nil;
}

- (void)clearSession {
    //Delete session_token cookie from the CookieStore
    NSString *host = [[self class] UBEDomainHost];
    NSHTTPCookie *session = [[self class] getCookieWithName:kSessionTokenCookieName domain:host];
    if (session) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:session];
    }
}

- (void)clearAllCookiesForHost:(NSString *)host {
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:host]];
    [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie *cookie, NSUInteger idx, BOOL * _Nonnull stop) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }];
}

#pragma mark - UMS Cookie

- (BOOL)umsCookieExists {
    return (self.umsCookie !=nil);
}

- (BOOL)umsCookieExpired {
    SHCookie *umsCookie = [self umsCookie];
    if (umsCookie && [umsCookie hasExpired]) {
        NSLog(@"ums cookie exists. Expired at: %@", umsCookie.expiresDate);
        return YES;
    }
    return NO;
}

- (SHCookie *)umsCookie {
    SHCookie *umsCookie;
    NSString *domain = [[self class] UBEDomainHost];
    NSHTTPCookie *cookie = [[self class] getCookieWithName:kUMSCookieName domain:domain];
    if (cookie) {
        umsCookie = [SHCookie cookieWithProperties:cookie.properties];
    }
    return umsCookie;
}

#pragma mark - Previous UMS

- (NSString *)getLastSavedUMSCookieValue {
    return [self getValueForKey:kLastSavedUMSCookieValue];
}

- (void)saveCurrentUMSCookieValue {
    [self saveValue:[self umsCookie].value forKey:kLastSavedUMSCookieValue];
}

- (void)removeLastSavedUMSCookieValue {
    [self removeValueForKey:kLastSavedUMSCookieValue];
}

#pragma mark - NSUserDefaults Convenience

- (void)saveValue:(NSString *)value forKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

- (NSString *)getValueForKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}

- (void)removeValueForKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

@end
//
//  SHCookieStore.h
//  Pods
//
//  Created by Aamir Khan on 12/2/15.
//
//

#import <Foundation/Foundation.h>
#import "SHCookie.h"

@interface SHCookieStore : NSObject
+ (SHCookieStore *)sharedCookieStore;
- (BOOL)hasSessionToken;
- (SHCookie *)sessionToken;
- (BOOL)resumeSession;
- (void)saveCurrentSessionAndGUID:(NSString *)guid;
- (void)clearSession;
- (void)clearAllCookiesForHost:(NSString *)host;
- (SHCookie *)umsCookie;
- (BOOL)umsCookieExists;
- (BOOL)umsCookieExpired;
- (void)saveValue:(NSString *)value forKey:(NSString *)key;
- (NSString *)getValueForKey:(NSString *)key;
- (void)removeValueForKey:(NSString *)key;
- (NSString *)getLastSavedUMSCookieValue;
- (void)saveCurrentUMSCookieValue;
- (void)removeLastSavedUMSCookieValue;
@end
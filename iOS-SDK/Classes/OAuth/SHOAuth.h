//
//  SHOAuth.h
//  ShodoggAPIKit
//
//  Created by Aamir Khan on 10/30/15.
//
//

#import <Foundation/Foundation.h>
#import "SHUser.h"

@interface SHOAuth : NSObject

+ (void)fetchAuthorizationURLWithQueryParameters:(NSDictionary *)parameters completionBlock:(void (^)(NSURL *url, NSError *error))block;

+ (void)authenticateWithProviderInfo:(NSDictionary *)info completionBlock:(void(^)(SHUser *user, NSError *error))block;

@end

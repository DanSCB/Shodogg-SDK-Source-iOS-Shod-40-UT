//
//  SHUser.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 9/16/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SHAppVersionCheckOperationResult;

@interface SHUser : NSObject

@property (nonatomic,   copy) NSString              *Id;
@property (nonatomic,   copy) NSString              *email;
@property (nonatomic,   copy) NSString              *firstName;
@property (nonatomic,   copy) NSString              *lastName;
@property (nonatomic,   copy) NSString              *title;
@property (nonatomic,   copy) NSString              *lastLoginTime;
@property (nonatomic,   copy) NSString              *eventUrlId;
@property (nonatomic,   copy) NSString              *screenSessionId;
@property (nonatomic,   copy) NSString              *webSocketURLString;
@property (nonatomic, strong) NSMutableArray        *repoMetadata;
@property (nonatomic, strong) NSMutableArray        *userAddresses;
@property (nonatomic, strong) NSMutableArray        *clientInformation;
@property (nonatomic, strong) NSMutableDictionary   *addlAttributes;
@property (nonatomic, assign) BOOL                  isActive;
@property (nonatomic, assign) BOOL                  isAdmin;
@property (nonatomic, assign) BOOL                  firstTimeUser;
@property (nonatomic,   copy) NSString              *currentUserAuthToken;

- (instancetype)initWithAttributes:(id)attributes;

+ (void)loginUserWithEmail:(NSString *)email password:(NSString *)password completionBlock:(void(^)(SHUser *user, NSError *error))completion;
+ (void)logoutUserWithCompletionBlock:(void(^)(BOOL success, NSError *error))completion;
+ (void)signUpUserWithEmail:(NSString *)email firstName:(NSString *)firstname lastName:(NSString *)lastname password:(NSString *)password completionBlock:(void(^)(BOOL success, NSError *error))completion;
+ (void)getUserWithCompletionBlock:(void(^)(SHUser *user, NSError *error))completion;
+ (void)updateUserInfo:(NSDictionary *)info completionBlock:(void(^)(SHUser *user, NSError *error))completion;
+ (void)changePasswordForUserWithEmail:(NSString *)email password:(NSString *)password newPassword:(NSString *)newPassword completionBlock:(void(^)(BOOL success, NSError *error))completion;
+ (void)resetPasswordForUserWithEmail:(NSString *)email completionBlock:(void(^)(BOOL success, NSError *error))completion;
+ (void)resendVerificationEmailForUserWithEmail:(NSString *)email completionBlock:(void(^)(BOOL success, NSError *error))completion;
+ (void)getUnreadNotificationCountSinceTime:(long)time completionBlock:(void(^)(NSInteger count, NSError *error))completion;
+ (void)initializeMobileClientInfoWithCompletion:(void(^)(NSDictionary *info, NSError *error))completion;

//Social
+ (void)oauthAuthorizationUrlWithProviderInfo:(NSDictionary *)info completionBlock:(void (^)(NSURL *url, NSError *error))completion;
+ (void)oauthAuthenticateWithProviderInfo:(NSDictionary *)info completionBlock:(void(^)(SHUser *user, NSError *error))completion;
@end
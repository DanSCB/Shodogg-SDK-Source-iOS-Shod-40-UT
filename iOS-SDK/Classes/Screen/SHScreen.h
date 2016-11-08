//
//  SHScreen.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 10/3/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHAssetType.h"
#import "SHUtilities.h"

#define kSHScreenStatusNames @[@"invalid", @"new", @"insession", @"waiting", @"rejected", @"removed"]

typedef NS_ENUM (NSInteger, SHScreenStatus) {
    SHScreenStatusInvalid = 0,
    SHScreenStatusNew = 1,
    SHScreenStatusInSession = 2,
    SHScreenStatusWaitingForApproval = 3,
    SHScreenStatusRejected = 4,
    SHScreenStatusRemoved = 5
};

@class SHScreenAssetState;
@class SHScreenSesssion;
@class SHRemoteRefToAsset;
@class SHAsset;

@interface SHScreen : NSObject

@property (nonatomic,   copy) NSString      *Id;
@property (nonatomic,   copy) NSString      *screenId;
@property (nonatomic,   copy) NSString      *screenSessionId;
@property (nonatomic,   copy) NSString      *userId;
@property (nonatomic,   copy) NSString      *eventId;
@property (nonatomic,   copy) NSString      *syncCode;
@property (nonatomic,   copy) NSString      *username;
@property (nonatomic,   copy) NSString      *createdAt;
@property (nonatomic,   copy) NSString      *updatedAt;
@property (nonatomic,   copy) NSDictionary  *addlAttributes;
@property (nonatomic, strong) NSArray       *currentAssetsState;
@property (nonatomic, assign) BOOL           active;
@property (nonatomic, assign) SHScreenStatus status;

- (instancetype)initWithAttributes:(id)attributes;

NSArray *SHScreenStatusAllNames();
SHScreenStatus SHScreenStatusFromString(NSString *name);
NSString *SHScreenStatusAsString(SHScreenStatus screenStatus);
BOOL SHScreenStatusIsStringValid(NSString *name);

+ (void)connectScreenWithCode:(NSString *)code completionBlock:(void(^)(id data, NSError *error))completion;
+ (void)disconnectScreenWithCode:(NSString *)code completionBlock:(void(^)(BOOL success, NSError *error))completion;
+ (void)autoConnectWithCompletionBlock:(void(^)(NSDictionary *result, NSError *error))completion;
+ (void)checkScreenSessionExistsForUSTId:(NSString *)ustId withCompletionBlock:(void(^)(NSURL *screenUrl, NSError* error))completion;
+ (void)checkScreenSessionExitsForMID:(NSString *)mid withCompletionBlock:(void(^)(NSURL *screenUrl, NSError* error))completion;
+ (void)getPresyncedScreenUrlWithCompletionBlock:(void(^)(NSDictionary *result, NSError *error))completion;
+ (void)disconnectWithCompletionBlock:(void(^)(NSError *error))completion;

+ (void)getScreenSessionWithId:(NSString *)sessionId completionBlock:(void (^)(SHScreenSesssion *screenSession, NSError *error))completion;
+ (void)deleteScreenSessionWithId:(NSString *)sessionId completionBlock:(void (^)(BOOL success, NSError *error))completion;
+ (void)screenSession:(NSString *)sessionId enableLock:(BOOL)lock completionBlock:(void (^)(NSDictionary *result, NSError *error))completion;
+ (void)screenSession:(NSString *)sessionId acceptJoinRequestWithValue:(BOOL)value screenWithId:(NSString *)screenId completionBlock:(void (^)(BOOL success, NSError *error))completion;
+ (void)screenSession:(NSString *)sessionId removeScreenWithId:(NSString *)screenId completionBlock:(void (^)(BOOL success, NSError *error))completion;

//Screen Commands
+ (void)tossAssetPageWithAssetId:(NSString *)assetId page:(NSNumber *)pageNumber completionBlock:(void (^)(BOOL success, NSError *error))block;
+ (void)tossImageWithURL:(NSString *)url completionBlock:(void (^)(BOOL success, NSError *error))block;
+ (void)youtubeCommandPlayWithURL:(NSString *)url completionBlock:(void(^)(BOOL success, NSError *error))block;
+ (void)youtubeCommandPauseWithURL:(NSString *)url completionBlock:(void(^)(BOOL success, NSError *error))block;
+ (void)youtubeCommandSeekWithURL:(NSString *)url seek:(NSNumber *)seekBySeconds completionBlock:(void(^)(BOOL success, NSError *error))block;
+ (void)youtubeCommandVolumeWithURL:(NSString *)url volume:(NSInteger)volumeLevel completionBlock:(void(^)(BOOL success, NSError *error))block;
+ (void)videoCommandPlayWithURL:(NSString *)url completionBlock:(void(^)(BOOL success, NSError *error))block;
+ (void)videoCommandPauseWithURL:(NSString *)url completionBlock:(void(^)(BOOL success, NSError *error))block;
+ (void)videoCommandSeekWithURL:(NSString *)url seekBySeconds:(NSNumber *)seekValue completionBlock:(void(^)(BOOL success, NSError *error))block;
+ (void)videoCommandSeekWithURL:(NSString *)url seekToSeconds:(NSNumber *)seekValue completionBlock:(void(^)(BOOL success, NSError *error))block;
+ (void)videoCommandVolumeWithURL:(NSString *)url volume:(NSInteger)volumeLevel completionBlock:(void(^)(BOOL success, NSError *error))block;
@end
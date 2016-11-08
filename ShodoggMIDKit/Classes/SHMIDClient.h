//
//  SHMIDClient.h
//  Pods
//
//  Created by Aamir Khan on 10/28/15.
//  Copyright © 2015 Shodogg. All rights reserved.
//

@import Foundation;
@import UIKit;
@import MessageUI;

#import <ShodoggAPIKit/ShodoggAPIKit.h>
#import "SHMIDEventMetadata.h"
#import "SHMIDCastController.h"
#import "SHMIDMediaItem.h"
#import "SHMIDButton.h"
#import "ShodoggSDK.h"

extern NSString *const ShodoggMIDDefaultServerURLString;
extern NSString *const kMIDInitDoneNotification;

typedef void(^SHMIDClientInitDone)(BOOL done, NSError *error);

@protocol SHMIDClientDelegate;

@interface SHMIDClient : NSObject <MFMessageComposeViewControllerDelegate,
                                    MFMailComposeViewControllerDelegate>

@property (weak) id<SHMIDClientDelegate> delegate;
@property (nonatomic, readonly) UIStoryboard *storyboard;
@property (nonatomic, readonly) NSURL *dgTrackingURL;
//Debug
@property (readonly) BOOL showRSConsole;
@property (readonly) BOOL hideRSTVSplash;
@property (readonly) BOOL showDeviceIPAddr;;
@property (readonly) BOOL initDone;
@property (readonly) NSString *launchButtonName;

+ (SHMIDClient *)sharedClient;
+ (void)setSharedClient:(SHMIDClient *)midClient;
+ (void)setContextMediaItem:(SHMIDMediaItem *)item;
+ (void)setCastControllerDelegate:(id<SHMIDCastControllerDelegate>)delegate;
+ (void)setShodoggButtonCenter:(CGPoint)center;
+ (SHMIDButton *)getMIDButtonfromController:(UIViewController *)controller;
+ (SHMIDButton *)getMIDBarButtonfromController:(UIViewController *)controller;
+ (BOOL)screenCastInProgress;
+ (instancetype)clientWithAppKey:(NSString *)key metadata:(NSDictionary *)metadata completionBlock:(SHMIDClientInitDone)block;
- (void)reInitWithCompletion:(void(^)(BOOL done, NSError *error))completion;
- (NSString *)getMID;
- (NSString *)getMIDSessionToken;
- (NSString *)getMCOID;
- (NSString *)getMCOAppID;
- (NSString *)getMCOAppPublicKey;

- (void)loginWithEmail:(NSString *)email password:(NSString *)password completionBlock:(void(^)(NSError *error))block;
- (void)sendToAuthorizationViewFromController:(UIViewController *)controller completionBlock:(void(^)(NSError *error))completion;
- (void)loginWithEmailAndPasswordFromController:(UIViewController<SHMIDClientDelegate> *)topViewController;
- (void)loginWithGoogleFromController:(UIViewController<SHMIDClientDelegate> *)topViewController;
- (void)loginWithFacebookFromController:(UIViewController<SHMIDClientDelegate> *)topViewController;

- (void)getUserInfoWithCompletion:(void (^)(SHUser *user))completion;
- (void)logoutWithCompletionBlock:(void (^)(NSError *error))block;
- (BOOL)handleOpenURL:(NSURL *)URL;
- (BOOL)canResumeSession;
- (NSString *)getPreviousUSTId;
- (NSString *)umsCookieValue;
- (void)saveCurrentUMSCookieValue;
- (void)removeLastSavedUMSCookieValue;
- (void)removePreviousUSTId;
- (BOOL)requiresAuthenticationForCasting;
- (BOOL)debugEnabled;

@end

@protocol SHMIDClientDelegate <NSObject>

@optional
- (void)didFinishAuthenticationWithError:(NSError *)error;
@end
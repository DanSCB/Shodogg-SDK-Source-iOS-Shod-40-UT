//
//  SHMIDAuth.h
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 10/30/15.
//  Copyright © 2015 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHMIDClient.h"

typedef void (^SHAuthCompletionBlock)(id data, NSError *error);
typedef void (^SHAuthURLBlock)(NSURL *url, NSError *error);
typedef void (^SHAuthDoneBlock)(BOOL done);

#define kSHAuthProviderAllNames @[@"LINKEDIN", @"SALESFORCE", @"GOOGLE", @"FACEBOOK", @"TWITTER", @"EMAIL"]

typedef NS_ENUM(NSInteger, SHAuthProvider) {
    SHAuthProviderLinkedin,
    SHAuthProviderSalesforce,
    SHAuthProviderGoogle,
    SHAuthProviderFacebook,
    SHAuthProviderTwitter,
    SHAuthProviderEmail
};

NSArray *SHAuthProviderAllNames();
SHAuthProvider SHAuthProviderFromString(NSString *provider);
NSString *SHAuthProviderAsString(SHAuthProvider provider);

@protocol SHMIDAuthDelegate;

@interface SHMIDAuth : NSObject

@property (weak) id<SHMIDAuthDelegate> delegate;

+ (instancetype)instance;

- (void)initiateOAuthWithProvider:(SHAuthProvider)provider
               fromViewController:(UIViewController *)topViewController
                  completionBlock:(SHAuthCompletionBlock)block;

- (BOOL)handleOpenURL:(NSURL *)url;

@end

@protocol SHMIDAuthDelegate <NSObject>

@optional

- (void)didReceiveAuthenticationCode;
@end
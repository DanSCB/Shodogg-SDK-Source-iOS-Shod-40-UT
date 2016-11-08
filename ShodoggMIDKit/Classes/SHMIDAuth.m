//
//  SHMIDAuth.m
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 10/30/15.
//  Copyright © 2015 Shodogg. All rights reserved.
//

#import "SHMIDAuth.h"
#import "NSError+SHAPIError.h"
#import <SafariServices/SafariServices.h>

#pragma mark - OAuthType

NSArray *SHAuthProviderAllNames() {
    static NSArray *authProviders = nil;
    if (authProviders == nil) {
        authProviders = kSHAuthProviderAllNames;
    }
    return authProviders;
}

SHAuthProvider SHAuthProviderFromString(NSString *provider) {
    if ([provider isEqualToString:@""]
        || ![SHAuthProviderAllNames() containsObject:provider]) {
        return -1;
    }
    return (SHAuthProvider)[SHAuthProviderAllNames() indexOfObject:provider];
}

NSString *SHAuthProviderAsString(SHAuthProvider provider) {
    if (provider < [SHAuthProviderAllNames() count]) {
        return [SHAuthProviderAllNames() objectAtIndex:provider];
    }
    return @"invalid";
}

@interface SHMIDAuth()

@property (nonatomic, copy) SHAuthCompletionBlock completion;
@end

@implementation SHMIDAuth

+ (instancetype)instance {
    
    static SHMIDAuth *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[SHMIDAuth alloc] init];
    });
    
    return _instance;
}

- (NSString *)mcoAppId {
    
    return [[SHMIDClient sharedClient] getMCOAppID];
}


- (void)initiateOAuthWithProvider:(SHAuthProvider)provider
               fromViewController:(UIViewController *)topViewController
                  completionBlock:(SHAuthCompletionBlock)block {
    if (block) {
        _completion = block;
    }
    __weak typeof(self) weakself = self;
    [self getAuthorizationURLForProvider:provider
                         completionBlock:^(NSURL *url, NSError *error) {
                             if(error){
                                 NSLog(@"%s - getAuthorizationURLForProvider.error.message: %@ ",
                                       __PRETTY_FUNCTION__, [error getFailureMessageInResponseData]);
                                 return;
                             }
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [weakself openAuthViewControllerForProvider:provider
                                                         fromViewController:topViewController
                                                           authorizationUrl:url];
                            });
                         }];
}

- (void)getAuthorizationURLForProvider:(SHAuthProvider)provider completionBlock:(SHAuthURLBlock)block {
    NSMutableDictionary *requestParameters = [[NSMutableDictionary alloc] init];
    requestParameters[@"provider"] = SHAuthProviderAsString(provider);
    requestParameters[@"version"]  = @"V2";
    requestParameters[@"appId"]    = [self mcoAppId];
    [SHOAuth fetchAuthorizationURLWithQueryParameters:requestParameters completionBlock:block];
}

- (void)openAuthViewControllerForProvider:(SHAuthProvider)provider
             fromViewController:(UIViewController *)topViewController
               authorizationUrl:(NSURL *)url {
    __weak UIViewController *weakTopVC = topViewController;
    SFSafariViewController *safariViewController  = [[SFSafariViewController alloc] initWithURL:url entersReaderIfAvailable:NO];
    [topViewController presentViewController:safariViewController animated:YES completion:nil];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    
    BOOL handled = NO;
    
    if (_completion) {

        SHAuthProvider provider = SHAuthProviderFromString(url.host.uppercaseString);
        
        if (provider == SHAuthProviderFacebook
            || provider == SHAuthProviderGoogle) {
            
            NSDictionary *urlParameters = [SHMIDAuth parseParametersInURLQuery:url.query];
            handled = [self handleCallbackForAuthProvider:provider parameters:urlParameters];
        }
        else {
            NSError *error = [NSError errorWithLocalizedDescription:@"OAuth process was interuppted."];
            [self completeAuthWithData:nil error:error];
        }
    }
    
    return handled;
}

- (BOOL)handleCallbackForAuthProvider:(SHAuthProvider)provider parameters:(NSDictionary *)parameters {
    
    NSString *code = NilToEmptyString(parameters[@"code"]);
    if (!code.length) {
        NSLog(@"Something went wrong. Please, try again.");
        return NO;
    }
    
    __weak typeof(self) weakself = self;
    NSMutableDictionary *requestParameters = [[NSMutableDictionary alloc] init];
    requestParameters[@"provider"] = SHAuthProviderAsString(provider);
    requestParameters[@"version"]  = @"V2";
    requestParameters[@"appId"]    = [self mcoAppId];
    requestParameters[@"code"]     = code;
    [SHOAuth authenticateWithProviderInfo:requestParameters completionBlock:^(SHUser *user, NSError *error) {
        typeof(self) strongself = weakself;
        [strongself completeAuthWithData:user error:error];
    }];
    
    return YES;
}

- (void)completeAuthWithData:(id)data error:(NSError *)error {
    if (_completion) {
        _completion(data, error);
        _completion = nil;
    }
}

#pragma mark - Helper

+ (NSDictionary *)parseParametersInURLQuery:(NSString *)query {
    
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    for (NSString *pair in pairs) {
        NSArray *keyValue = [pair componentsSeparatedByString:@"="];
        NSString *value = [keyValue[1] stringByRemovingPercentEncoding];
        parameters[keyValue[0]] = value;
    }
    
    return parameters;
}
@end
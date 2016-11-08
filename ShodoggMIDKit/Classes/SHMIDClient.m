//
//  SHMIDClient.m
//  Pods
//
//  Created by Aamir Khan on 10/28/15.
//  Copyright © 2015 Shodogg. All rights reserved.
//

#import "SHMIDClient.h"
#import "SHMIDAuth.h"
#import "SHMIDKeychain.h"
#import "SHMCOAccountDetails.h"
#import "SHMIDScreen.h"
#import "SHUbeAPIClient_Private.h"
#import "SHMIDLoginChooserViewController.h"
#import "SHMIDLoginEmailViewController.h"

NSString *const ShodoggMIDDefaultServerURLString       = @"https://mid-demo.shodogg.com";
NSString *const kSHMID                                 = @"kSHMIDKey";
NSString *const kSHMIDSessionToken                     = @"kSHMIDSessionTokenKey";
NSString *const kSHMIDSessionTokenExpires              = @"kSHMIDSessionTokenExpiresKey";
NSString *const kSHMIDUserEmail                        = @"kSHMIDUserEmailKey";
NSString *const kSHMIDUserPassword                     = @"kSHMIDUserPasswordKey";
NSString *const kSHMIDUserCredentials                  = @"kSHMIDUserCredentialsKey";
NSString *const kSHMIDCredentialsVersion               = @"kSHMIDCredentialsVersionKey";
NSString *const kSHMIDAuthServiceURL                   = @"kSHMIDAuthServiceURLKey";
NSString *const kSHMIDPreviousUSTId                    = @"kSHMIDPreviousUSTIdKey";
NSString *const kSHMIDDeviceGUIDDictionaryKey          = @"kSHMIDGuidKey";
NSString *const kSHMIDGUIDRequestParamName             = @"reff";
NSString *const kSHMIDShowRSConsolePreference          = @"show_console";
NSString *const kSHMIDHideRSTVSplashPreference         = @"hide_tvsplash";
NSString *const kSHMIDLastServerPreference             = @"last_server_url";
NSString *const kSHMIDServerPreference                 = @"server_url";
NSString *const kSHMIDShowDeviceIPAddressPreference    = @"show_device_ipaddr";
NSString *const kSHMIDResetFTUXWelcomePreference       = @"reset_welcome";
NSString *const kSHMIDLaunchButtonImageNamePreference  = @"launch_button_image_name";
NSString *const kMIDInitDoneNotification               = @"MIDInitDoneNotificationKey";

typedef void(^SHAdvancedAuthComplete)(NSError *error);

@interface SHMIDClient()

@property (nonatomic, strong) SHMCOAccountDetails *account;
@property (nonatomic, strong) NSString *mcoId;
@property (nonatomic, strong) NSString *mcoAppId;
@property (nonatomic, strong) NSString *mid;
@property (nonatomic, strong) NSString *userAuthToken;
@property (nonatomic, strong) NSString *sessionToken;
@property (nonatomic, assign) BOOL kinesisEnabled;
@property (nonatomic, assign) BOOL advancedAuthEnabled;
@property (nonatomic, readwrite) BOOL showRSConsole;
@property (nonatomic, readwrite) BOOL hideRSTVSplash;
@property (nonatomic, readwrite) BOOL showDeviceIPAddr;
@property (nonatomic, readwrite) BOOL initDone;
@property (nonatomic, readwrite) NSString *launchButtonName;
@property (nonatomic, strong, readwrite) UIStoryboard *storyboard;
@property (nonatomic, strong, readwrite) NSURL *dgTrackingURL;
@property (nonatomic, strong) NSString *serviceURLString;
@end

static SHMIDClient *_sharedClient = nil;

@implementation SHMIDClient

- (BOOL)debugEnabled {
    return self.showRSConsole || self.hideRSTVSplash;
}

+ (SHMIDClient *)sharedClient {
    return _sharedClient;
}

+ (void)setSharedClient:(SHMIDClient *)midClient {
    if (midClient == _sharedClient) return;
    _sharedClient = nil;
    _sharedClient = midClient;
}

+ (void)setContextMediaItem:(SHMIDMediaItem *)item {
    [[SHMIDCastController sharedInstance] setContextItem:item];
}

+ (void)setCastControllerDelegate:(id<SHMIDCastControllerDelegate>)delegate {
    if (!delegate) {
        return;
    }
    [SHMIDCastController sharedInstance].delegate = delegate;
}

+ (void)setShodoggButtonCenter:(CGPoint)center {
    [[SHMIDCastController sharedInstance] setShodoggButtonCenter:center];
}

+ (SHMIDButton *)getMIDButtonfromController:(UIViewController *)controller {
    return [[SHMIDCastController sharedInstance] getShodoggMIDButtonForController:controller];
}

+ (SHMIDButton *)getMIDBarButtonfromController:(UIViewController *)controller {
    return [[SHMIDCastController sharedInstance] getShodoggMIDBarButtonForController:controller];
}

+ (BOOL)screenCastInProgress {
    return [[SHMIDCastController sharedInstance] screenCastInProgress];
}

+ (instancetype)clientWithAppKey:(NSString *)key
                        metadata:(NSDictionary *)metadata
                 completionBlock:(SHMIDClientInitDone)block {
    return [[self alloc] initWithAppKey:key
                               metadata:metadata
                        completionBlock:block];
}

- (instancetype)initWithAppKey:(NSString *)key
                      metadata:(NSDictionary *)metadata
               completionBlock:(SHMIDClientInitDone)block {
    if (self = [super init]) {
        // MARK: Load debug settings
        NSDictionary *settings = metadata[@"settings"];
        [self loadDebugSettings:settings];
        // MARK: Configure Service URL
        _serviceURLString = settings[kSHMIDServerPreference];
        if (!_serviceURLString.length) {
            _serviceURLString = ShodoggMIDDefaultServerURLString;
        }
        [self performServerSwitchCheck];
        // MARK: INIT ShodoggAPIClient
        NSURL *midServerURL = [NSURL URLWithString:_serviceURLString];
        SHUbeAPIClient *ubeAPIClient = [SHUbeAPIClient clientWithBaseBaseURL:midServerURL];
        [SHUbeAPIClient setSharedClient:ubeAPIClient];
        // MARK: MID INIT
        __weak typeof(self) weakself = self;
        _account = [SHMCOAccountDetails accountWithAppPublicKey:key];
        [self requestGuidForDeviceWithCompletionBlock:^{
            [weakself registerMCOAppWithInfo:metadata[@"appInfo"] completionBlock:block];
            [[SHCookieStore sharedCookieStore] saveValue:_serviceURLString forKey:kSHMIDLastServerPreference];
        }];
        // MARK: Load Storyboard (UI)
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *resourcesPath = [bundle pathForResource:@"ShodoggMIDKit" ofType:@"bundle"];
        NSBundle *resources = [NSBundle bundleWithPath:resourcesPath];
        _storyboard = [UIStoryboard storyboardWithName:@"MIDUIComponents" bundle:resources];
        _sharedClient = self;
    }

    return self;
}

- (void)reInitWithCompletion:(void(^)(BOOL done, NSError *error))completion {
    [self requestGuidForDeviceWithCompletionBlock:^{
       [self registerMCOAppWithInfo:@{} completionBlock:completion];
    }];
}

#pragma mark - DEBUG

- (void)loadDebugSettings:(NSDictionary *)settings {
    if(settings.allKeys.count > 0) {
        _showRSConsole    = [settings[kSHMIDShowRSConsolePreference] boolValue];
        _hideRSTVSplash   = [settings[kSHMIDHideRSTVSplashPreference] boolValue];
        _showDeviceIPAddr = [settings[kSHMIDShowDeviceIPAddressPreference] boolValue];
        _launchButtonName = settings[kSHMIDLaunchButtonImageNamePreference];
        BOOL resetWelcome = [settings[kSHMIDResetFTUXWelcomePreference] boolValue];
        if (resetWelcome) {
            [[SHMIDCastController sharedInstance] resetFirstTimeUserExperience];
        }
    }
}

- (void)performServerSwitchCheck {
    if ([self checkIfSwitchedServer]) {
        NSLog(@"%s - SERVER SWITCHED ", __PRETTY_FUNCTION__);
        NSString *preference = [[SHCookieStore sharedCookieStore] getValueForKey:kSHMIDLastServerPreference];
        [[SHCookieStore sharedCookieStore] clearAllCookiesForHost:preference];
        [SHScreenSesssion removeCurrentScreenSessionId];
    }
}

#pragma mark - API

- (void)requestGuidForDeviceWithCompletionBlock:(void(^)())completion {
    if ([self getSavedGUIDForDevice].length) {
        if (completion) completion();
        return;
    }
    __weak typeof(self) weakself = self;
    NSString *pathComponent = @"/api/mid/device/guid";
    [[SHUbeAPIClient sharedClient]
     performRequestWithMethod:@"POST"
     pathComponent:pathComponent
     parameters:nil
     completionBlock:^(NSURLResponse *response, id responseObject, NSError *error) {
         NSLog(@"\n[POST - %@ ] {\n\tResponse: %@\n\tFailure: %@\n}", pathComponent,
               [responseObject description], [error getFailureMessageInResponseData]);
         [weakself saveGUIDForDevice:NilToEmptyString(responseObject[kSHMIDGUIDRequestParamName])];
         if (completion) completion();
     }];
}

- (void)registerMCOAppWithInfo:(NSDictionary *)appInfo
                   completionBlock:(SHMIDClientInitDone)block {
    __weak typeof(self) weakself = self;
    NSString *component = @"/api/mid/init";
    NSMutableDictionary *requestParameters = [[NSMutableDictionary alloc] init];
    requestParameters[@"appInfo"]    = appInfo;
    requestParameters[@"publicKey"]  = _account.mcoAppPublicKey;
    requestParameters[@"device"]     = [SHMobileDeviceInfoDTO mobileInfoDictionary];
    requestParameters[kSHMIDGUIDRequestParamName] = [self getSavedGUIDForDevice];
    NSString *previousScreenSessionId= [SHScreenSesssion getCurrentScreenSessionId];
    NSString *previousUSTId          = [self getPreviousUSTId];
    if (previousUSTId && previousScreenSessionId) {
        requestParameters[@"screenSessionId"] = previousScreenSessionId;
        requestParameters[@"previousUSTId"]   = previousUSTId;
    }
    NSLog(@"%s - Parameter: \n%@", __PRETTY_FUNCTION__, requestParameters);
    [[SHUbeAPIClient sharedClient] performRequestWithMethod:@"POST"
                       pathComponent:component
                          parameters:requestParameters
                     completionBlock:^(NSURLResponse *response, id responseObject, NSError *error) {
                         NSLog(@"\n[POST - %@] {\n\tResponse: %@\n\tFailure: %@\n}", component,
                               [responseObject description], [error getFailureMessageInResponseData]);
                         if (responseObject) {
                             weakself.initDone = YES;
                             weakself.mcoId = NilToEmptyString(responseObject[@"mcoId"]);
                             weakself.mcoAppId = NilToEmptyString(responseObject[@"appId"]);
                             weakself.kinesisEnabled = [responseObject[@"kinesisEnabled"] boolValue];
                             weakself.advancedAuthEnabled = [responseObject[@"mcoAppInfo"][@"advancedAuthEnabled"] boolValue];
                             weakself.dgTrackingURL = [NSURL URLWithString:NilToEmptyString(responseObject[@"deviceDiscoveryTrackingURL"])];
                             [weakself saveUSTId:NilToEmptyString(responseObject[@"ustId"])];
                             [[NSNotificationCenter defaultCenter] postNotificationName:kMIDInitDoneNotification object:nil];
                             [[SHMIDCastController sharedInstance] beginDiscovery];
                             if (block) block(YES, error);
                         } else {
                             if (block) block(NO, error);
                         }
                     }];
}

- (void)requestMIDSessionWithCompletionBlock:(void(^)(NSDictionary *session, NSError *error))block {
    __weak typeof(self) weakself = self;
    NSString *pathComponent = @"/api/mid/session";
    NSMutableDictionary *requestParameters = [[NSMutableDictionary alloc] init];
    requestParameters[@"mid"] = self.mid;
    requestParameters[@"userAuthToken"] = self.userAuthToken;
    [[SHUbeAPIClient sharedClient]
        performRequestWithMethod:@"POST"
                   pathComponent:pathComponent
                      parameters:requestParameters
                 completionBlock:^(NSURLResponse *response, id responseObject, NSError *error) {
                     NSLog(@"\n[POST - %@ ] {\n\tResponse: %@\n\tFailure: %@\n}", pathComponent,
                           [responseObject description], [error getFailureMessageInResponseData]);
                     weakself.sessionToken = NilToEmptyString(responseObject[@"sessionToken"]);
                     if (block) block(responseObject, error);
                 }];
}

- (void)authenticateUserWithEmail:(NSString *)email password:(NSString *)password
                  completionBlock:(void (^)(NSError *))block {
    __weak typeof(self) weakself = self;
    NSString *path = @"/api/mid/auth";
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"email"]    = email;
    parameters[@"pass_hash"]= [SHSecurityUtilities caseInsensitiveHashedPassword:password forEmail:email];
    
    [[SHUbeAPIClient sharedClient]
            POST:path
      parameters:parameters
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
             NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
             NSLog(@"\n[%@ - %@] {\n\tHeaders:%@,\n\tJSON: %@,\n\tError:%@\n}",
                   @"POST", path, [response allHeaderFields], responseObject,
                   [task.error localizedDescription]);
             if (responseObject) {
                 SHUser *user = [[SHUser alloc] initWithAttributes:responseObject];
                 weakself.mid = user.Id;
                 weakself.userAuthToken = user.currentUserAuthToken;
                 typeof(self) strongself = weakself;
                 [strongself shouldPerformAdvancedAuthWithCompletion:block];
                 return;
             }
             if (block) block(task.error);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"\n[%@ - %@] {\n\tJSON: %@,\n\tError:%@\n}", @"POST",
                        path, task.response, [error localizedDescription]);
            if (block) block(error);
        }];
}

- (void)logoutWithCompletionBlock:(void (^)(NSError *error))block {
    __weak typeof(self) wself = self;
    NSString *path = @"/api/mid/logout";
    [[SHUbeAPIClient sharedClient]
        POST:path
        parameters:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            [[SHCookieStore sharedCookieStore] clearAllCookiesForHost:_serviceURLString];
            [SHMIDKeychain deleteCredentials];
            [SHMIDScreen setSharedScreen:nil];
            [SHScreenSesssion removeCurrentScreenSessionId];
            [wself removePreviousUSTId];
            [wself reInitWithCompletion:nil];
            if (block) block(task.error);
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (block) block(error);
      }];
}

- (void)getUserInfoWithCompletion:(void (^)(SHUser *user))completion {
    [SHUser getUserWithCompletionBlock:^(SHUser *user, NSError *error) {
        completion(user);
    }];
}

#pragma mark - Session/Cookie convenience

- (void)saveCredentials {
    //Save the current logged user info in keychain
    NSMutableDictionary *userCredentials = [NSMutableDictionary new];
    [userCredentials setObject:_mid forKey:kSHMID];
    if ([[SHCookieStore sharedCookieStore] sessionToken]) {
        NSDate *expires = [[SHCookieStore sharedCookieStore] sessionToken].expiresDate;
        [userCredentials setObject:_sessionToken forKey:kSHMIDSessionToken];
        [userCredentials setObject:expires forKey:kSHMIDSessionTokenExpires];
    }
    [SHMIDKeychain setCredentials:userCredentials];
}

- (BOOL)midLinked {
    //Check if session for current user in keychain is valid
    NSDictionary *credentials = [SHMIDKeychain credentials];
    if (credentials.count !=0) {
        return YES;
    }
    return NO;
}

- (BOOL)canResumeSession {
    NSLog(@"%s - Keychain Item: %@", __PRETTY_FUNCTION__, [SHMIDKeychain credentials]);
    return [[SHCookieStore sharedCookieStore] resumeSession];
}

#pragma mark - UMS
- (BOOL)umsCookieExists {
    return [[SHCookieStore sharedCookieStore] umsCookieExists];
}

- (BOOL)umsCookieExpired {
    return [[SHCookieStore sharedCookieStore] umsCookieExpired];
}

- (NSString *)umsCookieValue {
    return [[SHCookieStore sharedCookieStore] umsCookie].value;
}

- (NSString *)getLastSavedUMSCookieValue {
    return [[SHCookieStore sharedCookieStore] getLastSavedUMSCookieValue];
}

- (void)saveCurrentUMSCookieValue {
    [[SHCookieStore sharedCookieStore] saveCurrentUMSCookieValue];
}

- (void)removeLastSavedUMSCookieValue {
    [[SHCookieStore sharedCookieStore] removeLastSavedUMSCookieValue];
}

#pragma mark - UST

- (void)saveUSTId:(NSString *)ustId {
    if (ustId.length > 0) {
        [[SHCookieStore sharedCookieStore] saveValue:ustId forKey:kSHMIDPreviousUSTId];
    }
}

- (NSString *)getPreviousUSTId {
    return [[SHCookieStore sharedCookieStore] getValueForKey:kSHMIDPreviousUSTId];
}

- (void)removePreviousUSTId {
    [[SHCookieStore sharedCookieStore] removeValueForKey:kSHMIDPreviousUSTId];
}

#pragma mark - GUID

- (NSString *)getSavedGUIDForDevice {
    NSString *guid = nil;
    id guidStore = [[SHCookieStore sharedCookieStore] getValueForKey:kSHMIDDeviceGUIDDictionaryKey];
    if ([guidStore isKindOfClass:[NSDictionary class]]) {
        guid = [(NSDictionary *)guidStore objectForKey:_serviceURLString];
        NSLog(@"%s - Fetched GUID: %@ for service: %@", __PRETTY_FUNCTION__, guid, _serviceURLString);
    }
    return guid;
}

- (void)saveGUIDForDevice:(NSString *)guid {
    if (guid.length) {
        NSMutableDictionary *newGUIDStore = [[NSMutableDictionary alloc] init];
        id guidStore = [[SHCookieStore sharedCookieStore] getValueForKey:kSHMIDDeviceGUIDDictionaryKey];
        if ([guidStore isKindOfClass:[NSDictionary class]]) {
            newGUIDStore = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary *)guidStore];
        }
        [newGUIDStore setObject:guid forKey:_serviceURLString];
        [[SHCookieStore sharedCookieStore] saveValue:newGUIDStore forKey:kSHMIDDeviceGUIDDictionaryKey];
    }
}

- (BOOL)checkIfSwitchedServer {
    NSString *preference = [[SHCookieStore sharedCookieStore] getValueForKey:kSHMIDLastServerPreference];
    if (!preference.length) {
        return NO;
    }
    if (![preference isEqualToString:_serviceURLString]) {
        return YES;
    }
    return NO;
}

#pragma mark - Casting Validation

- (BOOL)requiresAuthenticationToCastMediaItem:(SHMIDMediaItem *)item {
    return NO;
}

- (BOOL)requiresAuthenticationForCasting {
    return [self requiresAuthenticationToCastMediaItem:nil];
}

#pragma mark - Getters

- (NSString *)getMID {
    if (!_mid) {
        //Checking for mid in the last logged session
        //session will return last successfully logged users mid
        //provided the session has not expired.
        /* Testing SSO - A Hack
         * Manually create session_token
         * from Keychain values and add it to NSHTTPCookieStorage
         */
        NSLog(@"%s - Keychain Item: %@", __PRETTY_FUNCTION__, [SHMIDKeychain credentials]);
        if ([SHMIDKeychain credentials]) {
            NSURL *environment = [NSURL URLWithString:ShodoggMIDDefaultServerURLString];
            NSDictionary *credentials = [SHMIDKeychain credentials];
            NSDictionary *properties = @{@"Name"    : @"session_token",
                                         @"Domain"  : environment.host,
                                         @"Path"    : @"/",
                                         @"Value"   : [credentials objectForKey:kSHMIDSessionToken],
                                         @"Expires" : [credentials objectForKey:kSHMIDSessionTokenExpires],
                                         @"Guid"    : [credentials objectForKey:kSHMID]};
            NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:properties];
            if (cookie) {
                NSLog(@"%s - Cookie Hijack success", __PRETTY_FUNCTION__);
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
                _mid = credentials[kSHMID];
            }
        } else {
            SHCookie *savedSession = [[SHCookieStore sharedCookieStore] sessionToken];
            _mid = savedSession.guid;
        }
    }
    return _mid;
}

- (NSString *)getMIDSessionToken {
    if(!_sessionToken) {
        SHCookie *savedSession = [[SHCookieStore sharedCookieStore] sessionToken];
        return savedSession.value;
    }
    return _sessionToken;
}

- (NSString *)getMCOID {
    return _mcoId;
}

- (NSString *)getMCOAppID {
    return _mcoAppId;
}

- (NSString *)getMCOAppPublicKey {
    return _account.mcoAppPublicKey;
}

#pragma mark - URL Scheme and Redirection

- (NSString *)appScheme {
    if (!_mcoAppId) {
        NSLog(@"%s - App Id not found. Make sure MIDClient was initialized.", __PRETTY_FUNCTION__);
    }
    return [NSString stringWithFormat:@"mid-%@", _mcoAppId];
}

- (BOOL)appConformsToScheme {
    NSString *appScheme = [self appScheme];
    NSDictionary *loadedPlist = [[NSBundle mainBundle] infoDictionary];
    NSArray *urlTypes = [loadedPlist objectForKey:@"CFBundleURLTypes"];
    for (NSDictionary *urlType in urlTypes) {
        NSArray *schemes = [urlType objectForKey:@"CFBundleURLSchemes"];
        for (NSString *scheme in schemes) {
            if ([scheme isEqual:appScheme]) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)handleOpenURL:(NSURL *)url {
    //This should check if the app is registered with
    //Shodogg scheme in format:"mid-{mcoAppId}://method"
    //mcoAppId: Consumer Id
    //method: type of service e.g. facebook, google
    NSString *expected = [NSString stringWithFormat:@"%@://", [self appScheme]];
    if (![[url absoluteString] hasPrefix:expected]) {
        return NO;
    }
    return [[SHMIDAuth instance] handleOpenURL:url];
}

#pragma mark - Login Convenience

- (void)loginWithEmail:(NSString *)email password:(NSString *)password completionBlock:(void (^)(NSError *))block {
    [self authenticateUserWithEmail:email password:password completionBlock:block];
}

- (void)shouldPerformAdvancedAuthWithCompletion:(SHAdvancedAuthComplete)block  {
    if (self.advancedAuthEnabled) {
        [self requestMIDSessionWithCompletionBlock:^(NSDictionary *session, NSError *error) {
            [[SHCookieStore sharedCookieStore] saveCurrentSessionAndGUID:self.mid];
            block(error);
        }];
    } else {
        [[SHCookieStore sharedCookieStore] saveCurrentSessionAndGUID:self.mid];
        block(nil);
    }
    [SHScreenSesssion removeCurrentScreenSessionId];
    [self removePreviousUSTId];
}

#pragma mark - Login UI Convenience

- (void)sendToAuthorizationViewFromController:(UIViewController *)controller completionBlock:(void (^)(NSError *error))completion {
    SHMIDLoginChooserViewController *login = [SHMIDLoginChooserViewController controllerWithCompletionBlock:completion];
    if (![self umsCookieExists]
        || [self umsCookieExpired]) {
        [self reInitWithCompletion:^(BOOL done, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (done) {
                    [controller presentViewController:login animated:YES completion:nil];
                } else {
                    [error showAsAlertInController:controller];
                }
            });
        }];
    } else {
        [controller presentViewController:login animated:YES completion:nil];
    }
}

- (void)loginWithEmailAndPasswordFromController:(UIViewController<SHMIDClientDelegate> *)topViewController {
    self.delegate = topViewController;
    SHMIDLoginEmailViewController *emailController
    = [SHMIDLoginEmailViewController controllerWithModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [topViewController presentViewController:emailController animated:YES completion:nil];
}

- (void)loginWithGoogleFromController:(UIViewController<SHMIDClientDelegate> *)topViewController {
    [self initiateOAuthWithProvider:SHAuthProviderGoogle fromViewController:topViewController];
}

- (void)loginWithFacebookFromController:(UIViewController<SHMIDClientDelegate> *)topViewController {
    [self initiateOAuthWithProvider:SHAuthProviderFacebook fromViewController:topViewController];
}

- (void)initiateOAuthWithProvider:(SHAuthProvider)provider fromViewController:(UIViewController<SHMIDClientDelegate> *)topViewController {
    __weak typeof(self) weakself = self;
    self.delegate = topViewController;
    if (![self appConformsToScheme]) {
        NSError *error = [NSError errorWithLocalizedDescription:@"Your app is not registered with correct MID URL scheme."];
        [self.delegate didFinishAuthenticationWithError:error];
        return;
    }
    SHAdvancedAuthComplete authComplete = ^(NSError *error) {
        if ([weakself.delegate respondsToSelector:@selector(didFinishAuthenticationWithError:)]) {
            [weakself.delegate didFinishAuthenticationWithError:error];
        }
    };
    [[SHMIDAuth instance]
     initiateOAuthWithProvider:provider
     fromViewController:topViewController
        completionBlock:^(SHUser *data, NSError *error) {
         if (data) {
             weakself.mid = data.Id;
             weakself.userAuthToken = data.currentUserAuthToken;
             typeof(self) strongself = weakself;
             [strongself shouldPerformAdvancedAuthWithCompletion:authComplete];
         }
         else if([weakself.delegate respondsToSelector:@selector(didFinishAuthenticationWithError:)]
                 && error != nil) {
             [weakself.delegate didFinishAuthenticationWithError:error];
         }
     }];
}

#pragma mark - Message/Mail Compose Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
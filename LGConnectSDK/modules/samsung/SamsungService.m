//
//  SamsungService.m
//  ConnectSDK
//
//  Created by Artem Stepuk on 11/13/15.
//  Copyright © 2015 LG Electronics. All rights reserved.
//

#import "SamsungService.h"
//#import <MSF/MSF-Swift.h>
#import <SmartView/SmartView-Swift.h>

NSString * const kSamsungServiceId = @"SamsungService";
NSString * const kSamsungChannelURI = @"SamsungCommunicationChannelURI";

NSTimeInterval const kSamsungDiscoveryTimeout = 5;

/**
 *  Currently SamsungService object is keeping the MSF Application object. 
 *  When communication (send/receive data to/from app) will be implemented - move ownership to 
 *  WebAppSession object.
 */

@interface SamsungService ()

@property(nonatomic, strong)Application *application;

@end

@implementation SamsungService

+ (NSDictionary*)discoveryParameters {
    return @{@"serviceId": kSamsungServiceId};
}

- (BOOL)hasCapability:(NSString *)capability {
    return YES;
}

- (BOOL)isConnectable {
    return YES;
}

- (void)connect {
    self.connected = YES;
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(deviceServiceConnectionSuccess:)]){
        dispatch_on_main(^{
            [self.delegate deviceServiceConnectionSuccess:self];
        });
    }
}

- (void)disconnect {
    self.connected = NO;
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(deviceService:disconnectedWithError:)]) {
        dispatch_on_main(^{
            [self.delegate deviceService:self disconnectedWithError:nil];
        });
    }
}

#pragma mark - <WebAppLauncher>

- (id<WebAppLauncher>)webAppLauncher {
    return self;
}

- (CapabilityPriorityLevel)webAppLauncherPriority {
    return CapabilityPriorityLevelHigh;
}

- (void)launchWebApp:(NSString *)webAppId
             success:(WebAppLaunchSuccessBlock)success
             failure:(FailureBlock)failure {
    NSAssert(NO, @"Not implemented");
}

- (void)launchWebApp:(NSString *)webAppId
              params:(NSDictionary *)params
             success:(WebAppLaunchSuccessBlock)success
             failure:(FailureBlock)failure {
    NSString *channelURI = params[kSamsungChannelURI];
    
    //???: remove "connection" parameter from app launch parameters
    NSMutableDictionary *appParams = [NSMutableDictionary dictionaryWithDictionary:params];
    appParams[kSamsungChannelURI] = nil;
    //
    
    NSURL *appURL = [self appURLfromString:webAppId withParameters:appParams];
    
    Service *service = (Service*)self.serviceDescription.device;
    self.application =  [service createApplication:appURL
                                        channelURI:channelURI
                                              args:nil];
    self.application.connectionTimeout = kSamsungDiscoveryTimeout;
    
    [self.application connect:nil completionHandler:^(ChannelClient *channel, NSError *error) {
        dispatch_on_main(^{
            if (error) {
                failure(error);
            } else {
                /**
                 *  Currently we are not returning the WebApp session object because it's not needed
                 *  and will not have any functionality
                 */
                success(nil);
            }
        });
    }];
}

- (NSURL*)appURLfromString:(NSString*)webApp withParameters:(NSDictionary*)parameters {
    NSMutableArray *parametersQueryItems = [NSMutableArray array];
    for (NSString *key in parameters.keyEnumerator) {
        NSURLQueryItem *quiryItem = [[NSURLQueryItem alloc] initWithName:key
                                                                   value:parameters[key]];
        [parametersQueryItems addObject:quiryItem];
    }
    
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:webApp];
    
    NSArray *existingQueryItems = urlComponents.queryItems;
    if (!existingQueryItems) {
        existingQueryItems = @[];
    }
    
    NSArray *mergedQueryItems =
        [existingQueryItems arrayByAddingObjectsFromArray:parametersQueryItems];
    urlComponents.queryItems = mergedQueryItems;
    
    return urlComponents.URL;
}

- (void)launchWebApp:(NSString *)webAppId
   relaunchIfRunning:(BOOL)relaunchIfRunning
             success:(WebAppLaunchSuccessBlock)success
             failure:(FailureBlock)failure {
    NSAssert(NO, @"Not implemented");
}

- (void)launchWebApp:(NSString *)webAppId
              params:(NSDictionary *)params
   relaunchIfRunning:(BOOL)relaunchIfRunning
             success:(WebAppLaunchSuccessBlock)success
             failure:(FailureBlock)failure {
    NSAssert(NO, @"Not implemented");
}

- (void)joinWebApp:(LaunchSession *)webAppLaunchSession
           success:(WebAppLaunchSuccessBlock)success
           failure:(FailureBlock)failure {
    NSAssert(NO, @"Not implemented");
}

- (void)joinWebAppWithId:(NSString *)webAppId
                 success:(WebAppLaunchSuccessBlock)success
                 failure:(FailureBlock)failure {
    NSAssert(NO, @"Not implemented");
}

- (void)closeWebApp:(LaunchSession *)launchSession
            success:(SuccessBlock)success
            failure:(FailureBlock)failure {

    Application *app = self.application;
    
    [app disconnectWithLeaveHostRunning:NO
                      completionHandler:^(ChannelClient *client, NSError *error) {
        dispatch_on_main(^{
            if (error) {
                failure(error);
            } else {
                success(nil);
            }
        });
    }];
}

- (void)pinWebApp:(NSString *)webAppId
          success:(SuccessBlock)success
          failure:(FailureBlock)failure {
    NSAssert(NO, @"Not implemented");
}

- (void)unPinWebApp:(NSString *)webAppId
            success:(SuccessBlock)success
            failure:(FailureBlock)failure {
    NSAssert(NO, @"Not implemented");
}

- (void)isWebAppPinned:(NSString *)webAppId
               success:(WebAppPinStatusBlock)success
               failure:(FailureBlock)failure {
    NSAssert(NO, @"Not implemented");
}

- (ServiceSubscription *)subscribeIsWebAppPinned:(NSString*)webAppId
                                         success:(WebAppPinStatusBlock)success
                                         failure:(FailureBlock)failure {
    NSAssert(NO, @"Not implemented");
    return nil;
}


@end

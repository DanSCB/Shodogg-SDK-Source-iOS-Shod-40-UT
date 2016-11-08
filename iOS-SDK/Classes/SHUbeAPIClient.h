//
//  SHUbeAPIClient.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 3/30/15.
//  Copyright (c) 2015 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>

typedef void(^SHRequestCompletionBlock)(NSURLResponse *response, id responseObject, NSError *error);

@interface SHUbeAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

- (void)performRequestWithMethod:(NSString *)method
                   pathComponent:(NSString *)component
                      parameters:(NSDictionary *)parameters
                 completionBlock:(SHRequestCompletionBlock)block;

- (void)dataTaskPOST:(NSString *)URLString
                data:(NSData *)data
     completionBlock:(SHRequestCompletionBlock)block;

- (void)dgPOSTDataTaskWithRequestURL:(NSURL *)url
            unauthorizedSessionToken:(NSString *)ust
                      dataInHttpBody:(NSData *)data
                     completionBlock:(SHRequestCompletionBlock)block;
@end
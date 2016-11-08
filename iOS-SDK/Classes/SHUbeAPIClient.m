//
//  SHUbeAPIClient.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 3/30/15.
//  Copyright (c) 2015 Shodogg. All rights reserved.
//

#import "SHUbeAPIClient.h"
#import "SHUtilities.h"

//static NSString *const kAppGroupDomain = @"group.com.shodogg.shodoggconnect";

static NSString* const ContentTypeHeader            = @"Content-Type";
static NSString* const ContentTypeHeaderValue       = @"application/json";
static NSString* const ShodoggAppIdentifierHeader   = @"X-Shodogg-App";
static NSString* const ShodoggUSTHeaderName         = @"X-Shodogg-UST";
static SHUbeAPIClient *_sharedClient = nil;

@interface SHUbeAPIClient()
@end

@implementation SHUbeAPIClient

#pragma mark - Initialization

+ (instancetype)sharedClient {
    
    return _sharedClient;
}

+ (void)setSharedClient:(SHUbeAPIClient *)client {
    
    if (client == _sharedClient) return;
    _sharedClient = nil;
    _sharedClient = client;
}

+ (instancetype)clientWithBaseBaseURL:(NSURL *)url {
    
    return [[self alloc] initWithBaseURL:url
                    sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    
    return [self initWithBaseURL:url
            sessionConfiguration:nil];
}

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration {

    if (self = [super initWithBaseURL:url sessionConfiguration:configuration]) {
        [self.requestSerializer setValue:[SHUtilities appNameAndVersionStamp]
                      forHTTPHeaderField:ShodoggAppIdentifierHeader];
    }
    
    return self;
}

#pragma mark - Request

- (NSString *)pathByAppendingRequestComponent:(NSString *)component {
    return [self.baseURL.absoluteString stringByAppendingPathComponent:component];
}

- (NSURLRequest *)urlRequestWithMethod:(NSString *)method
                         pathComponent:(NSString *)component
                        dataInHTTPBody:(NSData *)data {
    NSString *urlString = [self pathByAppendingRequestComponent:component];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setValue:[SHUtilities appNameAndVersionStamp] forHTTPHeaderField:ShodoggAppIdentifierHeader];
    [request setValue:ContentTypeHeaderValue forHTTPHeaderField:ContentTypeHeader];
    [request setHTTPMethod:method];
    [request setHTTPBody:data];
    return request;
}

- (NSURLRequest *)jsonSerializedRequestWithMethod:(NSString *)method
                                    pathComponent:(NSString *)component
                                       parameters:(NSDictionary *)parameters {
    NSString *resourceURL;
    NSURLRequest *request;
    AFJSONRequestSerializer *jsonSerializer;
    jsonSerializer = [AFJSONRequestSerializer serializer];
    [jsonSerializer setValue:[SHUtilities appNameAndVersionStamp]
          forHTTPHeaderField:ShodoggAppIdentifierHeader];
    resourceURL = [self pathByAppendingRequestComponent:component];
    request = [jsonSerializer requestWithMethod:method
                                      URLString:resourceURL
                                     parameters:parameters
                                          error:nil];
    return request;
}

- (void)performRequestWithMethod:(NSString *)method
                   pathComponent:(NSString *)component
                      parameters:(NSDictionary *)parameters
                 completionBlock:(SHRequestCompletionBlock)block {
    NSURLRequest *request;
    request = [self jsonSerializedRequestWithMethod:method
                                      pathComponent:component
                                         parameters:parameters];
    [[self dataTaskWithRequest:request completionHandler:block] resume];
}

- (void)dataTaskWithMethod:(NSString *)method
             pathComponent:(NSString *)component
                      data:(NSData *)data
           completionBlock:(SHRequestCompletionBlock)block {
    NSURLRequest *request = [self urlRequestWithMethod:method
                                         pathComponent:component
                                        dataInHTTPBody:data];
    [[self dataTaskWithRequest:request completionHandler:block] resume];
}

- (void)dataTaskPOST:(NSString *)URLString
                data:(NSData *)data
           completionBlock:(SHRequestCompletionBlock)block {
    [self dataTaskWithMethod:@"POST"
               pathComponent:URLString
                        data:data
             completionBlock:block];
}

#pragma mark - Device Graph

- (NSURLRequest *)dgRequestWithURL:(NSURL *)url unauthorizedSessionToken:(NSString *)ust {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:[SHUtilities appNameAndVersionStamp] forHTTPHeaderField:ShodoggAppIdentifierHeader];
    [request setValue:ContentTypeHeaderValue forHTTPHeaderField:ContentTypeHeader];
    [request setValue:ust forHTTPHeaderField:ShodoggUSTHeaderName];
    return request;
}

- (void)dgPOSTDataTaskWithRequestURL:(NSURL *)url
            unauthorizedSessionToken:(NSString *)ust
                      dataInHttpBody:(NSData *)data
                     completionBlock:(SHRequestCompletionBlock)block {
    NSMutableURLRequest *request = [self dgRequestWithURL:url unauthorizedSessionToken:ust];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [[self dataTaskWithRequest:request completionHandler:block] resume];
}

@end
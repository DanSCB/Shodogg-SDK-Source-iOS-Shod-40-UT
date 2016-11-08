//
//  SHUbeAPIClient_Private.h
//  ShodoggAPIKit
//
//  Created by Aamir Khan on 5/20/16.
//  Copyright (c) 2016 Shodogg. All rights reserved.
//

#import "SHUbeAPIClient.h"

@interface SHUbeAPIClient()
+ (void)setSharedClient:(SHUbeAPIClient *)client;
+ (instancetype)clientWithBaseBaseURL:(NSURL *)url;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration;
@end
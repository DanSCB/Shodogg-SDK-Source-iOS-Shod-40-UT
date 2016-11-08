//
//  SHEventUrl.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 10/4/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHEventUrl : NSObject

@property (nonatomic,   copy) NSString      *Id;
@property (nonatomic,   copy) NSString      *userId;
@property (nonatomic,   copy) NSString      *name;
@property (nonatomic,   copy) NSString      *uriPath;
@property (nonatomic,   copy) NSString      *screenSessionId;
@property (nonatomic,   copy) NSString      *createdAt;
@property (nonatomic,   copy) NSString      *updatedAt;
@property (nonatomic,   copy) NSDictionary  *addlAttributes;
@property (nonatomic, assign) BOOL          deleted;

- (instancetype)initWithAttributes:(id)attributes;
- (NSString *)absoluteURLString;

+ (void)getUserEventURLsWithCompletionBlock:(void(^)(NSArray *results, NSError *error))completion;
+ (void)connectEventURLWithId:(NSString *)eventId enableLock:(BOOL)lock completionBlock:(void(^)(NSDictionary *result, NSError *error))completion;
+ (void)disconnectEventURLWithId:(NSString *)eventId completionBlock:(void(^)(BOOL success, NSError *error))completion;

- (void)startConnectionWithCompletionBlock:(void (^)(NSDictionary *result, NSError *error))completion;
- (void)startSecureConnectionWithCompletionBlock:(void (^)(NSDictionary *result, NSError *error))completion;
- (void)disconnectWithCompletionBlock:(void (^)(NSError *error))completion;
@end
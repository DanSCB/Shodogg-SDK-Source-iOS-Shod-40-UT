//
//  SHGroup.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 9/16/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHRepoUtilities.h"

@interface SHGroup : NSObject

@property (nonatomic,   copy) NSString          *Id;
@property (nonatomic,   copy) NSString          *ownerId;
@property (nonatomic,   copy) NSString          *name;
@property (nonatomic,   copy) NSString          *createdAt;
@property (nonatomic,   copy) NSString          *updatedAt;
@property (nonatomic, strong) NSArray           *folders;
@property (nonatomic, strong) NSDictionary      *addlAttributes;
@property (nonatomic, assign) SHRepoProvider    repoProvider;

- (instancetype)initWithAttributes:(id)attributes;

+ (void)getGroupWithId:(NSString *)groupId completionBlock:(void(^)(SHGroup *group, NSError *error))completion;
+ (void)getUserGroupsWithCompletionBlock:(void(^)(NSArray *groups, NSError *error))completion;
@end
//
//  SHGroup.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 9/16/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import "SHGroup.h"
#import "SHUbeAPIClient.h"
#import "SHUtilities.h"

static NSString *baseGroupPathString = @"/api/group";

@implementation SHGroup

- (instancetype)initWithAttributes:(id)attributes
{
    self = [super init];
    if(!self){
        return nil;
    }
    
    self.Id             = NilToEmptyString(attributes[@"id"]);
    self.ownerId        = NilToEmptyString(attributes[@"ownerId"]);
    self.name           = NilToEmptyString(attributes[@"name"]);
    self.folders        = JSONToArrayOrEmpty([attributes[@"folders"] allObjects]);
    self.repoProvider   = SHRepoProviderFromString(NilToEmptyString(attributes[@"repoProvider"]));
    self.createdAt      = dateString([NilToEmptyString(attributes[@"createdAt"]) doubleValue]);//format date
    self.updatedAt      = dateString([NilToEmptyString(attributes[@"updatedAt"]) doubleValue]);//format date
    self.addlAttributes = JSONToDictionaryOrEmpty(attributes[@"attributes"]);
    
    return self;
}

#pragma mark - APIs

+ (void)getGroupWithId:(NSString *)groupId completionBlock:(void (^)(SHGroup *, NSError *))completion {
    NSString *path = [baseGroupPathString stringByAppendingPathComponent:groupId];
    [[SHUbeAPIClient sharedClient] GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        SHGroup *group = [[SHGroup alloc] initWithAttributes:responseObject];
        completion(group, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
}

+ (void)getUserGroupsWithCompletionBlock:(void (^)(NSArray *, NSError *))completion {
    [[SHUbeAPIClient sharedClient] GET:baseGroupPathString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray         *allGroups  = JSONToArrayOrEmpty([responseObject allObjects]);
        NSMutableArray  *groups     = [[NSMutableArray alloc] initWithCapacity:allGroups.count];
        [allGroups enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SHGroup *group = [[SHGroup alloc] initWithAttributes:obj];
            if (group) {
                [groups addObject:group];
            }
        }];
        completion(groups, task.error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
}
@end
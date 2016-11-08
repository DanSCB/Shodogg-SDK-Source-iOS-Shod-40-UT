//
//  SHClientInformation.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 9/16/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import "SHClientInformation.h"
#import "SHUtilities.h"

@implementation SHClientInformation

+ (SHClientInformation *)fromJSON:(id)JSON {

    SHClientInformation *clientInfo = [[SHClientInformation alloc] init];
    [clientInfo setID:NilToEmptyString(JSON[@"id"])];
    [clientInfo setCreatedAt:dateFromTimeInterval([JSON[@"createdAt"] doubleValue])];
    [clientInfo setUpdatedAt:dateFromTimeInterval([JSON[@"updatedAt"] doubleValue])];
    [clientInfo setAttributes:JSONToDictionaryOrEmpty(JSON[@"attributes"])];
    
    return clientInfo;
}
@end
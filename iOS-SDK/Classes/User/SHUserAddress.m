//
//  SHUserAddress.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 9/16/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import "SHUserAddress.h"
#import "SHUtilities.h"

@implementation SHUserAddress

+ (SHUserAddress *)fromJSON:(id)JSON {
    
    SHUserAddress *userAddress  = [[SHUserAddress alloc] init];
    [userAddress setID:NilToEmptyString([JSON objectForKey:@"id"])];
    [userAddress setUbeDescription:NilToEmptyString([JSON objectForKey:@"description"])];
    [userAddress setCountry:NilToEmptyString([JSON objectForKey:@"country"])];
    [userAddress setCity:NilToEmptyString([JSON objectForKey:@"city"])];
    [userAddress setState:NilToEmptyString([JSON objectForKey:@"state"])];
    [userAddress setPostalCode:NilToEmptyString([JSON objectForKey:@"postalCode"])];
    [userAddress setStreet1:NilToEmptyString([JSON objectForKey:@"street1"])];
    [userAddress setStreet2:NilToEmptyString([JSON objectForKey:@"street2"])];
    [userAddress setCreatedAt:dateFromTimeInterval([JSON[@"createdAt"] doubleValue])];
    [userAddress setUpdatedAt:dateFromTimeInterval([JSON[@"updatedAt"] doubleValue])];
    [userAddress setAttributes:JSONToDictionaryOrEmpty([JSON objectForKey:@"attributes"])];
    
    return userAddress;
}
@end
//
//  SHDropboxAccountDTO.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 12/10/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import "SHDropboxAccountDTO.h"
#import "SHUtilities.h"

@implementation SHDropboxAccountDTO
+ (SHDropboxAccountDTO *)fromJSON:(id)JSON {
    SHDropboxAccountDTO *accountInfo = [[SHDropboxAccountDTO alloc] init];
    [accountInfo setCountry:NilToEmptyString([JSON objectForKey:@"country"])];
    [accountInfo setDisplayName:NilToEmptyString([JSON objectForKey:@"displayName"])];
    [accountInfo setQuota:[NSNumber numberWithLong:[[JSON objectForKey:@"quota"] longValue]]];
    [accountInfo setQuotaNormal:[NSNumber numberWithLong:[[JSON objectForKey:@"quotaNormal"] longValue]]];
    [accountInfo setQuotaShared:[NSNumber numberWithLong:[[JSON objectForKey:@"quotaShared"] longValue]]];
    [accountInfo setUid:[NSNumber numberWithLong:[[JSON objectForKey:@"uid"] longValue]]];
    [accountInfo setReferralLink:NilToEmptyString([JSON objectForKey:@"referralLink"])];
    
    return accountInfo;
}
@end
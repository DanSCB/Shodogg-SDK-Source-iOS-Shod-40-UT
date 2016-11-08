//
//  SHDropboxAccountDTO.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 12/10/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHDropboxAccountDTO : NSObject
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSNumber *quota;
@property (nonatomic, copy) NSNumber *quotaNormal;
@property (nonatomic, copy) NSNumber *quotaShared;
@property (nonatomic, copy) NSNumber *uid;
@property (nonatomic, copy) NSString *referralLink;

+ (SHDropboxAccountDTO *)fromJSON:(id)JSON;
@end
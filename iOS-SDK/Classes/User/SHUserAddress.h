//
//  SHUserAddress.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 9/16/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHUserAddress : NSObject

@property (nonatomic,   copy) NSString      *ID;
@property (nonatomic,   copy) NSString      *ubeDescription;
@property (nonatomic,   copy) NSString      *street1;
@property (nonatomic,   copy) NSString      *street2;
@property (nonatomic,   copy) NSString      *city;
@property (nonatomic,   copy) NSString      *state;
@property (nonatomic,   copy) NSString      *postalCode;
@property (nonatomic,   copy) NSString      *country;
@property (nonatomic, strong) NSDate        *createdAt;
@property (nonatomic, strong) NSDate        *updatedAt;
@property (nonatomic,   copy) NSDictionary  *attributes;

+ (SHUserAddress *)fromJSON:(id)JSON;

@end
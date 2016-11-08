//
//  SHClientInformation.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 9/16/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHClientInformation : NSObject

@property (nonatomic,   copy) NSString      *ID;
@property (nonatomic, strong) NSDate        *createdAt;
@property (nonatomic, strong) NSDate        *updatedAt;
@property (nonatomic, strong) NSDictionary  *attributes;

+ (SHClientInformation *)fromJSON:(id)JSON;
@end
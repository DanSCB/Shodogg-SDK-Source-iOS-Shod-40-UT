//
//  SHMobileDeviceInfoDTO.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 11/13/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHMobileDeviceInfoDTO : NSObject

@property (nonatomic, readonly) NSString *udid;
@property (nonatomic, readonly) NSString *model;
@property (nonatomic, readonly) NSString *modelName;
@property (nonatomic, readonly) NSString *systemName;
@property (nonatomic, readonly) NSString *systemVersion;
@property (nonatomic, readonly) NSString *appName;
@property (nonatomic, readonly) NSString *appVersion;
@property (nonatomic, readonly) NSString *cellular;
@property (nonatomic, readonly) NSString *carrier;
@property (nonatomic, readonly) NSDictionary *addlInfo;

+ (instancetype)sharedInstance;
+ (NSDictionary *)mobileInfoDictionary;
- (instancetype)initWithMobileDeviceInfo;
@end
//
//  SHScreenSesssion.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 10/3/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHScreen.h"
#import "SHMobileCommand.h"

@interface SHScreenSesssion : NSObject

@property (nonatomic,   copy) NSString          *Id;
@property (nonatomic,   copy) NSString          *userId;
@property (nonatomic,   copy) NSString          *createdAt;
@property (nonatomic,   copy) NSString          *updatedAt;
@property (nonatomic, strong) NSDictionary      *attributes;
@property (nonatomic, strong) NSArray           *screens;
@property (nonatomic, strong) NSArray           *activeScreens;
@property (nonatomic, strong) NSArray           *unauthorizedSessionTokenIds;
@property (nonatomic, strong) SHMobileCommand   *lastCommand;
@property (nonatomic, assign) BOOL              active;
@property (nonatomic, assign) BOOL              locked;

+ (SHScreenSesssion *)fromJSON:(id)JSON;
+ (NSURL *)generateCurrentScreenSessionURL;
+ (NSString *)getCurrentScreenSessionId;
+ (void)saveCurrentScreenSessionId:(NSString *)sessionId;
+ (void)removeCurrentScreenSessionId;
@end
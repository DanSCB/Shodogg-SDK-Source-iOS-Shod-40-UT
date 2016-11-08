//
//  SHMobileCommand.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 12/12/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHMobileCommand : NSObject

@property (nonatomic,   copy) NSString       *screenSessionId;
@property (nonatomic,   copy) NSString       *screenId;
@property (nonatomic,   copy) NSString       *timestamp;
@property (nonatomic,   copy) NSString       *cmd;
@property (nonatomic, strong) NSDictionary   *cmdParams;
@property (nonatomic, strong) NSMutableArray *states;

+ (SHMobileCommand *)fromJSON:(id)JSON;
+ (NSDictionary *)commandAsDictionaryForScreenAssetStates:(NSArray *)states;
@end
//
//  SHMCOAccountDetails.h
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 10/29/15.
//  Copyright © 2015 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHMCOAccountDetails : NSObject

@property (nonatomic, copy) NSString *mcoAppPublicKey;

+ (instancetype)accountWithAppPublicKey:(NSString *)key;

- (instancetype)initWithAppPublicKey:(NSString *)key;

@end
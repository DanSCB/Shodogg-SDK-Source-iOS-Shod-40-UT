//
//  SHMCOAccountDetails.m
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 10/29/15.
//  Copyright © 2015 Shodogg. All rights reserved.
//

#import "SHMCOAccountDetails.h"

@implementation SHMCOAccountDetails


+ (instancetype)accountWithAppPublicKey:(NSString *)key {
    
    return [[self alloc] initWithAppPublicKey:key];
}

- (instancetype)initWithAppPublicKey:(NSString *)key {
    
    if (self = [super init]) {
        
        self.mcoAppPublicKey = key;
    }
    
    return self;
}
@end
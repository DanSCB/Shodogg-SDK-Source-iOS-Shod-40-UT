//
//  SDRemoteReceiverChromecast.m
//  ShodoggSDK
//
//  Created by Artem Stepuk on 11/19/15.
//  Copyright © 2015 stepukaa. All rights reserved.
//

#import "SDRemoteReceiverChromecast.h"

@implementation SDRemoteReceiverChromecast

- (instancetype)initWithIdentifier:(NSString*)identifier
                        parameters:(NSDictionary*)parameters {
    self = [super initWithParameters:parameters];
    if (self) {
        _identifier = identifier;
    }
    
    return self;
}

@end

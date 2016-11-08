//
//  SDRemoteReceiverBase.m
//  ShodoggSDK
//
//  Created by Artem Stepuk on 11/19/15.
//  Copyright © 2015 stepukaa. All rights reserved.
//

#import "SDRemoteReceiver.h"

NSString *const SDParameterAttendeeName = @"an";
NSString *const SDParameterRemoteAppUrl = @"ShodoggRemoteAppUrl";

@implementation SDRemoteReceiver

- (instancetype)initWithParameters:(NSDictionary*)parameters {
    self = [super init];
    if (self) {
        _parameters = parameters;
    }
    return self;
}

@end

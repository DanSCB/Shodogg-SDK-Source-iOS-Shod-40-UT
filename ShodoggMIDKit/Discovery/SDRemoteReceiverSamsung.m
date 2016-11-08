//
//  SDRemoteReceiverSamsung.m
//  ShodoggSDK
//
//  Created by Artem Stepuk on 11/19/15.
//  Copyright © 2015 stepukaa. All rights reserved.
//

#import "SDRemoteReceiverSamsung.h"

@implementation SDRemoteReceiverSamsung

- (instancetype)initWithCloudIdentifier:(NSString*)cloudIdentifier
                       nativeIdentifier:(NSString*)nativeIdentifier
                             channelURI:(NSString*)channelURI
                              paramters:(NSDictionary*)parameters {
    self = [super initWithParameters:parameters];
    if (self) {
        _nativeIdentifier = nativeIdentifier;
        _cloudIdentifier = cloudIdentifier;
        _channelURI = channelURI;
    }
    
    return self;
}


@end

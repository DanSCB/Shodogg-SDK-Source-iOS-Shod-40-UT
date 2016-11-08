//
//  SDRemoteReceiverFireTV.h
//  ShodoggSDK
//
//  Created by Artem Stepuk on 11/19/15.
//  Copyright © 2015 stepukaa. All rights reserved.
//

@import Foundation;

#import "SDRemoteReceiver.h"

/**
 *  Fire TV applciation launch setting representation.
 */
@interface SDRemoteReceiverFireTV : SDRemoteReceiver

/**
 *  Application identifier.
 *  In current implementation communication with FireTV is working by DIAL.
 *  see: https://developer.amazon.com/public/solutions/devices/fire-tv/docs/dial-integration
 */
@property(nonatomic, strong)NSString *identifier;

/**
 *  Init method
 *
 *  @param identifier NSString
 *  @param parameters NSDictionary
 *
 *  @return SDRemoteReceiverFireTV
 */
- (instancetype)initWithIdentifier:(NSString*)identifier
                        parameters:(NSDictionary*)parameters;

@end

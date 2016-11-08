//
//  SDRemoteReceiverBase.h
//  ShodoggSDK
//
//  Created by Artem Stepuk on 11/19/15.
//  Copyright © 2015 stepukaa. All rights reserved.
//

@import Foundation;

/**
 *    Parameter identifier for Attendee name.
 */
extern NSString *const SDParameterAttendeeName;

/**
 *    Parameter identifier for Remote Application URL.
 */
extern NSString *const SDParameterRemoteAppUrl;

/**
 *  Base class which represents remote receiver launch parameters
 */
@interface SDRemoteReceiver : NSObject

/**
 *  NSDictionary with remote application launch parameter
 *  Will be sent in different way depending of device type.
 */
@property(nonatomic, strong) NSDictionary *parameters;

/**
 *  Initializer
 *
 *  @param parameters NSDictionary
 *
 *  @return SDRemoteReceiver
 */
- (instancetype)initWithParameters:(NSDictionary*)parameters;

@end
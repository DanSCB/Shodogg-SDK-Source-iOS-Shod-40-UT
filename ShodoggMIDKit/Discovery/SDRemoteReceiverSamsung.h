//
//  SDRemoteReceiverSamsung.h
//  ShodoggSDK
//
//  Created by Artem Stepuk on 11/19/15.
//  Copyright © 2015 stepukaa. All rights reserved.
//

@import Foundation;

#import "SDRemoteReceiver.h"

/**
 *  Samsung Tizen applciation launch setting representation.
 *  Samsung define two kinds of application: Cloud and Native. Cloud apps are website in fact with
 *  integrated Multiscreen js SDK. Native apps are currently out of scope, but stub has been created.
 */
@interface SDRemoteReceiverSamsung : SDRemoteReceiver

/**
 *  NSString with cloud app identifier (in fact web site URL)
 */
@property(nonatomic, strong)NSString *cloudIdentifier;

/**
 *  NSString with native app identifier (installed on Tizen platform). 
 *  Communication is not implemented.
 */
@property(nonatomic, strong)NSString *nativeIdentifier;

/**
 *  NSString with communication channel URI (is used by remote app for websocket communication)
 *  This value has to be conformed with remote app developers.
 */
@property(nonatomic, strong)NSString *channelURI;

/**
 *  Init methid
 *
 *  @param cloudIdentifier  NSString
 *  @param nativeIdentifier NSString
 *  @param channelURI       NSString
 *  @param parameters       NSDictionary
 *
 *  @return SDRemoteReceiverSamsung
 */
- (instancetype)initWithCloudIdentifier:(NSString*)cloudIdentifier
                       nativeIdentifier:(NSString*)nativeIdentifier
                             channelURI:(NSString*)channelURI
                              paramters:(NSDictionary*)parameters;

@end

//
//  SDRemoteReceiverChromecast.h
//  ShodoggSDK
//
//  Created by Artem Stepuk on 11/19/15.
//  Copyright © 2015 stepukaa. All rights reserved.
//

@import Foundation;

#import "SDRemoteReceiver.h"

/**
 *  Google chromecast applciation launch setting representation.
 *  App ID is generated in Chromecast developer console https://cast.google.com/publish/#/signup
 */
@interface SDRemoteReceiverChromecast : SDRemoteReceiver

/**
 *  Application identifier.
 */
@property(nonatomic, strong)NSString *identifier;

/**
 *  Init method
 *
 *  @param identifier NSString
 *  @param parameters NSDictionary
 *
 *  @return SDRemoteReceiverLG
 */
- (instancetype)initWithIdentifier:(NSString*)identifier
                        parameters:(NSDictionary*)parameters;

@end

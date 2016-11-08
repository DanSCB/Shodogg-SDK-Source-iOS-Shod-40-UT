//
//  SDRemoteReceiverLG.h
//  ShodoggSDK
//
//  Created by Artem Stepuk on 11/19/15.
//  Copyright © 2015 stepukaa. All rights reserved.
//

@import Foundation;

#import "SDRemoteReceiver.h"

/**
 *  LG WebOS TV applciation launch setting representation.
 */
@interface SDRemoteReceiverLG : SDRemoteReceiver

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

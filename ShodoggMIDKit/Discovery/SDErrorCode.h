//
//  SDErrorCode.h
//  ShodoggSDK
//
//  Created by Artem Stepuk on 11/9/15.
//  Copyright © 2015 stepukaa. All rights reserved.
//

#ifndef SDErrorCode_h
#define SDErrorCode_h

extern NSString * const SDErrorDomain;

/**
 *  Shodogg SDK error code statuses. See localizedDescription for details.
 */
typedef NS_ENUM(NSUInteger, SDStatusCodeError) {
    /**
     *  Generic error.
     */
    SDStatusCodeErrorGeneric = 1000,
    /**
     *  Remote device experience the problem.
     */
    SDStatusCodeErrorTV = 1001,
    /**
     *  SSL certificate error.
     */
    SDStatusCodeErrorCertificate = 1002,
    /**
     *  Web socket connection error.
     */
    SDStatusCodeErrorSocket = 1003,
    /**
     *  Requested action not supported error.
     */
    SDStatusCodeErrorNotSupported = 1100,
    /**
     *  Provided arguments error.
     */
    SDStatusCodeErrorArgument = 1101,
    /**
     *  Device is not connected error.
     */
    SDStatusCodeErrorNotConnected = 1102
};

#endif /* SDErrorCode_h */

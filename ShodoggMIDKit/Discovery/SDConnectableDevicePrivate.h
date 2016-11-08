//
//  SDConnectableDevicePrivate.h
//  ShodoggSDK
//
//  Created by stepukaa on 10/27/15.
//  Copyright © 2015 stepukaa. All rights reserved.
//

#ifndef SDConnectableDevicePrivate_h
#define SDConnectableDevicePrivate_h

@class SDConnectableDevice;
@class ConnectableDevice;

@interface SDConnectableDevice ()

@property(nonatomic, strong)ConnectableDevice *connectSDKDevice;

- (instancetype)initWithDevice:(ConnectableDevice*)device;

@end

#endif /* SDConnectableDevicePrivate_h */

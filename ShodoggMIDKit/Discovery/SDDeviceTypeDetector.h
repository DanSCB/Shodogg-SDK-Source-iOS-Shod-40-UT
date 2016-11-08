//
//  SDDeviceTypeDetector.h
//  ShodoggSDK
//
//  Created by stepukaa on 11/6/15.
//  Copyright © 2015 stepukaa. All rights reserved.
//

@import Foundation;
#import "SDConnectableDevice.h"

@class ConnectableDevice;

@interface SDDeviceTypeDetector : NSObject

+ (SDConnectableDeviceType)deviceTypeFromDevice:(ConnectableDevice*)cSDKDevice;

@end

//
//  SDDeviceTypeDetector.m
//  ShodoggSDK
//
//  Created by stepukaa on 11/6/15.
//  Copyright © 2015 stepukaa. All rights reserved.
//

#import "SDDeviceTypeDetector.h"

@implementation SDDeviceTypeDetector

+ (SDConnectableDeviceType)deviceTypeFromDevice:(ConnectableDevice*)cSDKDevice {
    for (DeviceService *service in cSDKDevice.services) {
        if ([service isKindOfClass:[CastService class]]) {
            return SDConnectableDeviceChromecast;
        }
        
        if ([service isKindOfClass:[WebOSTVService class]]) {
            return SDConnectableDeviceLG;
        }
        
        if ([service isKindOfClass:[SamsungService class]]) {
            return SDConnectableDeviceSamsung;
        }
    }
    
    for (DeviceService *service in cSDKDevice.services) {
        if ([service isKindOfClass:[DIALService class]]) {
            return SDConnectableDeviceFireTV;
        }
    }
    
    return SDConnectableDeviceUndefined;
}

@end

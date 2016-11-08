//
//  SDDiscoveryManager.h
//  ShodoggSDK
//
//  Created by stepukaa on 10/26/15.
//  Copyright © 2015 stepukaa. All rights reserved.
//

@import Foundation;

@class SDDeviceManager;
@class SDConnectableDevice;

/**
 *    SDDeviceManager delegate notification messages.
 */
@protocol SDDiscoveryManagerDelegate <NSObject>

@required

/**
 *    Delegate notification when manager has found the device.
 *
 *    @param manager SDDeviceManager
 *    @param device  SDConnectableDevice
 */
- (void)discoveryManager:(SDDeviceManager*)manager didFindDevice:(SDConnectableDevice*)device;

/**
 *    Delegate notification when manager has lost the device.
 *
 *    @param manager SDDeviceManager
 *    @param device  SDConnectableDevice
 */
- (void)discoveryManager:(SDDeviceManager *)manager didLostDevice:(SDConnectableDevice *)device;

/**
 *    Delegate notification when manager updated a device.
 *
 *    @param manager SDDeviceManager
 *    @param device  SDConnectableDevice
 */
- (void)discoveryManager:(SDDeviceManager *)manager didUpdateDevice:(SDConnectableDevice *)device;

/**
 *    Delegate notification when error happen on discovery phase.
 *
 *    @param manager SDDeviceManager
 *    @param error   NSError with cause details.
 */
- (void)discoveryManager:(SDDeviceManager *)manager didError:(NSError*)error;

@end

/**
 *    Singleton object that responsible for device discovery and connection.
 */
@interface SDDeviceManager : NSObject

/**
 *    Delegate object that confirms to protocol <SDDiscoveryManagerDelegate>.
 */
@property(nonatomic, weak)id<SDDiscoveryManagerDelegate> delegate;

/**
 *    SDDeviceManager is the singleton object by it's nature. 
 *    This method is the only proper way to get it.
 *
 *    @return SDDeviceManager singleton.
 */
+ (instancetype)sharedInstance;

/**
 *    Collection of already found devices.
 *
 *    @return NSArray of SDConnectableDevice objects sorted by name in ascending way.
 */
- (NSArray<__kindof SDConnectableDevice*>*)detectedDevices;

/**
 *    Currently connected device, nil if no device is connected.
 *
 *    @return SDConnectableDevice.
 */
- (SDConnectableDevice*)connectedDevice;

/**
 *    Start discovery in LAN. (Device that is expected to be found should be in the same LAN).
 */
- (void)startDiscovery;

/**
 *    Stop discovery in LAN.
 */
- (void)stopDiscovery;

/**
 *    Connect device. Connection itself is async operation. You should listen
 *
 *    @param device SDConnectableDevice
 */
- (void)connectDevice:(SDConnectableDevice*)device;

/**
 *    Disconnect currently connected device, if it exist.
 */
- (void)disconnectDevice;

@end
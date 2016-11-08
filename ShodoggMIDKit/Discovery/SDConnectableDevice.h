//
//  SDConnectableDevice.h
//  ShodoggSDK
//
//  Created by stepukaa on 10/26/15.
//  Copyright © 2015 stepukaa. All rights reserved.
//

@import Foundation;

@class SDRemoteReceiver;
@class SDConnectableDevice;

/**
 *    Supported device types enumerator.
 */
typedef NS_ENUM(NSUInteger, SDConnectableDeviceType) {
    /**
     *    Device type is unknown.
     */
    SDConnectableDeviceUndefined,
    /**
     *    Amazone Fire TV stick.
     */
    SDConnectableDeviceFireTV,
    /**
     *    LG Smart tv on WebOS platform (verified with 1.3 and 1.4 OS versions).
     */
    SDConnectableDeviceLG,
    /**
     *    Google Chromecast stick.
     */
    SDConnectableDeviceChromecast,
    /**
     *    Samsung Tizen Devices.
     */
    SDConnectableDeviceSamsung,
};

/**
 *    Completion handler for actions with SDConnectableDevice (e.g. launchApp/closeApp etc...)
 *
 *    @param success BOOL with action result.
 *    @param error   NSError in case of failed result.
 */
typedef void (^SDConnectableDeviceActionCompletion)(BOOL success, NSError *error);

/**
 *    SDConnectableDevice delegate protocol.
 */
@protocol SDConnectableDeviceProtocol <NSObject>

/**
 *    Delegate message that device is ready to communicate.
 *
 *    @param device SDConnectableDevice which is ready.
 */
- (void)connectableDeviceReady:(SDConnectableDevice*)device;

/**
 *    Delegate message that device has failed to establish connection with remote receiver.
 *
 *    @param device SDConnectableDevice that has failed to connect.
 *    @param error  NSError with cause description.
 */
- (void)connectableDevice:(SDConnectableDevice*)device connectionFailedWithError:(NSError*)error;

/**
 *    Delegate message that device has been disconnected.
 *
 *    @param device SDConnectableDevice that has been disconnected.
 *    @param error  NSError with cause description.
 */
- (void)connectableDeviceDisconnected:(SDConnectableDevice*)device withError:(NSError*)error;

@end

/**
 *    Object which represents the device in local network to which we are capable to connect.
 */
@interface SDConnectableDevice : NSObject

/**
 *    Delegate object which confirms to <SDConnectableDeviceProtocol>.
 */
@property(nonatomic, weak)id<SDConnectableDeviceProtocol> delegate;

/**
 *    NSString with friendly name of the device.
 */
@property(nonatomic, strong, readonly)NSString *friendlyName;

/**
 *    NSString with model name.
 */
@property(nonatomic, strong, readonly)NSString *modelName;

/**
 *    NSString with model number.
 */
@property(nonatomic, strong, readonly)NSString *modelNumber;

@property(nonatomic, strong, readonly)NSString *ipAddr;

/**
 *    SDConnectableDeviceType device type.
 */
@property(nonatomic, assign, readonly)SDConnectableDeviceType deviceType;

/**
 *  Remote receiver settings (app name / start params).
 *  Need to be set before install/launch/close command.
 */
@property(nonatomic, strong, readwrite)SDRemoteReceiver *receiver;

/**
 *    Request device to install application with particular settings (application name).
 *    Not implemented.
 *
 *    @param completion SDConnectableDeviceActionCompletion - callback on completion.
 */
- (void)installApplicationWithCompletion:(SDConnectableDeviceActionCompletion)completion;

/**
 *    Request device to launch application with particular settings (application name).
 *
 *    @param completion SDConnectableDeviceActionCompletion - callback on completion.
 */
- (void)launchApplicationWithCompletion:(SDConnectableDeviceActionCompletion)completion;

/**
 *    Request device to close application with particular settings (application name).
 *
 *    @param completion SDConnectableDeviceActionCompletion - callback on completion.
 */
- (void)closeApplicationWithCompletion:(SDConnectableDeviceActionCompletion)completion;

@end

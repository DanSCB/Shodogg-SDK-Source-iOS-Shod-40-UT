//
//  SDConnectableDevice.m
//  ShodoggSDK
//
//  Created by stepukaa on 10/26/15.
//  Copyright © 2015 stepukaa. All rights reserved.
//

#import "SDConnectableDevice.h"
#import "SDRemoteReceiver.h"
#import "SDLauncher.h"
#import "SDError.h"
#import "SDDeviceTypeDetector.h"

@interface SDConnectableDevice() <ConnectableDeviceDelegate>

@property(nonatomic, strong)ConnectableDevice *connectSDKDevice;
@property(nonatomic, strong)SDLauncher *launcher;

@end

@implementation SDConnectableDevice

#pragma mark - Initialization

- (instancetype)init {
    NSAssert(NO, @"This class has private constructor");
    return nil;
}

- (instancetype)initWithDevice:(ConnectableDevice*)device {
    self = [super init];
    if (self) {
        _connectSDKDevice = device;
        device.delegate = self;
    }
    return self;
}

#pragma mark - Public Interface

- (NSString*)friendlyName {
    return self.connectSDKDevice.friendlyName;
}

- (NSString*)modelName {
    return self.connectSDKDevice.modelName;
}

- (NSString*)modelNumber {
    return self.connectSDKDevice.modelNumber;
}

- (NSString *)ipAddr {
    return self.connectSDKDevice.address;
}

- (SDConnectableDeviceType)deviceType {
    return [SDDeviceTypeDetector deviceTypeFromDevice:self.connectSDKDevice];
}

- (void)installApplicationWithCompletion:(SDConnectableDeviceActionCompletion)completion {
    [self.launcher installApplication:self.receiver
                             onDevice:self.connectSDKDevice
                       withCompletion:completion];
}

- (void)launchApplicationWithCompletion:(SDConnectableDeviceActionCompletion)completion {
    [self.launcher launchApplication:self.receiver
                            onDevice:self.connectSDKDevice
                      withCompletion:completion];
}

- (void)closeApplicationWithCompletion:(SDConnectableDeviceActionCompletion)completion {
    [self.launcher closeApplication:self.receiver
                           onDevice:self.connectSDKDevice
                     withCompletion:completion];
}

#pragma mark - <ConnectableDeviceDelegate>

- (void)connectableDeviceReady:(ConnectableDevice*)device {
    [self.delegate connectableDeviceReady:self];
}

- (void)connectableDeviceDisconnected:(ConnectableDevice*)device withError:(NSError*)error {
    [self.delegate connectableDeviceDisconnected:self
                                       withError:[SDError wrappedErrorForError:error]];
}

- (void) connectableDevice:(ConnectableDevice *)device connectionFailedWithError:(NSError *)error {
    [self.delegate connectableDevice:self
           connectionFailedWithError:[SDError wrappedErrorForError:error]];
}

#pragma mark -

- (void)connectableDeviceConnectionSuccess:(ConnectableDevice*)device
                                forService:(DeviceService*)service {
    self.launcher = [SDLauncher launcherForDevice:device];
}

- (void) connectableDevice:(ConnectableDevice*)device
                   service:(DeviceService *)service
     disconnectedWithError:(NSError*)error {
    //???: this callback come twice :\ need to debug connect sdk
}

@end

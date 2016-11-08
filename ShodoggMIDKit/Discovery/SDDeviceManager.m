//
//  SDDiscoveryManager.m
//  ShodoggSDK
//
//  Created by stepukaa on 10/26/15.
//  Copyright © 2015 stepukaa. All rights reserved.
//

#import "SDDeviceManager.h"
#import "SDConnectableDevice.h"
#import "SDConnectableDevicePrivate.h"
#import "SDError.h"

@interface SDDeviceManager () <DiscoveryManagerDelegate>

@property(nonatomic, strong)NSMutableDictionary *detectedConnectableDevices;
@property(atomic, strong)SDConnectableDevice *connectedDevice;
@property(nonatomic, strong)DiscoveryManager *discoveryManager;

@end

@implementation SDDeviceManager

static SDDeviceManager *staticDeviceManager = nil;

#pragma mark - Instantiation / Initialization

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticDeviceManager = [[SDDeviceManager alloc] initDefaults];
    });
    return staticDeviceManager;
}

- (instancetype)init {
    NSAssert(NO, @"Please use sharedInstance class method instead.");
    return nil;
}

- (instancetype)initDefaults {
    self = [super init];
    if (self) {
        _discoveryManager = [DiscoveryManager sharedManager];
        _discoveryManager.delegate = self;
        _detectedConnectableDevices = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - Public Interface

- (void)startDiscovery {
    [self.discoveryManager startDiscovery];
}

- (void)stopDiscovery {
    [self.discoveryManager stopDiscovery];
}

- (NSArray*)detectedDevices {
    //TODO: we can accept descriptor or comporator as a parameter...
    NSSortDescriptor *nameDesc =
        [[NSSortDescriptor alloc] initWithKey:NSStringFromSelector(@selector(friendlyName))
                                    ascending:YES];
    
    return [[self.detectedConnectableDevices allValues] sortedArrayUsingDescriptors:@[nameDesc]];
}

- (void)connectDevice:(SDConnectableDevice*)device {
    [device.connectSDKDevice connect];
    self.connectedDevice = device;
}

- (void)disconnectDevice {
    [self.connectedDevice.connectSDKDevice disconnect];
    self.connectedDevice = nil;
}

#pragma mark - Private Section

- (SDConnectableDevice *)createDeviceWithDevice:(ConnectableDevice *)cSDKDevice {
    SDConnectableDevice *sdSDKDevice = [[SDConnectableDevice alloc] initWithDevice:cSDKDevice];
    @synchronized(self.detectedConnectableDevices) {
        [self.detectedConnectableDevices setObject:sdSDKDevice forKey:cSDKDevice.id];
    }
    return sdSDKDevice;
}

- (SDConnectableDevice *)updateDeviceWithDevice:(ConnectableDevice *)cSDKDevice {
    SDConnectableDevice *sdSDKDevice = [[SDConnectableDevice alloc] initWithDevice:cSDKDevice];
    @synchronized(self.detectedConnectableDevices) {
        [self.detectedConnectableDevices setObject:sdSDKDevice forKey:cSDKDevice.id];
    }
    return sdSDKDevice;
}

- (SDConnectableDevice *)deleteDevice:(ConnectableDevice *)cSDKDevice {
    SDConnectableDevice *sdSDKDevice = [self.detectedConnectableDevices objectForKey:cSDKDevice.id];
    @synchronized(self.detectedConnectableDevices) {
        NSLog(@"%s \n %@|%@", __PRETTY_FUNCTION__, cSDKDevice.friendlyName, cSDKDevice.id);
        [self.detectedConnectableDevices removeObjectForKey:cSDKDevice.id];
    }
    
    return sdSDKDevice;
}

#pragma mark - <DiscoveryManagerDelegate>

- (void)discoveryManager:(DiscoveryManager *)manager
           didFindDevice:(ConnectableDevice *)cSDKDevice {
    NSLog(@"%s \n %@|%@", __PRETTY_FUNCTION__, cSDKDevice.friendlyName, cSDKDevice.address);
    SDConnectableDevice *sdSDKDevice = [self createDeviceWithDevice:cSDKDevice];
    [self.delegate discoveryManager:self didFindDevice:sdSDKDevice];
}

- (void)discoveryManager:(DiscoveryManager *)manager
         didUpdateDevice:(ConnectableDevice *)cSDKDevice {
    //AK: Original comment by cogniance
    //???: Connect SDK treat this callback as @required
    NSLog(@"%s \n %@|%@", __PRETTY_FUNCTION__, cSDKDevice.friendlyName, cSDKDevice.address);
    SDConnectableDevice *sdSDKDevice = [self updateDeviceWithDevice:cSDKDevice];
    if (!sdSDKDevice.connectSDKDevice.isConnectable) {
        [self deleteDevice:cSDKDevice];
    }
    [self.delegate discoveryManager:self didUpdateDevice:sdSDKDevice];
}

- (void)discoveryManager:(DiscoveryManager *)manager
           didLoseDevice:(ConnectableDevice *)cSDKDevice {
    NSLog(@"%s \n %@|%@", __PRETTY_FUNCTION__, cSDKDevice.friendlyName, cSDKDevice.address);
    SDConnectableDevice *sdSDKDevice = [self deleteDevice:cSDKDevice];
    [self.delegate discoveryManager:self didLostDevice:sdSDKDevice];
}

- (void)discoveryManager:(DiscoveryManager *)manager
        didFailWithError:(NSError*)error {
    NSLog(@"%s - \n %@", __PRETTY_FUNCTION__, error);
    [self.delegate discoveryManager:self didError:[SDError wrappedErrorForError:error]];
}

@end
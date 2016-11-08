//
//  SamsungDiscoveryProvider.m
//  ConnectSDK
//
//  Created by Artem Stepuk on 11/13/15.
//  Copyright © 2015 LG Electronics. All rights reserved.
//

#import "SamsungDiscoveryProvider.h"
#import "ServiceDescription.h"
#import "SamsungService.h"
//#import <MSF/MSF-Swift.h>
#import <SmartView/SmartView-Swift.h>

@interface SamsungDiscoveryProvider () <ServiceSearchDelegate>

@property(nonatomic, strong)ServiceSearch *serviceDiscovery;

@property(nonatomic, strong)NSMutableDictionary *foundServices;
@property(nonatomic, strong)NSMutableDictionary *foundServiceDescriptions;

@end

@implementation SamsungDiscoveryProvider

- (instancetype)init {
    self = [super init];
    if (self) {
        _serviceDiscovery = [Service search];
        _serviceDiscovery.delegate  = self;
    }
    
    return self;
}

- (void)startDiscovery {
    [self.serviceDiscovery start];
}

- (void)stopDiscovery {
    [self.serviceDiscovery stop];
}

#pragma mark - <ServiceSearchDelegate>

- (void)onServiceFound:(Service * __nonnull)service {
    NSURL *hostURL = [NSURL URLWithString:service.uri];
    ServiceDescription *description =
        [[ServiceDescription alloc] initWithAddress:hostURL.host UUID:service.id];
    
    description.serviceId = kSamsungServiceId;
    description.friendlyName = service.name;
    description.modelName = service.type;
    description.modelNumber = service.version;
    description.device = service;
    
    [self.foundServices setObject:service forKey:service.id];
    [self.foundServiceDescriptions setObject:description forKey:service.id];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate  discoveryProvider:self didFindService:description];
    });
}

- (void)onServiceLost:(Service * __nonnull)service {
    
    ServiceDescription *description = [self.foundServiceDescriptions objectForKey:service.id];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate discoveryProvider:self didLoseService:description];
    });
    
    [self.foundServices removeObjectForKey:service.id];
    [self.foundServiceDescriptions removeObjectForKey:service.id];
}

- (void)onStop {
    self.isRunning = NO;
}

- (void)onStart {
    self.isRunning = YES;
}

@end

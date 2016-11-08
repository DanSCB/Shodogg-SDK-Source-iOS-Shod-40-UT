//
//  SHMIDCastController.h
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 2/3/16.
//
//

#import <Foundation/Foundation.h>
#import "SDConnectableDevice.h"
#import "SHMIDMediaItem.h"
#import "SHMIDButton.h"

extern NSString* const kSHMIDHandleTargetCastDevicesChangeNotification;

@protocol SHMIDCastControllerDelegate <NSObject>

@optional

- (void)didConnectCastingDevice;
- (void)didDisconnectCastingDevice;
- (void)willLaunchDiscoveryController;

@end

@interface SHMIDCastController : NSObject

@property (weak) id <SHMIDCastControllerDelegate> delegate;

@property (nonatomic, readonly) SHMIDMediaItem *contextItem;

@property (nonatomic, readonly) UIViewController *viewController;

@property (nonatomic) CGPoint shodoggButtonCenter;

+ (instancetype)sharedInstance;

- (void)beginDiscovery;
- (SDConnectableDevice *)connectedDevice;
- (void)connectDevice:(SDConnectableDevice *)device;
- (NSArray<__kindof SDConnectableDevice *> *)detectedCastTargetDevices;
- (SHMIDButton *)getShodoggMIDButtonForController:(UIViewController *)controller;
- (SHMIDButton *)getShodoggMIDBarButtonForController:(UIViewController *)controller;
- (void)setContextItem:(SHMIDMediaItem *)contextItem;
- (BOOL)firstTimeUserExperienceCompleted;
- (void)resetFirstTimeUserExperience;
- (BOOL)screenCastInProgress;

@end
//
//  SHMIDCastController.m
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 2/3/16.
//
//

#import "SHMIDCastController.h"
#import "SHMIDWelcomeViewController.h"
#import "SHMIDHomeViewController.h"
#import "SHMIDRadialMenuViewController.h"
#import "SHMIDCastControlsView.h"
#import "SHMIDMTLDeviceDiscovery.h"
#import "SHMIDRLMDeviceGraphEvent.h"
#import "SHMIDMTLDataTrackingEventMetadata.h"
#import "SHMIDRLMDataTrackingEvent.h"
#import "SHMIDClient+DataRecorder.h"
#import "SDConnectableDevicePrivate.h"
#import "SDDeviceManager.h"
#import "SHMIDClient.h"
#import "SHMIDScreen.h"
#import "SHMIDUtilities.h"
#import "MBProgressHUD.h"

static  NSString *       kShodoggSamsungCloudAppID;
static  NSString * const kShodoggFireTVAppID                             = @"Shodogg";
static  NSString * const kShodoggLGTVAppID                               = @"com.oxagile.shodogg";
static  NSString * const kShodoggChromecastAppID                         = @"D7CACA60";
        NSString * const kSHMIDHandleTargetCastDevicesChangeNotification = @"kSHMIDHandleTargetCastDevicesChangeNotificationKey";
        NSString * const kSHMIDCompletedFisrtTimeUserExperience          = @"kSHMIDCompletedFisrtTimeUserExperienceKey";

@interface SHMIDCastController()
    <SHMIDScreenDelegate,
     SDConnectableDeviceProtocol,
     SHMIDCastControlsViewDelegate,
     SHMIDWelcomeViewControllerDelegate,
     SHMIDRadialMenuViewControllerDelegate>

@property (nonatomic, strong, readwrite) SHMIDMediaItem *contextItem;
@property (nonatomic, strong, readwrite) UIViewController *viewController;
@property (nonatomic, strong) SHMIDButton *shodoggMIDButton;
@property (nonatomic, strong) SHMIDButton *shodoggMIDBarButton;
@property (nonatomic, strong) SDDeviceManager *deviceManager;
@property (nonatomic, strong) SHMIDHomeViewController *homeViewController;
@property (nonatomic, strong) SHMIDRadialMenuViewController *radialMenuViewController;

@end

@implementation SHMIDCastController

+ (instancetype)sharedInstance {
    static SHMIDCastController *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)init {
    if (self = [super init]) {
        // MARK: Setup Screen Manager
        SHMIDScreen *screen = [[SHMIDScreen alloc] init];
        screen.delegate = self;
        [SHMIDScreen setSharedScreen:screen];
        // MARK: Shodogg MID Buttons
        [self createShodoggMIDButton];
        [self createShodoggMIDBarButton];
    }
    return self;
}

- (void)beginDiscovery {
    [self syncCurrentHousehold];
     self.deviceManager = [SDDeviceManager sharedInstance];
     self.deviceManager.delegate = self;
    [self.deviceManager startDiscovery];
}

- (void)syncCurrentHousehold {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[[SHMIDMTLHousehold alloc] initCurrentHousehold] save];
    });
}

- (void)setContextItem:(SHMIDMediaItem *)contextItem {
    _contextItem = contextItem;
}

#pragma mark - Long press

- (void)didInteractWithLongPressGesture:(UILongPressGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            [self presentRadialMenuViewController];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self.radialMenuViewController close];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self.radialMenuViewController moveAtPosition:[gesture locationInView:_radialMenuViewController.view]];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            [self.radialMenuViewController close];
        default:
            break;
    }
}

#pragma mark - Presentation

- (void)createShodoggMIDButton {
    NSString *offImageName = @"icon_cast1_off";
    NSString *onImageName = @"icon_cast1_on";
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didInteractWithLongPressGesture:)];
    self.shodoggMIDButton = [[SHMIDButton alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
    [self.shodoggMIDButton addTarget:self action:@selector(shodoggMIDButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.shodoggMIDButton addGestureRecognizer:longPressGesture];
    NSString *debugImageComponent = [[SHMIDClient sharedClient] launchButtonName];
    if (debugImageComponent) {
        offImageName = [NSString stringWithFormat:@"icon_%@_off", debugImageComponent];
        onImageName = [NSString stringWithFormat:@"icon_%@_on", debugImageComponent];
    }
    self.shodoggMIDButton.iconImageNameOff = offImageName;
    self.shodoggMIDButton.iconImageNameOn = onImageName;
}

- (void)createShodoggMIDBarButton {
    _shodoggMIDBarButton = [[SHMIDButton alloc] initWithFrame:CGRectMake(0, 0, 38, 38)];
    [_shodoggMIDBarButton setImageEdgeInsets:UIEdgeInsetsMake(12.0, 10.0, 12.0, 10.0)];
    [_shodoggMIDBarButton addTarget:self action:@selector(shodoggMIDButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    _shodoggMIDBarButton.iconImageNameOff = @"icon_cast_bar_off";
    _shodoggMIDBarButton.iconImageNameOn = @"icon_cast_bar_on";
}

- (SHMIDButton *)getShodoggMIDButtonForController:(UIViewController *)controller {
    _viewController = controller;
    if (!_viewController) {
        return nil;
    }
    return _shodoggMIDButton;
}

- (SHMIDButton *)getShodoggMIDBarButtonForController:(UIViewController *)controller {
    _viewController = controller;
    if (!_viewController) {
        return nil;
    }
    return _shodoggMIDBarButton;
}

- (void)shodoggMIDButtonTapped:(id)sender {
    if ([self firstTimeUserExperienceCompleted]) {
        [self presentHomeViewControllerFromController:nil];
    } else {
        [self presentWelcomeScreen];
    }
}

- (void)presentWelcomeScreen {
    UIStoryboard *storyboard = [[SHMIDClient sharedClient] storyboard];
    SHMIDWelcomeViewController *welcomeViewController = [storyboard instantiateViewControllerWithIdentifier:@"SHMIDWelcomeViewController"];
    welcomeViewController.delegate = self;
    welcomeViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.viewController presentViewController:welcomeViewController animated:YES completion:nil];
}

- (void)presentHomeViewControllerFromController:(UIViewController *)controller {
    UIViewController *presentingController = controller ? controller : self.viewController;
    if (!self.homeViewController) {
        self.homeViewController = [[SHMIDHomeViewController alloc] initWithNibName:nil bundle:nil];
    }
    self.homeViewController.shouldShowCastDestinations = NO;
    self.homeViewController.showSelectedContext = YES;
    if ([self screenCastInProgress]) {
        [self.homeViewController switchToToolbarFromController:controller openOnPresentation:YES];
    } else {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.homeViewController];
        navigationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [presentingController presentViewController:navigationController animated:YES completion:nil];
    }
}

- (void)presentRadialMenuViewController {
    self.radialMenuViewController = [[SHMIDRadialMenuViewController alloc] initWithNibName:nil bundle:nil];
    self.radialMenuViewController.openingPosition = self.shodoggButtonCenter;
    self.radialMenuViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.radialMenuViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.radialMenuViewController.delegate = self;
    [self.viewController presentViewController:_radialMenuViewController animated:YES completion:nil];
}

#pragma mark - First Time User Experience

- (BOOL)firstTimeUserExperienceCompleted {
    return [[[NSUserDefaults standardUserDefaults]
             valueForKey:kSHMIDCompletedFisrtTimeUserExperience] boolValue];
}

- (void)completeFirstTimeUserExperience {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(YES) forKey:kSHMIDCompletedFisrtTimeUserExperience];
    [defaults synchronize];
}

- (void)resetFirstTimeUserExperience {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(NO) forKey:kSHMIDCompletedFisrtTimeUserExperience];
    [defaults synchronize];
}

#pragma mark - Device Manager

- (NSArray<SDConnectableDevice *> *)detectedCastTargetDevices {
    return self.deviceManager.detectedDevices;
}

- (SDConnectableDevice *)connectedDevice {
    return self.deviceManager.connectedDevice;
}

- (void)connectDevice:(SDConnectableDevice *)device {
    device.delegate = self;
    [self.deviceManager connectDevice:device];
}

- (void)performDeviceConnectedSequence {
    [self initiateReceivingScreenLaunchSequence];
}

- (void)performDisconnectDeviceSequence {
    [self.connectedDevice closeApplicationWithCompletion:nil];
    [self.deviceManager disconnectDevice];
    [self.homeViewController dismissToolbar];
    self.homeViewController = nil;
    [[SHMIDScreen sharedScreen] disconnect];
    if ([self.delegate respondsToSelector:@selector(didDisconnectCastingDevice)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
           [self.delegate didDisconnectCastingDevice]; 
        });
    }
}

#pragma mark - Receiver App Launch

- (void)initiateReceivingScreenLaunchSequence {
    NSLog(@"%s - %@ ready... Initiating receiving screen launch sequence!", __PRETTY_FUNCTION__, self.connectedDevice.friendlyName);
    SHMIDScreen *screen = [SHMIDScreen sharedScreen];
    if (!screen) {
        screen = [[SHMIDScreen alloc] init];
        screen.delegate = self;
        [SHMIDScreen setSharedScreen:screen];
    }
    if (screen.state == SHMIDScreenStateUnknown) {
        [screen requestPreSyncedScreenUrl];
    }
}

- (void)prepareReceivingAppWithCastingURLString:(NSString *)URLString {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSMutableString *remoteAppURLString = [[NSMutableString alloc] initWithString:URLString];
    SHMIDClient *midClient = [SHMIDClient sharedClient];
    if ([midClient debugEnabled]) {
        NSMutableArray *params = [[NSMutableArray alloc] init];
        if ([midClient hideRSTVSplash]) {
            [params addObject:@"hideTVSplash=true"];
        }
        if ([midClient showRSConsole]) {
            [params addObject:@"showCustomConsole=true"];
            [params addObject:@"debug=true"];
        }
        NSString *compiledParamString =
        [remoteAppURLString stringByAppendingFormat:@"?%@", [params componentsJoinedByString:@"&"]];
        remoteAppURLString = nil;
        remoteAppURLString = [[NSMutableString alloc] initWithString:compiledParamString];
    }
    NSDictionary *launchOptions =
    @{SDParameterAttendeeName : self.connectedDevice.friendlyName,
      SDParameterRemoteAppUrl : remoteAppURLString};
    [self launchReceivingAppWithLaunchOptions:launchOptions];
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
    if (!self.homeViewController) {
        [[SHMIDHomeViewController alloc] initWithNibName:nil bundle:nil];
    }
    self.homeViewController.shouldShowCastDestinations = NO;
    self.homeViewController.showSelectedContext = NO;
    [self.homeViewController switchToToolbarFromController:self.viewController openOnPresentation:NO];
    [[SHMIDScreen sharedScreen] play];
    if ([self.delegate respondsToSelector:@selector(didConnectCastingDevice)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
           [self.delegate didConnectCastingDevice];
        });
    }
}

- (void)launchReceivingAppWithLaunchOptions:(NSDictionary *)options {
    self.connectedDevice.receiver = [self configureReceivingAppWithlaunchOptions:options];
    [self.connectedDevice launchApplicationWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"%s - Error:%@", __PRETTY_FUNCTION__, [error localizedDescription]);
    }];
}

- (SDRemoteReceiver *)configureReceivingAppWithlaunchOptions:(NSDictionary *)options {
    NSString *appId = [self receivingAppIdentifier];
    NSLog(@"%s - Configuring receiving app with options: %@", __PRETTY_FUNCTION__, options);
    switch (self.connectedDevice.deviceType) {
        case SDConnectableDeviceChromecast:
            return [[SDRemoteReceiverChromecast alloc] initWithIdentifier:appId
                                                               parameters:options];
        case SDConnectableDeviceFireTV:
            return [[SDRemoteReceiverFireTV alloc] initWithIdentifier:appId
                                                           parameters:options];
        case SDConnectableDeviceLG:
            return [[SDRemoteReceiverLG alloc] initWithIdentifier:appId
                                                       parameters:options];
        case SDConnectableDeviceSamsung:
            kShodoggSamsungCloudAppID = options[SDParameterRemoteAppUrl];
            return [[SDRemoteReceiverSamsung alloc] initWithCloudIdentifier:kShodoggSamsungCloudAppID
                                                           nativeIdentifier:nil
                                                                 channelURI:@"com.shodogg.connect"
                                                                  paramters:options];
        default:
            NSAssert(NO, @"Requesting remote receiver app for unsupported device type.");
            return nil;
    }
}

- (NSString *)receivingAppIdentifier {
    switch (self.connectedDevice.deviceType) {
        case SDConnectableDeviceChromecast:
            return kShodoggChromecastAppID;
        case SDConnectableDeviceFireTV:
            return kShodoggFireTVAppID;
        case SDConnectableDeviceLG:
            return kShodoggLGTVAppID;
        case SDConnectableDeviceSamsung:
            return kShodoggSamsungCloudAppID;
        default:
            NSAssert(NO, @"Requesting app Id for unsupported device type.");
            return nil;
    }
}

#pragma mark - SHMIDScreenDelegate

- (void)screen:(SHMIDScreen *)screen didChangeState:(SHMIDScreenState)state {
    [[NSNotificationCenter defaultCenter] postNotificationName:kMIDButtonNeedsAppearanceUpdateNotification object:self];
    if (state == SHMIDScreenStateSynced) {
        NSLog(@"%s - Synced", __PRETTY_FUNCTION__);
        NSString *castingURLString = [[SHMIDScreen sharedScreen].castingURL absoluteString];
        if (castingURLString) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kMIDCastingBeganNotification object:self];
            [[SHMIDScreen sharedScreen] setNowPlaying:self.contextItem];
            [self prepareReceivingAppWithCastingURLString:castingURLString];
        } else {
            NSLog(@"%s - Error", __PRETTY_FUNCTION__);
            NSError *error = [NSError errorWithLocalizedDescription:@"There was a problem requesting app launch. Please try again."];
            [error showAsAlertInController:_viewController];
        }
    } else {
        NSLog(@"%s - EndCast", __PRETTY_FUNCTION__);
        [[NSNotificationCenter defaultCenter] postNotificationName:kMIDCastingEndedNotification object:self];
    }
}

- (void)screen:(SHMIDScreen *)screen didChangePlayback:(SHMIDMediaItemPlayback)playback {
    [[NSNotificationCenter defaultCenter] postNotificationName:kMIDScreenPlaybackChangedNotification object:self];
}


#pragma mark - SDDiscoveryManagerDelegate

- (void)discoveryManager:(SDDeviceManager *)manager didFindDevice:(SDConnectableDevice *)device {
    [self syncConnectableDevice:device];
    [self shouldLogDeviceGraphEvent];
    [self postHandleTargetCastDevicesChangeNotification];
}

- (void)discoveryManager:(SDDeviceManager *)manager didLostDevice:(SDConnectableDevice *)device {
    [self syncConnectableDevice:device];
    [self shouldLogDeviceGraphEvent];
    [self postHandleTargetCastDevicesChangeNotification];
}

- (void)discoveryManager:(SDDeviceManager *)manager didError:(NSError *)error {
    [self postHandleTargetCastDevicesChangeNotification];
}

- (void)discoveryManager:(SDDeviceManager *)manager didUpdateDevice:(SDConnectableDevice *)device {
    [self syncConnectableDevice:device];
    [self shouldLogDeviceGraphEvent];
    [self postHandleTargetCastDevicesChangeNotification];
}

- (void)postHandleTargetCastDevicesChangeNotification {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kSHMIDHandleTargetCastDevicesChangeNotification object:nil];
}

#pragma mark - Device Graph

- (void)syncConnectableDevice:(SDConnectableDevice *)device {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[[SHMIDMTLTargetCastDevice alloc] initWithConnectableDevice:device] save];
    });
}

- (void)shouldLogDeviceGraphEvent {
    if (![self detectedCastTargetDevices].count) {
        return;
    }
    __weak typeof(self) wself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        SHMIDMTLDeviceDiscovery *discovery = [[SHMIDMTLDeviceDiscovery alloc] initWithDiscoveredCastDevices:[wself detectedCastTargetDevices]];
        [[SHMIDClient sharedClient] saveDGEventWithMetadata:discovery];
    });
}

#pragma mark - SDConnectableDeviceDelegate

- (void)connectableDeviceReady:(SDConnectableDevice *)device {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (device == self.connectedDevice) {
        [self performDeviceConnectedSequence];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            SHMIDMTLTargetCastDevice *deviceMetadata = [[SHMIDMTLTargetCastDevice alloc] initWithConnectableDevice:device];
            SHMIDMTLDataTrackingEventMetadata *eventMetadata = [[SHMIDMTLDataTrackingEventMetadata alloc] initWithTargetCastDeviceMetadata:deviceMetadata];
            [[SHMIDClient sharedClient] saveDTCastingDeviceConnectedEventWithMetadata:eventMetadata];
        });
    }
}

- (void)connectableDeviceDisconnected:(SDConnectableDevice *)device withError:(NSError *)error {
    NSLog(@"%s - Error: %@", __PRETTY_FUNCTION__, [error localizedDescription]);
}

- (void)connectableDevice:(SDConnectableDevice *)device connectionFailedWithError:(NSError *)error {
    NSLog(@"%s - Error: %@", __PRETTY_FUNCTION__, [error localizedDescription]);
    [error showAsAlertInController:_viewController];
}

#pragma mark - SHMIDCastControlsViewDelegate
- (void)endCasting {
    __weak typeof(self) wself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        SHMIDMTLTargetCastDevice *deviceMetadata = [[SHMIDMTLTargetCastDevice alloc] initWithConnectableDevice:wself.connectedDevice];
        SHMIDMTLDataTrackingEventMetadata *eventMetadata = [[SHMIDMTLDataTrackingEventMetadata alloc] initWithTargetCastDeviceMetadata:deviceMetadata];
        [[SHMIDClient sharedClient] saveDTCastingDeviceDisconnectedEventWithMetadata:eventMetadata];
        dispatch_async(dispatch_get_main_queue(), ^{
            typeof(self) strongself = wself;
            [strongself performDisconnectDeviceSequence];
        });
    });
}

#pragma mark - SHMIDWelcomeViewControllerDelegate

- (void)didFinishFirstTimeUserExperience:(UIViewController *)controller {
    [self completeFirstTimeUserExperience];
    [self performSelector:@selector(presentHomeViewControllerFromController:) withObject:nil afterDelay:1];
}

#pragma mark - SHMIDRadialMenuViewControllerDelegate

- (void)radialMenu:(SHMIDRadialMenu *)menu didSelectSubMenuAtIndex:(NSInteger)index {
    if (index == 1) {//Cast
        [self performSelector:@selector(performCastQuickAction) withObject:nil afterDelay:1];
    } else {//Save
        [self performSelector:@selector(performSaveQuickAction) withObject:nil afterDelay:.4f];
    }
}

- (void)performCastQuickAction {
    
    SHMIDMediaItem *nowPlaying = [SHMIDScreen sharedScreen].nowPlaying;
    if ((nowPlaying == nil || nowPlaying.mcoAssetID != self.contextItem.mcoAssetID) && [self screenCastInProgress]) {
        [[SHMIDScreen sharedScreen] setNowPlaying:self.contextItem];
        [[SHMIDScreen sharedScreen] play];
    } else if (nowPlaying.mcoAssetID == self.contextItem.mcoAssetID) {
        self.homeViewController.shouldShowCastDestinations = YES;
        self.homeViewController.showSelectedContext = NO;
        [self.homeViewController switchToToolbarFromController:self.viewController openOnPresentation:YES];
    } else {
        if (!self.homeViewController) {
            self.homeViewController = [[SHMIDHomeViewController alloc] initWithNibName:nil bundle:nil];
        }
        self.homeViewController.shouldShowCastDestinations = YES;
        self.homeViewController.showSelectedContext = NO;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.homeViewController];
        navigationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.viewController presentViewController:navigationController animated:YES completion:nil];
    }
}

- (void)performSaveQuickAction {
    [self showHudWithFeedback];
}

- (void)showHudWithFeedback {
    UIImage *image = [[SHMIDUtilities imageNamed:@"checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.viewController.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.square = YES;
    hud.label.text = @"Saved";
    [hud hideAnimated:YES afterDelay:1.f];
}

#pragma mark - Convenience

- (BOOL)screenCastInProgress {
    return [SHMIDScreen sharedScreen].state == SHMIDScreenStateSynced;
}

@end
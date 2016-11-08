//
//  SHMIDCastingView.m
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 7/20/16.
//
//

#import "SHMIDCastingView.h"
#import "SHMIDHomeViewController.h"
#import "SHMIDTargetDeviceCollectionCell.h"
#import "SHMIDCastController.h"
#import "SHMIDClient.h"
#import "SHMIDScreen.h"
#import "SHMIDRoundedButton.h"
#import "SHMIDUtilities.h"
#import "SHMIDCastControlsView.h"
#import "SHMIDCastFeedbackView.h"

const   CGFloat   deviceCollectionLRPadding       = 10.0;
const   CGFloat   deviceCollectionCellWidth       = 100.0;
const   CGFloat   deviceCollectionCellHeight      = 120.0;
const   CGFloat   deviceCollectionLineSpacing     = 0.0;
static  NSString *kDeviceCollectionCellIdentifier = @"kSHMIDTargetDeviceCollectionCellIdentifier";

@interface SHMIDCastingView()
    <UICollectionViewDelegate,
     UICollectionViewDataSource,
     UICollectionViewDelegateFlowLayout,
     SHMIDScreenDelegate,
     SHMIDHomeViewControllerDelegate>

@property (nonatomic, strong) UICollectionView *deviceCollectionView;
@property (nonatomic, strong) SHMIDCastController *castController;
@property (nonatomic, strong) SHMIDCastControlsView *castControlsView;
@property (nonatomic, strong) SHMIDCastFeedbackView *feedbackView;
@property (nonatomic, strong) NSArray *devices;
@property (nonatomic) BOOL casting;

@end

@implementation SHMIDCastingView

- (instancetype)initWithFrame:(CGRect)frame mediaItem:(SHMIDMediaItem *)item {
    if (self = [super initWithFrame:frame]) {
        // MARK: Layout CollectionView
        UICollectionViewFlowLayout *collectionViewflowLayout = [[UICollectionViewFlowLayout alloc] init];
        collectionViewflowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _deviceCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:collectionViewflowLayout];
        _deviceCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _deviceCollectionView.backgroundColor = [UIColor clearColor];
        _deviceCollectionView.dataSource = self;
        _deviceCollectionView.delegate = self;
        [_deviceCollectionView registerClass:[SHMIDTargetDeviceCollectionCell class] forCellWithReuseIdentifier:kDeviceCollectionCellIdentifier];
        [self addSubview:_deviceCollectionView];
        NSDictionary *views = @{@"DeviceCollectionView" : _deviceCollectionView};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[DeviceCollectionView]-|" options:0 metrics:0 views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[DeviceCollectionView]|" options:0 metrics:0 views:views]];
        // MARK: Prepare Subviews and Begin discovery
        _devices          = [[SHMIDCastController sharedInstance] detectedCastTargetDevices];
        _casting          = [SHMIDScreen sharedScreen].state == SHMIDScreenStateSynced;
        _feedbackView     = [[SHMIDCastFeedbackView alloc] initWithFrame:self.bounds];
        _castControlsView = [[SHMIDCastControlsView alloc] initWithFrame:self.bounds mediaItem:item];
        [self shouldShowCastControls];
        if (!_casting) {
            [self shouldShowFeedbackView];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Notification

- (void)handleTargetCastDevicesChangeNotification:(NSNotification *)notification {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self refreshDevices];
}

#pragma mark - UICollectionViewDatasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return [self devices].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SHMIDTargetDeviceCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDeviceCollectionCellIdentifier forIndexPath:indexPath];
    SDConnectableDevice *device = [[self devices] objectAtIndex:indexPath.row];
    cell.targetNameLabel.text = device.friendlyName;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SDConnectableDevice *device;
    if ([self.devices count]) {
        device = self.devices[indexPath.row];
        SHMIDClient *client = [SHMIDClient sharedClient];
        if ([client requiresAuthenticationForCasting]) {
            __weak typeof(self) weakself = self;
            [client sendToAuthorizationViewFromController:self completionBlock:^(NSError *error) {
                if (!error) {
                    [weakself attemptConnectingDevice:device];
                }
            }];
        } else {
            [self attemptConnectingDevice:device];
        }
    }
}

- (void)attemptConnectingDevice:(SDConnectableDevice *)device {
    NSLog(@"Attempt connecting device : %@...", device.friendlyName);
    [[SHMIDCastController sharedInstance] connectDevice:device];
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    SHMIDTargetDeviceCollectionCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:0.2 animations:^{
        cell.targetImageView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    SHMIDTargetDeviceCollectionCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:0.2 animations:^{
        cell.targetImageView.backgroundColor = [UIColor clearColor];
    }];
}

#pragma mark - UICollectionViewDelegateFlowLayout

-           (CGFloat)collectionView:(UICollectionView *)collectionView
                             layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return deviceCollectionLineSpacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(deviceCollectionCellWidth, deviceCollectionCellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    CGFloat height  = CGRectGetHeight(collectionView.bounds);
    CGFloat width   = CGRectGetWidth(collectionView.bounds);
    CGFloat insetLR = deviceCollectionLRPadding;
    CGFloat insetTB = (height - deviceCollectionCellHeight)/2.0;
    if ([self.devices count] <= 3) {
        CGFloat preferredCellContentWidth = [self.devices count]*100;
        insetLR = (width-preferredCellContentWidth)/2;
    }
    return UIEdgeInsetsMake(insetTB, insetLR, insetTB, insetLR);;
}


#pragma mark - Cast Target Refreshing

- (void)refreshDevices {
    if (_casting) {
        return;
    }
    self.devices = [[SHMIDCastController sharedInstance] detectedCastTargetDevices];
    [self.deviceCollectionView reloadData];
    [self shouldShowFeedbackView];
}

#pragma mark - SubView management
- (void)shouldShowFeedbackView {
    self.deviceCollectionView.backgroundView = _devices.count == 0 ? _feedbackView : nil;
}

- (void)shouldShowCastControls {
    _casting = [SHMIDScreen sharedScreen].state == SHMIDScreenStateSynced;
    if (_casting) {
        _devices = @[];
        self.deviceCollectionView.backgroundView = _castControlsView;
    } else {
        _devices = [[SHMIDCastController sharedInstance] detectedCastTargetDevices];
        self.deviceCollectionView.backgroundView = nil;
    }
    [self.deviceCollectionView reloadData];
}

#pragma mark - SHMIDHomeViewController

- (void)castControlsViewNeedsLayout {
    [self shouldShowCastControls];
}

@end
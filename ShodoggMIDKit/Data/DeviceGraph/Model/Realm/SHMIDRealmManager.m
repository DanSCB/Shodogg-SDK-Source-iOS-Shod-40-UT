//
//  SHMIDRealmManager.m
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 8/2/16.
//
//

#import "SHMIDRealmManager.h"
#import "SHMIDRLMDeviceGraphEvent.h"
#import "SHMIDRLMDataTrackingEvent.h"
#import "SHMIDClient+DataTracking.h"

NSTimeInterval const eventQueuePostDelay = 60;
NSInteger const eventQueuePostBatchSize  = 50;
NSString* const SHMIDRealmDirectory      = @"com/shodogg/mid/realm";
NSString* const SHMIDDefaultRealmName    = @"db";

@interface SHMIDRealmManager()
@property (nonatomic, strong) RLMNotificationToken *notificationToken;
@property BOOL deviceGraphPostInProgress;
@property BOOL deviceTrackingPostInProgress;
@end

@implementation SHMIDRealmManager

+ (instancetype)defaultManager {
    static SHMIDRealmManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[SHMIDRealmManager alloc] initWithRealmName:SHMIDDefaultRealmName];
    });
    return _instance;
}

#pragma mark - Initializer

- (id)initWithRealmName:(NSString *)realmName {
    self = [super init];
    if (!self) {return nil;}
    // MARK: Configure Realm instance
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *realmDirectoryPath = [[paths firstObject] stringByAppendingPathComponent:SHMIDRealmDirectory];
    NSString *realmFilePath = [realmDirectoryPath stringByAppendingPathComponent:SHMIDDefaultRealmName];
    BOOL fileExistsAtPath = [[NSFileManager defaultManager] fileExistsAtPath:realmFilePath];
    if (!fileExistsAtPath) {
        NSError *error = nil;
        BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:realmFilePath
                                                 withIntermediateDirectories:YES
                                                                  attributes:nil
                                                                       error:&error];
        if (!success) {
            NSLog(@"%s - Failed to create a directory for database. [%@]", __PRETTY_FUNCTION__, error);
            return nil;
        }
    }
    NSLog(@"%s - Realm path: [%@]", __PRETTY_FUNCTION__, realmFilePath);
    RLMRealmConfiguration *configuration = [RLMRealmConfiguration defaultConfiguration];
    configuration.fileURL = [[NSURL URLWithString:realmFilePath] URLByAppendingPathExtension:@"realm"];
    [RLMRealmConfiguration setDefaultConfiguration:configuration];
    // MARK: Setup queue thresholds triggers
    [NSTimer scheduledTimerWithTimeInterval:eventQueuePostDelay target:self selector:@selector(reachedQueuePostDelayThreshold:) userInfo:nil repeats:YES];
    __weak typeof(self) wself = self;
    RLMResults<SHMIDRLMDeviceGraphEvent *> *events = [SHMIDRLMDeviceGraphEvent allObjects];
    self.notificationToken = [events addNotificationBlock:^(RLMResults<SHMIDRLMDeviceGraphEvent *> * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        if (results.count > eventQueuePostBatchSize) {
            [wself reachedQueuePostBatchSizeThreshold];
        }
    }];
    return self;
}

#pragma mark - Realm

- (RLMRealm *)defaultRealm {
    return [RLMRealm defaultRealm];
}

- (void)addObject:(nonnull RLMObject *)object {
    [self.defaultRealm beginWriteTransaction];
    [self.defaultRealm addObject:object];
    [self.defaultRealm commitWriteTransaction];
}

- (void)addOrUpdateObject:(RLMObject *)object {
    [self.defaultRealm beginWriteTransaction];
    [self.defaultRealm addOrUpdateObject:object];
    [self.defaultRealm commitWriteTransaction];
}

- (void)deleteObjects:(id)objects {
    [self.defaultRealm beginWriteTransaction];
    [self.defaultRealm deleteObjects:objects];
    [self.defaultRealm commitWriteTransaction];
}

#pragma mark - Threadhold trigger

- (void)reachedQueuePostDelayThreshold:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self submitDeviceGraphEvents];
}

- (void)reachedQueuePostBatchSizeThreshold {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self submitDeviceGraphEvents];
}

#pragma mark - API

- (void)submitDeviceGraphEvents {
    if (![[SHMIDClient sharedClient] initDone]
        || self.deviceGraphPostInProgress) {
        return;
    }
    RLMResults<SHMIDRLMDeviceGraphEvent *> *events = [SHMIDRLMDeviceGraphEvent allObjects];
    NSMutableArray *output = [[NSMutableArray alloc] initWithCapacity:events.count];
    for (SHMIDRLMDeviceGraphEvent *event in events) {
        if (event.data) {
            NSError *error;
            NSDictionary *eventDictionary = [NSJSONSerialization JSONObjectWithData:event.data options:kNilOptions error:&error];
            if (!error) {
                [output addObject:eventDictionary];
            }
        }
    }
    NSArray *batch = [[NSArray alloc] initWithArray:output];
    if ([batch count] > 0) {
        __weak typeof(self) wself = self;
        self.deviceGraphPostInProgress = YES;
        [[SHMIDClient sharedClient] postDeviceGraphEvents:batch completionBlock:^(id data, NSError *error) {
            wself.deviceGraphPostInProgress = NO;
            if (!error) {
                [wself deleteObjects:events];
            }
        }];
    }
}

- (void)submitDataTrackingEvents {
    if (![[SHMIDClient sharedClient] initDone]
        || self.deviceTrackingPostInProgress) {
        return;
    }
    RLMResults<SHMIDRLMDataTrackingEvent *> *events = [SHMIDRLMDataTrackingEvent allObjects];
    NSMutableArray *output = [[NSMutableArray alloc] initWithCapacity:events.count];
    for (SHMIDRLMDataTrackingEvent *event in events) {
        if (event.data) {
            NSError *error;
            NSDictionary *eventDictionary = [NSJSONSerialization JSONObjectWithData:event.data options:kNilOptions error:&error];
            if (!error) {
                [output addObject:eventDictionary];
            }
        }
    }
    NSArray *batch = [[NSArray alloc] initWithArray:output];
    if ([batch count] > 0) {
        __weak typeof(self) wself = self;
        self.deviceTrackingPostInProgress = YES;
        [[SHMIDClient sharedClient] postDataTrackingEvents:batch completionBlock:^(id data, NSError *error) {
            wself.deviceTrackingPostInProgress = NO;
            if (!error) {
                [wself deleteObjects:events];
            }
        }];
    }
}

@end
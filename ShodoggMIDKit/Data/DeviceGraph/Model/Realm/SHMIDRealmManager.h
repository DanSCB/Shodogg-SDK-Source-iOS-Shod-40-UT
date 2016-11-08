//
//  SHMIDRealmManager.h
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 8/2/16.
//
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface SHMIDRealmManager : NSObject

@property (nonatomic, readonly) RLMRealm *defaultRealm;

+ (instancetype)defaultManager;
- (void)addObject:(nonnull RLMObject *)object;
- (void)addOrUpdateObject:(nonnull RLMObject *)object;
- (void)submitDeviceGraphEvents;
- (void)submitDataTrackingEvents;
@end
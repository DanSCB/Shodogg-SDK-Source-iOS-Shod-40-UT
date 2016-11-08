//
//  SHMIDRLMDataTrackingEvent.m
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 9/1/16.
//
//

#import "SHMIDRLMDataTrackingEvent.h"
#import "SHMIDRealmManager.h"

@implementation SHMIDRLMDataTrackingEvent

#pragma mark - Realm

- (void)save {
    [super save];
    if (!self.data) {
        return;
    }
    NSLog(@"%s - Captured data tracking event.", __PRETTY_FUNCTION__);
    [[SHMIDRealmManager defaultManager] addOrUpdateObject:self];
}

@end
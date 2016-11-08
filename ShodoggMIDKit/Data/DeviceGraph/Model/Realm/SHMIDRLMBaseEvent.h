//
//  SHMIDRLMBaseEvent.h
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 9/1/16.
//
//

#import <Realm/Realm.h>

@interface SHMIDRLMBaseEvent : RLMObject

@property NSString  *uuid;
@property NSData    *data;
@property NSInteger retryCount;
@property long long timestamp;

- (void)save;
- (instancetype)initWithMTLModelObject:(id<MTLJSONSerializing>)mtlObject;
@end
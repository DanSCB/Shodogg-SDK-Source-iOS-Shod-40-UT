//
//  SHMIDRLMBaseEvent.m
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 9/1/16.
//
//

#import "SHMIDRLMBaseEvent.h"
#import "SHMIDUtilities.h"

@implementation SHMIDRLMBaseEvent

#pragma mark - Realm

+ (NSString *)primaryKey {
    return @"uuid";
}

- (void)save {
    NSLog(@"%s - ", __PRETTY_FUNCTION__);
}

#pragma mark - Initializer

- (instancetype)init {
    if ([super init]) {
        _uuid       = [[NSUUID UUID] UUIDString];
        _timestamp  = [SHMIDUtilities currentTimeInMilliseconds];
        _retryCount = 0;
    }
    return self;
}

- (instancetype)initWithMTLModelObject:(id<MTLJSONSerializing>)mtlObject {
    if ([self init]) {
        NSError *error = nil;
        NSDictionary *jsonRepresentation = [MTLJSONAdapter JSONDictionaryFromModel:mtlObject error:&error];
        NSLog(@"%s - [timestamp: %@] Capturing Event(%@) with payload: {\n%@\n}", __PRETTY_FUNCTION__, dateString(_timestamp), [[mtlObject class] className], jsonRepresentation);
        if (!error) {
            NSError *error = nil;
            NSData *jsonToData
            = [NSJSONSerialization dataWithJSONObject:jsonRepresentation options:NSJSONWritingPrettyPrinted error:&error];
            if (!error) {
                _data = [[NSData alloc] initWithData:jsonToData];
            }
        }
    }
    return self;
}
@end
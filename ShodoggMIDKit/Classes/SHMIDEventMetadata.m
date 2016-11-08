//
//  SHMIDEventMetadata.m
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 11/11/15.
//  Copyright © 2015 Shodogg. All rights reserved.
//

#import "SHMIDEventMetadata.h"
#import "SHMIDClient.h"
#import "SHUtilities.h"
#import "SHMIDUtilities.h"

#pragma mark - Enum util
NSArray *SHEventTypeAllNames() {
    static NSArray *eventTypes = nil;
    if (eventTypes == nil) {
        eventTypes = kSHEventTypeAllNames;
    }
    return eventTypes;
}

NSString *SHEventTypeAsString(SHEventType type) {
    if (type < [SHEventTypeAllNames() count]) {
        return [SHEventTypeAllNames() objectAtIndex:type];
    }
    return @"invalid";
}

NSString *const SHMIDEventMetadataErrorDomain = @"com.shodogg.SHMIDEventMetadataErrorDomain";

@interface SHMIDEventMetadata()
@property (nonatomic, strong) NSString *mid;
@property (nonatomic, strong) NSString *mcoId;
@property (nonatomic, strong) NSString *mcoAppId;
@property (nonatomic, strong) NSString *mcoAppPublicKey;
@end

@implementation SHMIDEventMetadata

- (instancetype)init {
    if (self = [super init]) {
        SHMIDClient *client  = [SHMIDClient sharedClient];
        self.mid             = [client getMID];
        self.mcoId           = [client getMCOID];
        self.mcoAppId        = [client getMCOAppID];
        self.mcoAppPublicKey = [client getMCOAppPublicKey];
    }
    return self;
}

- (NSDictionary *)toDictionary {
    
    NSMutableDictionary *metadata = [[NSMutableDictionary alloc] init];
    metadata[@"mid"]             = NilToEmptyString(self.mid);
    metadata[@"mcoId"]           = NilToEmptyString(self.mcoId);
    metadata[@"mcoAppId"]        = NilToEmptyString(self.mcoAppId);
    metadata[@"mcoAppPublicKey"] = NilToEmptyString(self.mcoAppPublicKey);
    metadata[@"eventValue"]      = NilToEmptyString(self.eventValue);
    metadata[@"eventValueOld"]   = NilToEmptyString(self.eventValueOld);
    metadata[@"label"]           = NilToEmptyString(self.label);
    metadata[@"assetId"]         = NilToEmptyString(self.assetId);
    metadata[@"mcoAssetId"]      = NilToEmptyString(self.mcoAssetId);
    metadata[@"sessionToken"]    = NilToEmptyString(self.sessionToken);
    metadata[@"eventType"]       = SHEventTypeAsString(self.eventType);
    metadata[@"timestampUTC"]    = @(self.timestampUTC);
    
    return metadata;
}

- (BOOL)isValid {
    if (!self.timestampUTC) {
        self.timestampUTC = [SHMIDUtilities currentTimeInMilliseconds];
    }
    BOOL result = !self.mid || !self.mcoId || !self.mcoAppId || !self.mcoAppPublicKey;
    return !result;
}

- (NSString *)failureMessage {
    
    NSString *message;
    
    if (!_mid)
        message = @"The MID is a required field on the SHMIDEventMetadata object.";
    if (!_mcoId)
        message = @"The MCO ID is a required field on the SHMIDEventMetadata object.";
    if (!_mcoAppId)
        message = @"The MCO App ID is a required field on the SHMIDEventMetadata object.";
    if (!_mcoAppPublicKey)
        message = @"The public key is a required field on the SHMIDEventMetadata object.";
    
    return message;
}

- (NSError *)error {
    if (![self isValid]) {
        return [NSError errorWithDomain:SHMIDEventMetadataErrorDomain
                   localizedDescription:[self failureMessage]
                          failureReason:nil
                     recoverySuggestion:nil];
    }
    return nil;
}
@end
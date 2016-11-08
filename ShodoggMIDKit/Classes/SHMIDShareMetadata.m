//
//  SHMIDShareMetadata.m
//  Pods
//
//  Created by Aamir Khan on 12/17/15.
//
//

#import "SHMIDShareMetadata.h"
#import "NSError+SHAPIError.h"
#import "SHUtilities.h"

NSString *const SHMIDShareMetadataErrorDomain = @"com.shodogg.SHMIDShareMetadataErrorDomain";

@implementation SHMIDShareMetadata

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        //TODO:
    }
    return self;
}

- (NSDictionary *)toRequestParamDictionary {
    NSMutableDictionary *metadata = [[NSMutableDictionary alloc] init];
    metadata[@"mid"]                = NilToEmptyString(self.mid);
    metadata[@"mco_id"]             = NilToEmptyString(self.mcoId);
    metadata[@"mco_app_id"]         = NilToEmptyString(self.mcoAppId);
    metadata[@"mco_app_pub_key"]    = NilToEmptyString(self.mcoAppPublicKey);
    metadata[@"asset_id"]           = NilToEmptyString(self.assetId);
    metadata[@"mco_asset_id"]       = NilToEmptyString(self.mcoAssetId);
    metadata[@"timestamp_utc"]      = @(self.timestampUTC);
    metadata[@"url"]                = NilToEmptyString(self.contentURL);
    metadata[@"text"]               = NilToEmptyString(self.text);
    return metadata;
}

- (BOOL)isValid {
    BOOL result = ![super isValid] || !self.contentURL || (!self.mcoAssetId && !self.assetId);
    return !result;
}

- (NSString *)failureMessage {
    NSString *message = [super failureMessage];
    if (!self.contentURL) {
        message = @"The Content URL is required.";
    }
    if (!self.mcoAssetId && !self.assetId) {
        message = @"Either a mcoAssetId or midAssetId is required.";
    }
    return message;
}

- (NSError *)error {
    NSError *error = nil;
    if (![self isValid]) {
        error = [NSError errorWithDomain:SHMIDShareMetadataErrorDomain
                    localizedDescription:[self failureMessage]
                           failureReason:nil recoverySuggestion:nil];
    }
    return error;
}
@end
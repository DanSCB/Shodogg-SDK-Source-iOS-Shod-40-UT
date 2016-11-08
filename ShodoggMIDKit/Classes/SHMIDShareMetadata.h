//
//  SHMIDShareMetadata.h
//  Pods
//
//  Created by Aamir Khan on 12/17/15.
//
//

#import "SHMIDEventMetadata.h"

@interface SHMIDShareMetadata : SHMIDEventMetadata
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *contentURL;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
- (NSDictionary *)toRequestParamDictionary;
- (NSError *)error;
@end

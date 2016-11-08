//
//  SHMIDDataRecorder.h
//  Pods
//
//  Created by Aamir Khan on 12/9/15.
//
//

#import <Foundation/Foundation.h>
#import "SHMIDClient+DataTracking.h"
#import "SHMIDEventMetadata.h"

@interface SHMIDDataRecorder : NSObject

+ (instancetype)defaultRecorder;
- (NSManagedObjectContext *)currentContext;
- (void)save;
- (void)cleanup;
- (void)saveEvent:(SHMIDEventMetadata *)event completionBlock:(SHMIDDataCompletionBlock)block;
- (void)submitAllEvents;
- (void)removeAllEvents;
@end

//
//  SHManagedObject.m
//  Pods
//
//  Created by Aamir Khan on 12/7/15.
//
//

#import "SHMIDManagedObject.h"
#import "SHMIDDataRecorder.h"

@implementation SHMIDManagedObject

- (void)save {
    NSManagedObjectContext *context = [[SHMIDDataRecorder defaultRecorder] currentContext];
    [context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        if (error) {
            NSLog(@"%s - Saving persistent store context, Error: %@", __PRETTY_FUNCTION__, [error localizedDescription]);
            NSArray *detailedErrors = error.userInfo[NSDetailedErrorsKey];
            if (detailedErrors != nil && [detailedErrors count] > 0) {
                for(NSError *detailedError in detailedErrors) {
                    NSLog(@"%s - Found detailed error: %@", __PRETTY_FUNCTION__, [detailedError userInfo]);
                }
            } else {
                NSLog(@"%s - %@", __PRETTY_FUNCTION__, [error userInfo]);
            }
            NSLog(@"%s - Rolling back now to clean the context...", __PRETTY_FUNCTION__);
            [context rollback];
        }
    }];
}
@end
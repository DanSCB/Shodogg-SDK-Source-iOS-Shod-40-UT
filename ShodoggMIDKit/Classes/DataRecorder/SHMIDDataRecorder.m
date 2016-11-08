//
//  SHMIDDataRecorder.m
//  Pods
//
//  Created by Aamir Khan on 12/9/15.
//
//

#import "SHMIDDataRecorder.h"
#import "RecorderHeaders.h"

NSString* const SHMIDRecorderDatabasePathPrefix = @"com/shodogg/SHMIDDataRecorder";
NSString* const SHMIDRecorderDBName = @"Recorder.sqlite";
NSString* const SHMIDRecorderModelName = @"Recorder.momd";

@interface SHMIDDataRecorder()
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSString *databasePath;
@end

@implementation SHMIDDataRecorder

+ (instancetype)defaultRecorder {
    static SHMIDDataRecorder *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[SHMIDDataRecorder alloc] initWithDatabaseName:SHMIDRecorderDBName];
    });
    return _instance;
}

- (id)initWithDatabaseName:(NSString *)dbName {
    if (self = [super init]) {
        NSString *databaseDirectoryPath = [NSTemporaryDirectory() stringByAppendingPathComponent:SHMIDRecorderDatabasePathPrefix];
        _databasePath = [databaseDirectoryPath stringByAppendingPathComponent:dbName];
        BOOL fileExistsAtPath = [[NSFileManager defaultManager] fileExistsAtPath:databaseDirectoryPath];
        if (!fileExistsAtPath) {
            NSError *error = nil;
            BOOL success = [[NSFileManager defaultManager]
                                    createDirectoryAtPath:databaseDirectoryPath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
            if (!success) {
                NSLog(@"%s - Failed to create a directory for database. [%@]",
                            __PRETTY_FUNCTION__, error);
            }
        }
        NSLog(@"%s - Database path: [%@]", __PRETTY_FUNCTION__, _databasePath);
        NSURL *databaseURL = [NSURL fileURLWithPath:_databasePath];
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        [MagicalRecord enableShorthandMethods];
        [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelVerbose];
        NSManagedObjectModel *momd = [NSManagedObjectModel MR_newModelNamed:SHMIDRecorderModelName inBundle:bundle];
        [NSManagedObjectModel MR_setDefaultManagedObjectModel:momd];
        [MagicalRecord setupCoreDataStackWithStoreAtURL:databaseURL];
        self.context = [NSManagedObjectContext MR_defaultContext];
    }
    return self;
}

#pragma mark - Magical Record

- (NSManagedObjectContext *)currentContext {
    return _context;
}

- (void)save {
    [self.context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        NSString *message = error ? [NSString stringWithFormat:@"error: %@", [error localizedDescription]] : @"success";
        NSLog(@"%s - Saved to persistent store with %@", __PRETTY_FUNCTION__, message);
    }];
}

- (void)cleanup {
    [MagicalRecord cleanUp];
}

#pragma mark - Event recording

- (void)saveEvent:(SHMIDEventMetadata *)event completionBlock:(SHMIDDataCompletionBlock)block {
    Record *record;
    event.sessionToken = [[SHMIDClient sharedClient] getMIDSessionToken];
    @try {
        record = [Record MR_createEntityInContext:self.context];
    }
    @catch (NSException *exception) {
        NSLog(@"Catch an exception: %@", exception);
    }
    @finally {
        if (record) {
            record.key = [[NSUUID UUID] UUIDString];
            record.timestamp = [NSDate date];
            record.retryCount = @0;
            NSError *error;
            NSData *toData =
            [NSJSONSerialization dataWithJSONObject:[event toDictionary]
                                            options:NSJSONWritingPrettyPrinted
                                              error:&error];
            if (!error) {
                record.data = toData;
            }
            [record save];
            block([event toDictionary], nil);
        }
    }
}

- (void)submitAllEvents {
    NSArray *records = [Record MR_findAllInContext:self.context];
    NSMutableArray *recordSet = [[NSMutableArray alloc] init];
    [records enumerateObjectsUsingBlock:^(Record*  _Nonnull record, NSUInteger idx, BOOL * _Nonnull stop) {
        if (record.data) {
            NSError *error;
            NSDictionary *recordDictionary = [NSJSONSerialization JSONObjectWithData:record.data options:kNilOptions error:&error];
            if (!error) {
                [recordSet addObject:recordDictionary];
            }
        }
    }];
    //TODO: Setup a mechanism to
    //to address records with errors/warnings
    NSArray *batchEventData = [[NSArray alloc] initWithArray:recordSet];
    if ([batchEventData count]>0) {
        [[SHMIDClient sharedClient] postDataTrackingEvents:batchEventData completionBlock:^(id data, NSError *error) {
            if (!error) {
                [[SHMIDDataRecorder defaultRecorder] removeAllEvents];
            }
        }];
    }
}

- (void)removeAllEvents {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key != nil"];
    [Record MR_deleteAllMatchingPredicate:predicate inContext:self.context];
}

#pragma mark - Util

- (NSUInteger)diskBytesUsed {
    NSError *error = nil;
    NSDictionary *attributes =
        [[NSFileManager defaultManager]
            attributesOfItemAtPath:self.databasePath
                             error:&error];
    if (attributes) {
        return (NSUInteger)[attributes fileSize];
    } else {
        NSLog(@"%s - Error [%@]", __PRETTY_FUNCTION__, error);
        return 0;
    }
}
@end
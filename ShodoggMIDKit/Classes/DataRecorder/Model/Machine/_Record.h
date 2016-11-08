// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Record.h instead.

#import <CoreData/CoreData.h>
#import "SHMIDManagedObject.h"

extern const struct RecordAttributes {
	__unsafe_unretained NSString *data;
	__unsafe_unretained NSString *key;
	__unsafe_unretained NSString *retryCount;
	__unsafe_unretained NSString *timestamp;
} RecordAttributes;

extern const struct RecordRelationships {
} RecordRelationships;

extern const struct RecordFetchedProperties {
} RecordFetchedProperties;


@class NSObject;




@interface RecordID : NSManagedObjectID {}
@end

@interface _Record : SHMIDManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (RecordID*)objectID;





@property (nonatomic, strong) id data;



//- (BOOL)validateData:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* key;



//- (BOOL)validateKey:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* retryCount;



@property int16_t retryCountValue;
- (int16_t)retryCountValue;
- (void)setRetryCountValue:(int16_t)value_;

//- (BOOL)validateRetryCount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* timestamp;



//- (BOOL)validateTimestamp:(id*)value_ error:(NSError**)error_;






@end

@interface _Record (CoreDataGeneratedAccessors)

@end

@interface _Record (CoreDataGeneratedPrimitiveAccessors)


- (id)primitiveData;
- (void)setPrimitiveData:(id)value;




- (NSString*)primitiveKey;
- (void)setPrimitiveKey:(NSString*)value;




- (NSNumber*)primitiveRetryCount;
- (void)setPrimitiveRetryCount:(NSNumber*)value;

- (int16_t)primitiveRetryCountValue;
- (void)setPrimitiveRetryCountValue:(int16_t)value_;




- (NSDate*)primitiveTimestamp;
- (void)setPrimitiveTimestamp:(NSDate*)value;




@end

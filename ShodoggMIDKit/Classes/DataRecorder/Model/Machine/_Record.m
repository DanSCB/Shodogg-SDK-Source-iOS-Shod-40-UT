// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Record.m instead.

#import "_Record.h"

const struct RecordAttributes RecordAttributes = {
	.data = @"data",
	.key = @"key",
	.retryCount = @"retryCount",
	.timestamp = @"timestamp",
};

const struct RecordRelationships RecordRelationships = {
};

const struct RecordFetchedProperties RecordFetchedProperties = {
};

@implementation RecordID
@end

@implementation _Record

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Record";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Record" inManagedObjectContext:moc_];
}

- (RecordID*)objectID {
	return (RecordID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"retryCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"retryCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic data;






@dynamic key;






@dynamic retryCount;



- (int16_t)retryCountValue {
	NSNumber *result = [self retryCount];
	return [result shortValue];
}

- (void)setRetryCountValue:(int16_t)value_ {
	[self setRetryCount:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveRetryCountValue {
	NSNumber *result = [self primitiveRetryCount];
	return [result shortValue];
}

- (void)setPrimitiveRetryCountValue:(int16_t)value_ {
	[self setPrimitiveRetryCount:[NSNumber numberWithShort:value_]];
}





@dynamic timestamp;











@end

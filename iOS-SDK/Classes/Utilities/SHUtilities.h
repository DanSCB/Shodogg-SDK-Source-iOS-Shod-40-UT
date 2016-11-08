//
//  SHUtilities.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 9/16/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHAssetRepoMetadata.h"
#import "SHAssetType.h"

//Check for nil strings
id NilToEmptyString(id something);
id NullToEmptyString(id JSON);
NSString* IntToString(int someValue);
NSArray* JSONToArrayOrEmpty(id JSON);
NSDictionary* JSONToDictionaryOrEmpty(id JSON);

//date and time utils
NSString *timestamp(NSDate *date);
NSString *dateString(NSTimeInterval interval);
NSDate *dateFromTimeInterval(NSTimeInterval interval);
NSString *formatDBDateString(NSString *dateString);

@interface SHUtilities : NSObject

+ (void)setupDependencyChain:(NSArray*)operationsArray;
+ (NSSortDescriptor *)sortDescriptor:(NSString *)key;
+ (NSString *)appNameAndVersionStamp;
+ (SHFileType)fileTypeForAssetWithType:(SHAssetType)assetType originalFileName:(NSString *)filename additionalInfo:(id)info;
+ (NSString *)iconNameForFileWithType:(SHFileType)fileType;
+ (NSString *)iconForFilename:(NSString *)filename;
+ (BOOL)supportsFileWithName:(NSString *)filename;
@end

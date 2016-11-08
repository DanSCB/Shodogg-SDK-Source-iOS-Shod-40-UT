//
//  SHMIDUtilities.h
//  Pods
//
//  Created by Aamir Khan on 12/17/15.
//
//

#import <Foundation/Foundation.h>

@interface SHMIDUtilities : NSObject
+ (unsigned long long)currentTimeInMilliseconds;
+ (id)nilToEmptyString:(id)string;
+ (UIImage *)imageNamed:(NSString *)name;

+ (NSDictionary <NSString *, id> *)bundleInfoDictionary;
+ (NSString *)bundleVersionString;
@end

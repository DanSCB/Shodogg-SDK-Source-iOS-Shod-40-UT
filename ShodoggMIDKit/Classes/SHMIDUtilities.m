//
//  SHMIDUtilities.m
//  Pods
//
//  Created by Aamir Khan on 12/17/15.
//
//

#import "SHMIDUtilities.h"

@implementation SHMIDUtilities

+ (unsigned long long)currentTimeInMilliseconds {
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    return [@(interval*1000) unsignedLongLongValue];
}

+ (id)nilToEmptyString:(id)string {
    if (string == nil || string == [NSNull null]) {
        return @"";
    }
    return string;
}

+ (UIImage *)imageNamed:(NSString *)name {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *imageBundlePath = [bundle pathForResource:@"ShodoggMIDKit" ofType:@"bundle" inDirectory:nil];
    NSBundle *imageBundle = [NSBundle bundleWithPath:imageBundlePath];
    return [UIImage imageNamed:name inBundle:imageBundle compatibleWithTraitCollection:nil];
}

+ (NSDictionary <NSString *, id> *)bundleInfoDictionary {
    return [[NSBundle bundleForClass:[self class]] infoDictionary];
}

+ (NSString *)bundleVersionString {
    return [NSString stringWithFormat:@"%@.%@",
            [[[self class] bundleInfoDictionary] objectForKey:@"CFBundleShortVersionString"],
            [[[self class] bundleInfoDictionary] objectForKey:@"CFBundleVersion"]];
}
@end
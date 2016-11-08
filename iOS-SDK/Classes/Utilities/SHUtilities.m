//
//  SHUtilities.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 9/16/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import "SHUtilities.h"
#import "SHAssetRepoMetadata.h"

id NilToEmptyString(id something) {
    if (something == nil || something == [NSNull null]) {
        return @"";
    }
    return something;
}

id NullToEmptyString(id JSON) {
    if (JSON == [NSNull null] || JSON == nil) {
        return @"";
    }
    return JSON;
}

NSString* IntToString(int someValue){
    return (NSString *)[NSString stringWithFormat:@"%d", someValue];
}

NSArray* JSONToArrayOrEmpty(id JSON) {
    if (JSON != nil && [JSON isKindOfClass:[NSArray class]]) {
        return (NSArray*)JSON;
    }
    return @[];
}

NSDictionary* JSONToDictionaryOrEmpty(id JSON) {
    if (JSON !=nil && [JSON isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)JSON;
    }
    return @{};
}

#define kLocale @"en-US"
NSString *timestamp(NSDate *date){
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:kLocale]];
        [dateFormatter setDateFormat:@"MM-dd-yyyy hh:mm a"];
    }
    
    NSString* result = [dateFormatter stringFromDate:date];
    if (!result) {
        return @"";
    }
    return result;
}

NSString *dateString(NSTimeInterval interval) {
    if (!interval) {
        return @"";
    }
    //Convert miliseconds to seconds
    interval = interval * .001;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:kLocale]];
        [dateFormatter setDateFormat:@"MM-dd-yyyy hh:mm a"];
    }
    return [dateFormatter stringFromDate:date];
}

NSDate *dateFromTimeInterval(NSTimeInterval interval) {
    if (!interval) {
        return nil;
    }
    //Convert miliseconds to seconds
    interval = interval * .001;
    return [NSDate dateWithTimeIntervalSince1970:interval];
}

NSString *formatDBDateString(NSString *dateString) {
    if (!dateString) {
        return @"";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EE, dd MMM yyyy HH:mm:ss z"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    [dateFormatter setDateFormat:@"MM-dd-yyyy hh:mm a"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:kLocale];
    [dateFormatter setLocale:locale];
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    return formattedDateString;
}

@implementation SHUtilities
+(void)setupDependencyChain:(NSArray *)operationsArray {
    NSOperation *lastOp = nil;
    for (NSOperation *op in operationsArray) {
        if (lastOp != nil && ![op.dependencies containsObject:lastOp]) {
            [op addDependency:lastOp];
        }
        lastOp = op;
    }
}

+ (NSSortDescriptor *)sortDescriptor:(NSString *)key {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key
                                                                   ascending:YES
                                                                    selector:@selector(caseInsensitiveCompare:)];
    return sortDescriptor;
}

+ (NSString *)appNameAndVersionStamp {
    NSString *appVersionString = nil;
    NSDictionary *infoPlistDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoPlistDictionary objectForKey:@"CFBundleName"];
    NSString *version = [infoPlistDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [infoPlistDictionary objectForKey:@"CFBundleVersion"];
    appVersionString = [NSString stringWithFormat:@"%@-iOS-v%@b%@", appName, version, build];
    return appVersionString;
}

#pragma mark - Type Util

+ (SHFileType)fileTypeForAssetWithType:(SHAssetType)assetType originalFileName:(NSString *)filename additionalInfo:(id)info {

    if (assetType == SHAssetTypeVideo && info != nil) {
        return [SHUtilities fileTypeForVideoWithFileName:filename additionalInfo:(SHAssetRepoMetadata *)info];
    }
    else if (assetType == SHAssetTypeLink) {
        return SHFileTypeWebLink;
    }
    
    return [SHUtilities fileTypeForAssetWithFileName:filename];
}

+ (SHFileType)fileTypeForVideoWithFileName:(NSString *)fileName additionalInfo:(SHAssetRepoMetadata *)info {
    
    if (info.repoProvider == SHRepoProviderYoutube) {
        return SHFileTypeYouTube;
    }
    else if (info.repoProvider == SHRepoProviderCommsFactory) {
        return SHFileTypeCF;
    }
    
    return [SHUtilities fileTypeForAssetWithFileName:fileName];
}

+ (SHFileType)fileTypeForAssetWithFileName:(NSString *)filename {
    
    if (filename.length <= 0) {
        return SHFileTypeUnknown;
    }
    
    return SHFileTypeFromString([filename pathExtension].uppercaseString);
}

+ (NSString *)iconNameForFileWithType:(SHFileType)fileType {
    
    if (fileType == SHFileTypePDF) {
        return @"pdf";
    }
    else if (fileType == SHFileTypePPT || fileType == SHFileTypePPTX) {
        return @"powerpoint";
    }
    else if (fileType == SHFileTypeDOC || fileType == SHFileTypeDOCX) {
        return @"document";
    }
    else if (fileType == SHFileTypeXLS || fileType == SHFileTypeXLSX) {
        return @"excel";
    }
    else if (fileType == SHFileTypeYouTube) {
        return @"youtube";
    }
    else if (fileType == SHFileTypeMP4) {
        return @"mp4";
    }
    else if (fileType == SHFileTypeCF) {
        return @"video";
    }
    else if (fileType == SHFileTypeWebLink) {
        return @"link_icon";
    }
    else if ([SHUtilities isImageType:fileType]) {
        return @"image";
    }
    
    //Placeholder thumbnail image for file types not supported in app
    return @"file";
}

+ (BOOL)isImageType:(SHFileType)fileType {
    
    if (fileType == SHFileTypeJPEG
        || fileType == SHFileTypeJPG
        || fileType == SHFileTypePNG
        || fileType == SHFileTypeGIF
        || fileType == SHFileTypeSVG) {
        return YES;
    }
    return NO;
}

+ (NSString *)iconForFilename:(NSString *)filename {
    
    SHFileType type = [[self class] fileTypeForAssetWithFileName:filename];
    return [[self class] iconNameForFileWithType:type];
}

+ (BOOL)supportsFileWithName:(NSString *)filename {
    
    SHFileType type = [[self class] fileTypeForAssetWithFileName:filename];
    if (type == SHFileTypeUnknown) {
        return NO;
    }
    return YES;
}
@end
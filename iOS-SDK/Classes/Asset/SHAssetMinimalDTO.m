//
//  SHAssetMinimalDTO.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 9/24/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import "SHAssetMinimalDTO.h"
#import "SHAssetRepoMetadata.h"
#import "SHUtilities.h"

@implementation SHAssetMinimalDTO

+ (SHAssetMinimalDTO *)fromJSON:(id)JSON {

    SHAssetMinimalDTO *asset = [[SHAssetMinimalDTO alloc] init];
    [asset setID:JSON[@"id"]];
    [asset setUserID:JSON[@"userId"]];
    [asset setActive:[JSON[@"active"] boolValue]];
    [asset setUbeDescription:NilToEmptyString(JSON[@"description"])];
    [asset setDisplayName:NilToEmptyString(JSON[@"displayName"])];
    [asset setOriginalFilename:NilToEmptyString(JSON[@"originalFilename"])];
    [asset setOriginalURL:NilToEmptyString(JSON[@"originalUrl"])];
    [asset setThumbnailURL:NilToEmptyString(JSON[@"thumbnailUrl"])];
    [asset setVersion:NilToEmptyString(JSON[@"version"])];
    [asset setReadOnly:[JSON[@"readOnly"] boolValue]];
    [asset setPageCount:[JSON[@"pageCount"] intValue]];
    [asset setPageCount:[JSON[@"noteCount"] intValue]];
    [asset setAssetType:SHAssetTypeFromString([JSON[@"assetType"] uppercaseString])];
    [asset setCreatedAt:dateFromTimeInterval([JSON[@"createdAt"] doubleValue])];
    [asset setUpdatedAt:dateFromTimeInterval([JSON[@"updatedAt"] doubleValue])];
    NSDictionary *repoMetadata = (NSDictionary *)JSONToDictionaryOrEmpty([JSON objectForKey:@"repoMetadata"]);
    [asset setRepoMetadata:[SHAssetRepoMetadata create:repoMetadata]];
    [asset setFileType:[SHUtilities fileTypeForAssetWithType:asset.assetType originalFileName:asset.originalFilename additionalInfo:asset.repoMetadata]];
    [asset setIconImageName:[SHUtilities iconNameForFileWithType:asset.fileType]];
    NSDictionary *attrs = (NSDictionary *)JSONToDictionaryOrEmpty([JSON objectForKey:@"attributes"]);
    [asset setAttributes:[[NSMutableDictionary alloc] initWithDictionary:attrs]];
    NSArray *thumbnails = [asset.attributes[@"thumbnails"] allObjects];
    [thumbnails enumerateObjectsUsingBlock:^(NSDictionary *thumbnail, NSUInteger idx, BOOL *stop) {
        NSString *type = NilToEmptyString(thumbnail[@"type"]);
        NSString *key  = [NSString stringWithFormat:@"%@ThumbnailURL", type];
        NSString *url  = NilToEmptyString([SHAssetMinimalDTO encodeLastComponent:thumbnail[@"url"]]);
        if (url.length>0 && key.length>0) {
            asset.attributes[key] = url;
        }
    }];
    [asset.attributes removeObjectForKey:@"thumbnails"];
    
    return asset;
}

+ (SHAssetMinimalDTO *)fromDictionary:(id)dictionary {
    SHAssetMinimalDTO *ref = [SHAssetMinimalDTO new];
    [ref setDisplayName:NilToEmptyString(dictionary[@"displayName"])];
    [ref setAssetType:SHAssetTypeFromString(dictionary[@"assetType"])];
    [ref setFileType:[SHUtilities fileTypeForAssetWithType:ref.assetType originalFileName:ref.originalFilename additionalInfo:ref.repoMetadata]];
    [ref setIconImageName:[SHUtilities iconNameForFileWithType:ref.fileType]];
    [ref setPath:NilToEmptyString(dictionary[@"path"])];
    [ref setOriginalURL:NilToEmptyString(dictionary[@"link"])];
    [ref setStatus:SHAssetStatusFromString(NilToEmptyString(dictionary[@"status"]))];
    return ref;
}

+(NSString *)encodeLastComponent:(NSString *)urlString {
    NSString *stringMinusLastComponent = [urlString stringByDeletingLastPathComponent];
    NSString *lastComponentString = [urlString lastPathComponent];
    NSString *encodeLastComponent = [lastComponentString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *result = [stringMinusLastComponent stringByAppendingPathComponent:encodeLastComponent];
    return result;
}
@end
//
//  SHRemoteRefToAsset.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 9/25/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import "SHRemoteRefToAsset.h"
#import "SHAssetRepoMetadata.h"
#import "SHUtilities.h"
#import "SHPage.h"
#import "SHNote.h"

@implementation SHRemoteRefToAsset

+ (SHRemoteRefToAsset *)createFromJSON:(id)JSON {

    SHRemoteRefToAsset *ref = [[SHRemoteRefToAsset alloc] init];
    [ref setID:[JSON objectForKey:@"id"]];
    [ref setUserID:[JSON objectForKey:@"userId"]];
    [ref setActive:[[JSON objectForKey:@"active"] boolValue]];
    [ref setUbeDescription:NilToEmptyString([JSON objectForKey:@"description"])];
    [ref setDisplayName:NilToEmptyString([JSON objectForKey:@"displayName"])];
    [ref setOriginalFilename:NilToEmptyString([JSON objectForKey:@"originalFilename"])];
    [ref setOriginalURL:NilToEmptyString([JSON objectForKey:@"originalUrl"])];
    [ref setReadOnly:[[JSON objectForKey:@"readOnly"] boolValue]];
    [ref setThumbnailURL:NilToEmptyString([JSON objectForKey:@"thumbnailUrl"])];
    [ref setVersion:NilToEmptyString([JSON objectForKey:@"version"])];
    [ref setAssetType:SHAssetTypeFromString([[JSON objectForKey:@"assetType"] uppercaseString])];
    [ref setCreatedAt:dateFromTimeInterval([JSON[@"createdAt"] doubleValue])];
    [ref setUpdatedAt:dateFromTimeInterval([JSON[@"updatedAt"] doubleValue])];
    
    NSDictionary *repoMetadata = (NSDictionary *)JSONToDictionaryOrEmpty([JSON objectForKey:@"repoMetadata"]);
    [ref setRepoMetadata:[SHAssetRepoMetadata create:repoMetadata]];
    [ref setFileType:[SHUtilities fileTypeForAssetWithType:ref.assetType originalFileName:ref.originalFilename additionalInfo:ref.repoMetadata]];
    [ref setIconImageName:[SHUtilities iconNameForFileWithType:ref.fileType]];
    
    NSArray *eventIds = (NSArray *)JSONToArrayOrEmpty([JSON objectForKey:@"eventIds"]);
    NSMutableArray *eventIdArray = [[NSMutableArray alloc] initWithArray:eventIds];
    [ref setEventIds:eventIdArray];
    
    NSArray *groupIds = (NSArray *)JSONToArrayOrEmpty([JSON objectForKey:@"groupIds"]);
    NSMutableArray *groupIdArray = NilToEmptyString([[NSMutableArray alloc] initWithArray:groupIds]);
    [ref setGroupIds:groupIdArray];
    
    NSArray *folderIds = (NSArray *)JSONToArrayOrEmpty([JSON objectForKey:@"folderIds"]);
    NSMutableArray *folderIdArray = NilToEmptyString([[NSMutableArray alloc] initWithArray:folderIds]);
    [ref setFolderIds:folderIdArray];
    
    NSArray *pageNodes = (NSArray *)JSONToArrayOrEmpty([JSON objectForKey:@"pages"]);
    [ref setPages:[SHRemoteRefToAsset convertToPageRef:pageNodes]];
    [ref setSmallThumbnailURLArray:[SHRemoteRefToAsset smallThumbnailUrls:ref.pages]];
    [ref setThumbnailURLArray:[SHRemoteRefToAsset thumbnailUrls:ref.pages]];
    [ref setHqThumbnailURLArray:[SHRemoteRefToAsset hqThumbnailUrls:ref.pages]];

    //asset notes
    NSArray *noteNodes = (NSArray *)JSONToArrayOrEmpty([JSON objectForKey:@"notes"]);
    [ref setUserNotes:[SHRemoteRefToAsset convertToNoteRefs:noteNodes forType:SHNoteTypePersonal]];
    [ref setEmbeddedNotes:[SHRemoteRefToAsset convertToNoteRefs:noteNodes forType:SHNoteTypeEmbedded]];
    
    //Augmented Pages
    NSDictionary *augmentedPagesDictionary = JSONToDictionaryOrEmpty(JSON[@"augmentedPages"]);
    NSArray *parsedPageObjects = [NSArray arrayWithArray:ref.pages];
    NSMutableDictionary *parsedAugmentedPages = [[NSMutableDictionary alloc] initWithCapacity:augmentedPagesDictionary.count];
    for (SHPage *page in parsedPageObjects) {
        NSDictionary *augmentedAssetDictionary = JSONToDictionaryOrEmpty(augmentedPagesDictionary[[@(page.pageNumber) stringValue]]);
        if (augmentedAssetDictionary.allKeys.count > 0) {
            NSArray *augmentedAssetArray = [augmentedAssetDictionary[@"assets"] allObjects];
            if (augmentedAssetArray.count > 0) {
                NSMutableArray *parsedAugmentedAssetRefs = [[NSMutableArray alloc] initWithCapacity:augmentedAssetArray.count];
                [augmentedAssetArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    SHAssetMinimalDTO *augmentedAsset = [SHAssetMinimalDTO fromJSON:obj];
                    if (augmentedAsset) {
                        [parsedAugmentedAssetRefs addObject:augmentedAsset];
                    }
                }];
                [parsedAugmentedPages setObject:parsedAugmentedAssetRefs forKey:[@(page.pageNumber) stringValue]];
            }
        }
    }
    [ref setAugmentedPages:parsedAugmentedPages];

    NSDictionary *attrs = (NSDictionary *)JSONToDictionaryOrEmpty([JSON objectForKey:@"attrs"]);
    [ref setAttributes:[[NSMutableDictionary alloc] initWithDictionary:attrs]];
    NSArray *thumbnails = [ref.attributes[@"thumbnails"] allObjects];
    [thumbnails enumerateObjectsUsingBlock:^(NSDictionary *thumbnail, NSUInteger idx, BOOL *stop) {
        NSString *type = NilToEmptyString(thumbnail[@"type"]);
        NSString *key  = [NSString stringWithFormat:@"%@ThumbnailURL", type];
        NSString *url  = NilToEmptyString([SHRemoteRefToAsset encodeLastComponent:thumbnail[@"url"]]);
        if (url.length>0 && key.length>0) {
            [ref.attributes setObject:url forKey:key];
        }
    }];
    [ref.attributes removeObjectForKey:@"thumbnails"];
    [ref setLiked:NO];
    [ref setUnliked:NO];
    [ref setRating:0];
    
    return ref;
}

+ (SHRemoteRefToAsset *)fromDictionary:(id)dictionary {
    SHRemoteRefToAsset *ref = [SHRemoteRefToAsset new];
    [ref setDisplayName:NilToEmptyString(dictionary[@"displayName"])];
    [ref setAssetType:SHAssetTypeFromString(dictionary[@"assetType"])];
    [ref setFileType:[SHUtilities fileTypeForAssetWithType:ref.assetType originalFileName:ref.originalFilename additionalInfo:ref.repoMetadata]];
    [ref setIconImageName:[SHUtilities iconNameForFileWithType:ref.fileType]];
    [ref setPath:NilToEmptyString(dictionary[@"path"])];
    [ref setOriginalURL:NilToEmptyString(dictionary[@"link"])];
    [ref setStatus:SHAssetStatusFromString(NilToEmptyString(dictionary[@"status"]))];
    
    return ref;
}

+(NSMutableArray *)convertToPageRef:(NSArray *)pageNodes{
    NSMutableArray *pages = [[NSMutableArray alloc] initWithCapacity:pageNodes.count];
    for (id object in pageNodes) {
        SHPage *page = [SHPage fromJSON:object];
        if (page) {
            [pages addObject:page];
        }
    }
    return pages;
}

+(NSMutableArray *)convertToNoteRefs:(NSArray *)noteNodes forType:(SHNoteType)type {
    NSMutableArray *notes = [[NSMutableArray alloc] initWithCapacity:[noteNodes count]];
    for (id object in noteNodes) {
        SHNote *note = [SHNote fromJSON:object];
        if (type == note.type) {
            [notes addObject:note];
        }
    }
    return notes;
}

+(NSMutableArray *)smallThumbnailUrls:(NSArray *)pagesArray {
    NSMutableArray *pageThumbnailsArray = [[NSMutableArray alloc] initWithCapacity:pagesArray.count];
    for (SHPage *page in pagesArray) {
        if (page.smallThumbnailURL.length > 0) {
            [pageThumbnailsArray addObject:page.smallThumbnailURL];
        }
    }
    return pageThumbnailsArray;
}

+(NSMutableArray *)thumbnailUrls:(NSArray *)pagesArray {
    NSMutableArray *pageThumbnailsArray = [[NSMutableArray alloc] initWithCapacity:pagesArray.count];
    for (SHPage *page in pagesArray) {
        if (page.thumbnailURL.length > 0) {
            [pageThumbnailsArray addObject:page.thumbnailURL];
        }
    }
    return pageThumbnailsArray;
}

+(NSMutableArray *)hqThumbnailUrls:(NSArray *)pagesArray {
    NSMutableArray *pageThumbnailsArray = [[NSMutableArray alloc] initWithCapacity:pagesArray.count];
    for (SHPage *page in pagesArray) {
        if (page.hqThumbnailUrl.length > 0) {
            [pageThumbnailsArray addObject:page.hqThumbnailUrl];
        }
    }
    return pageThumbnailsArray;
}

+(NSString *)encodeLastComponent:(NSString *)urlString {
    NSString *stringMinusLastComponent = [urlString stringByDeletingLastPathComponent];
    NSString *lastComponentString = [urlString lastPathComponent];
    NSString *encodeLastComponent = [lastComponentString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *result = [stringMinusLastComponent stringByAppendingPathComponent:encodeLastComponent];
    return result;
}
@end
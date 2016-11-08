//
//  SHYoutubeDTO.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 1/2/14.
//  Copyright (c) 2014 Shodogg. All rights reserved.
//

#import "SHYoutubeDTO.h"
#import "SHUtilities.h"

@implementation SHYoutubeDTO
+ (SHYoutubeDTO *)fromJSON:(id)JSON {
    SHYoutubeDTO *youtubeEntry = [[SHYoutubeDTO alloc] init];
    [youtubeEntry setKey:NilToEmptyString([JSON objectForKey:@"key"])];
    [youtubeEntry setAssetIdArray:JSONToArrayOrEmpty([JSON objectForKey:@"assetIds"])];
    [youtubeEntry setThumbnailUrl:NilToEmptyString([JSON objectForKey:@"thumbnail"])];
    [youtubeEntry setTitle:NilToEmptyString([JSON objectForKey:@"title"])];
    [youtubeEntry setAuthor:NilToEmptyString([JSON objectForKey:@"authorName"])];
    [youtubeEntry setAuthorUri:NilToEmptyString([JSON objectForKey:@"authorUri"])];
    [youtubeEntry setUbeDescription:NilToEmptyString([JSON objectForKey:@"description"])];
    [youtubeEntry setUrl:NilToEmptyString([JSON objectForKey:@"link"])];
    [youtubeEntry setDuration:NilToEmptyString([JSON objectForKey:@"durationInSeconds"])];
    [youtubeEntry setViewCount:NilToEmptyString([JSON objectForKey:@"viewCount"])];
    
    if (![youtubeEntry.assetIdArray count]) {
        [youtubeEntry setStatus:SHAssetStatusUnknown];
    } else {
        [youtubeEntry setStatus:SHAssetStatusConversionCompleted];
    }
    
    return youtubeEntry;
}
@end
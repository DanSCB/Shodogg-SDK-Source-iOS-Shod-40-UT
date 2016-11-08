//
//  SHPage.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 9/27/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import "SHPage.h"
#import "SHNote.h"
#import "SHUtilities.h"

@implementation SHPage
+ (SHPage *)fromJSON:(id)JSON
{
    SHPage *page            = [[SHPage alloc] init];
    page.ID                 = (NSString *)NilToEmptyString(JSON[@"id"]);
    page.pageNumber         = (NSInteger)[JSON[@"pageNumber"] integerValue];
    page.marker             = (NSString *)NilToEmptyString(JSON[@"marker"]);
    page.smallThumbnailURL  = (NSString *)NilToEmptyString(JSON[@"smallThumbnailUrl"]);
    page.thumbnailURL       = (NSString *)NilToEmptyString(JSON[@"thumbnailUrl"]);
    page.hqThumbnailUrl     = (NSString *)NilToEmptyString(JSON[@"hqThumbnailUrl"]);
    page.createdAt          = dateFromTimeInterval([JSON[@"createdAt"] doubleValue]);
    page.updatedAt          = dateFromTimeInterval([JSON[@"updatedAt"] doubleValue]);
    page.attributes         = (NSMutableDictionary *)JSONToDictionaryOrEmpty(JSON[@"attributes"]);
    NSArray *noteNodes      = (NSArray *)JSONToArrayOrEmpty(JSON[@"notes"]);
    page.userNotes          = [self convertToNoteRefs:noteNodes forType:SHNoteTypePersonal];
    page.embeddedNotes      = [self convertToNoteRefs:noteNodes forType:SHNoteTypeEmbedded];
    page.rating             = 0;
    page.liked              = NO;
    page.unliked            = NO;
    return page;
}

+ (NSMutableArray *)convertToNoteRefs:(NSArray *)noteNodes forType:(SHNoteType)type
{
    NSMutableArray *notes = [[NSMutableArray alloc] initWithCapacity:[noteNodes count]];
    for (id object in noteNodes) {
        SHNote *note = [SHNote fromJSON:object];
        if (type == note.type) {
            [notes addObject:note];
        }
    }
    return notes;
}
@end
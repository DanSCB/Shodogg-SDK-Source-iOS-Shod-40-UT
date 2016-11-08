//
//  SHNote.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 9/27/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import "SHNote.h"
#import "SHUtilities.h"

NSString* SHNoteTypeAsString(SHNoteType noteType) {
    if (noteType < [SHNoteTypeAllNames() count]) {
        return [SHNoteTypeAllNames() objectAtIndex:noteType];
    }
    [NSException raise:NSGenericException format:@"SHNote: Unexpected noteType(%d).", noteType];
    return @"";
}

SHNoteType SHNoteTypeFromString(NSString* name) {
    return (SHNoteType)[SHNoteTypeAllNames() indexOfObject:name];
}

NSArray *SHNoteTypeAllNames(){
    static NSArray *noteTypeNames = nil;
    if (noteTypeNames == nil) {
        noteTypeNames = kNoteTypeNames;
    }
    return noteTypeNames;
}

@implementation SHNote

+ (SHNote *)fromJSON:(id)JSON
{
    SHNote *note = [[SHNote alloc] init];
    note.type = SHNoteTypeFromString([JSON objectForKey:@"type"]);
    note.userId = (NSString *)NilToEmptyString([JSON objectForKey:@"userId"]);
    note.note = (NSString *)NilToEmptyString([JSON objectForKey:@"note"]);
    note.ID = (NSString *)NilToEmptyString([JSON objectForKey:@"id"]);
    note.createdAt = dateFromTimeInterval([JSON[@"createdAt"] doubleValue]);
    note.updatedAt = dateFromTimeInterval([JSON[@"updatedAt"] doubleValue]);
    note.attributes = (NSMutableDictionary *)NilToEmptyString([JSON objectForKey:@"attributes"]);
    return note;
}

@end
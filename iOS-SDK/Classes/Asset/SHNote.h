//
//  SHNote.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 9/27/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNoteTypeNames @[@"EMBEDDED", @"PERSONAL", @"EVENT"]
typedef enum{
    SHNoteTypeEmbedded,
    SHNoteTypePersonal,
    SHNoteTypeEvent,
}SHNoteType;

NSArray *SHNoteTypeAllNames();
SHNoteType SHNoteTypeFromString(NSString* name);
NSString* SHNoteTypeAsString(SHNoteType noteType);

@interface SHNote : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, assign) SHNoteType type;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, strong) NSMutableDictionary *attributes;

+ (SHNote *)fromJSON:(id)JSON;

@end
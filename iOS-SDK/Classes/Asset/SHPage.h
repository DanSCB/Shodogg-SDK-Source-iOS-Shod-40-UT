//
//  SHPage.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 9/27/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHPage : NSObject
@property (nonatomic, copy)     NSString            *ID;
@property (nonatomic, copy)     NSString            *marker;
@property (nonatomic, copy)     NSString            *smallThumbnailURL;
@property (nonatomic, copy)     NSString            *thumbnailURL;
@property (nonatomic, copy)     NSString            *hqThumbnailUrl;
@property (nonatomic, strong)     NSDate              *createdAt;
@property (nonatomic, strong)     NSDate              *updatedAt;
@property (nonatomic, strong)   NSMutableArray      *userNotes;
@property (nonatomic, strong)   NSMutableArray      *embeddedNotes;
@property (nonatomic, strong)   NSMutableDictionary *attributes;
@property (nonatomic, assign)   NSInteger           pageNumber;
//Local
@property (nonatomic, assign)   NSInteger           rating;
@property (nonatomic, assign)   BOOL                liked;
@property (nonatomic, assign)   BOOL                unliked;
+ (SHPage *)fromJSON:(id)JSON;
@end
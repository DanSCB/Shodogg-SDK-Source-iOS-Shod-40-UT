//
//  SHDropboxEntryDTO.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 12/10/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import "SHDropboxEntryDTO.h"
#import "SHUtilities.h"

@implementation SHDropboxEntryDTO

+ (SHDropboxEntryDTO *)fromJSON:(id)JSON {
    
    SHDropboxEntryDTO *dropboxAsset = [[SHDropboxEntryDTO alloc] init];
    SHAssetType assetType = SHAssetTypeFromString([JSON objectForKey:@"assetType"]);
    [dropboxAsset setIsDIR:[[JSON objectForKey:@"dir"] boolValue]];
    [dropboxAsset setPath:NilToEmptyString([JSON objectForKey:@"path"])];
    [dropboxAsset setRoot:NilToEmptyString([JSON objectForKey:@"root"])];
    [dropboxAsset setSize:NilToEmptyString([JSON objectForKey:@"size"])];
    [dropboxAsset setMimeType:NilToEmptyString([JSON objectForKey:@"mimeType"])];
    [dropboxAsset setRev:NilToEmptyString([JSON objectForKey:@"rev"])];
    [dropboxAsset setThumbExists:[[JSON objectForKey:@"thumbExists"] boolValue]];
    [dropboxAsset setIsDeleted:[[JSON objectForKey:@"deleted"] boolValue]];
    [dropboxAsset setDisplayName:NilToEmptyString([JSON objectForKey:@"filename"])];
    [dropboxAsset setAssetId:NilToEmptyString([JSON objectForKey:@"assetId"])];
    [dropboxAsset setUpdatedAt:formatDBDateString(NilToEmptyString([JSON objectForKey:@"modified"]))];
    [dropboxAsset setStatus:SHAssetStatusFromString(NilToEmptyString([JSON objectForKey:@"status"]))];
    [dropboxAsset setStatusMessage:NilToEmptyString([JSON objectForKey:@"statusMessage"])];
    [dropboxAsset setFileType:[SHUtilities fileTypeForAssetWithType:assetType originalFileName:dropboxAsset.displayName additionalInfo:nil]];
    [dropboxAsset setIconImageName:[SHUtilities iconNameForFileWithType:[dropboxAsset fileType]]];
    
    return dropboxAsset;
}
@end
//
//  SHUbeAPIClient+TestData.m
//  Pods
//
//  Created by Aamir Khan on 11/4/15.
//
//

#import "SHUbeAPIClient+TestData.h"
#import "SHFolder.h"
#import "SHAssetMinimalDTO.h"

@implementation SHUbeAPIClient (TestData)

- (void)getVideosWithCompletionBlock:(void(^)(NSArray *videos, NSError *error))block {
    
    NSMutableArray *videos = [[NSMutableArray alloc] init];
    
    [SHFolder getRootFolderContentsExcludingRepositories:YES completionBlock:^(NSArray *folders, NSError *error) {
        if (error)
            block(nil, error);
        
        [folders enumerateObjectsUsingBlock:^(SHFolder *folder, NSUInteger idx, BOOL * _Nonnull stop) {
            [SHFolder getContentsOfFolderWithId:folder.Id completionBlock:^(NSDictionary *contents, NSError *error) {
                NSArray *assets = [contents[@"assets"] allObjects];
                [assets enumerateObjectsUsingBlock:^(SHAssetMinimalDTO *asset, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (asset.fileType == SHFileTypeMP4) {
                        [videos addObject:asset];
                    }
                }];
                block(videos, error);
            }];
        }];
    }];
}
@end

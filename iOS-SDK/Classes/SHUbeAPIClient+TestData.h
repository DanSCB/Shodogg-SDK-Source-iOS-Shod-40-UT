//
//  SHUbeAPIClient+TestData.h
//  Pods
//
//  Created by Aamir Khan on 11/4/15.
//
//

#import "SHUbeAPIClient.h"

@interface SHUbeAPIClient (TestData)

- (void)getVideosWithCompletionBlock:(void(^)(NSArray *videos, NSError *error))block;
@end

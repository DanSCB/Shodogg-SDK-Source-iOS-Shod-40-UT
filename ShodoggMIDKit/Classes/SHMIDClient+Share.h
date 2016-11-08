//
//  SHMIDClient+Share.h
//  Pods
//
//  Created by Aamir Khan on 12/10/15.
//
//

#import "SHMIDClient.h"
#import "SHMIDShareMetadata.h"
#import "SHMIDMediaItem.h"

typedef NS_ENUM(NSInteger, SHMIDSocialShareOption) {
    SHMIDSocialShareOptionUnknown,
    SHMIDSocialShareOptionFacebook,
    SHMIDSocialShareOptionTwitter,
    SHMIDSocialShareOptionGooglePlus,
    SHMIDSocialShareOptionEmail,
    SHMIDSocialShareOptionMessage
};

@interface SHMIDClient (Share)

/* Provide one action interface to provide
 * all supported share options
 */
- (void)shareContentWithURL:(NSString *)url
                 MCOAssetId:(NSString *)mcoAssetId
                 MIDAssetId:(NSString *)midAssetId
             FromController:(UIViewController *)controller;

/* action-target sharing
 */
- (void)shareMediaItem:(SHMIDMediaItem *)item
     socialShareOption:(SHMIDSocialShareOption)option
    fromViewController:(UIViewController *)controller;

@end
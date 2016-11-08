//
//  SHRepoUtilities.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 9/25/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>

//RepoProvider
#define kSHRepoProviderAllNames @[@"INVALID", @"S3", @"DROPBOX", @"GMAIL", @"LINKEDIN", @"GOOGLE_PLUS", @"FACEBOOK", @"TWITTER", @"FLICKR", @"YOUTUBE", @"NETFLIX", @"VIMEO", @"HULU", @"AMAZON_PRIME", @"HBO_GO", @"ESPN", @"CRACKLE", @"VUDU", @"FTP_SERVER", @"ITUNES", @"UPLOADED_BY_USER", @"BOX", @"COMMS_FACTORY", @"INSTAGRAM", @"EXTERNAL_LINK"]

typedef NS_ENUM(NSInteger, SHRepoProvider){
    SHRepoProviderInvalid       = 0,
    SHRepoProviderS3            = 1,
    SHRepoProviderDropbox       = 2,
    SHRepoProviderGmail         = 3,
    SHRepoProviderLinkedIn      = 4,
    SHRepoProviderGooglePlus    = 5,
    SHRepoProviderFacebook      = 6,
    SHRepoProviderTwitter       = 7,
    SHRepoProviderFlickr        = 8,
    SHRepoProviderYoutube       = 9,
    SHRepoProviderNetflix       = 10,
    SHRepoProviderVimeo         = 11,
    SHRepoProviderHulu          = 12,
    SHRepoProviderAmazonPrime   = 13,
    SHRepoProviderHBOGO         = 14,
    SHRepoProviderESPN          = 15,
    SHRepoProviderCrackle       = 16,
    SHRepoProviderVudu          = 17,
    SHRepoProviderFTPServer     = 18,
    SHRepoProviderItunes        = 19,
    SHRepoProviderUploadedByUser= 20,
    SHRepoProviderBox           = 21,
    SHRepoProviderCommsFactory  = 22,
    SHRepoProviderInstagram     = 23,
    SHRepoProviderExternalLink  = 24
};

NSArray *SHRepoProviderAllNames();
SHRepoProvider SHRepoProviderFromString(NSString *provider);
NSString *SHRepoProviderAsString(SHRepoProvider repoProvider);
BOOL SHRepoProviderIsStringValid(NSString *provider);

//RepoType
#define kSHRepoTypeAllNames @[@"INVALID", @"DEVICE_LOCAL_CONTENT", @"PRIVATE_SERVER", @"CLOUD_STORAGE", @"CLOUD_STREAMING_CONTENT", @"SOCIAL_NETWORK", @"FTP", @"SFTP", @"USER_UPLOADED_CONTENT"]

typedef NS_ENUM(NSInteger, SHRepoType){
    SHRepoTypeInvalid               = 0,
    SHRepoTypeDeviceLocalContent    = 1,
    SHRepoTypePrivateServer         = 2,
    SHRepoTypeCloudStorage          = 3,
    SHRepoTypeCLoudStreamingContent = 4,
    SHRepoTypeSocialNetwork         = 5,
    SHRepoTypeFTP                   = 6,
    SHRepoTypeSFTP                  = 7,
    SHRepoTypeUserUploadedContent   = 8
};

NSArray *SHRepoTypeAllNames();
SHRepoType SHRepoTypeFromString(NSString *type);
NSString *SHRepoTypeAsString(SHRepoType repoType);
BOOL SHRepoTypeIsStringValid(NSString *type);
//
//  SHMIDClient+Share.m
//  Pods
//
//  Created by Aamir Khan on 12/10/15.
//
//

#import "SHMIDClient+Share.h"
#import "SHMIDAuth.h"
@import Social;
@import MessageUI;

@implementation SHMIDClient (Share)

#pragma mark - Share Target-Action

- (void)shareMediaItem:(SHMIDMediaItem *)item
     socialShareOption:(SHMIDSocialShareOption)option
    fromViewController:(UIViewController *)controller {

    if ([self canResumeSession]) {
        switch (option) {
            case SHMIDSocialShareOptionUnknown:
            case SHMIDSocialShareOptionEmail:
                [self shareItemViaEmail:item fromViewController:controller];
                break;
            case SHMIDSocialShareOptionFacebook:
            case SHMIDSocialShareOptionGooglePlus:
            case SHMIDSocialShareOptionTwitter:
                [self shareMediaItemOnFacebook:item fromViewController:controller];
                break;
            case SHMIDSocialShareOptionMessage:
                [self shareItemViaMessage:item fromViewController:controller];
                break;
            default:
                break;
        }
    } else {
        __weak typeof(self) weakself = self;
        [self sendToAuthorizationViewFromController:controller completionBlock:^(NSError *error) {
            if (!error) {
                [controller dismissViewControllerAnimated:YES completion:nil];
                [weakself shareMediaItem:item socialShareOption:option fromViewController:controller];
            }
        }];
    }
}

- (void)shareMediaItemOnFacebook:(SHMIDMediaItem *)item
         fromViewController:(UIViewController *)controller {
    __weak typeof(self) weakself = self;
    [self generateFacebookShareableURLForContentURL:item.url
             MIDAssetId:item.itemID
             MCOAssetId:item.mcoAssetID
          ShareMetadata:nil
        CompletionBlock:^(NSURL *url, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!error) {
                    [weakself facebookPostWithURL:url fromController:controller];
                } else {
                    [error showAsAlertInController:controller];
                }
            });
        }];
}

- (void)shareItemViaMessage:(SHMIDMediaItem *)item
         fromViewController:(UIViewController *)controller {
    __weak typeof(self) weakself = self;
    [self generateSMSShareableURLForContentURL:item.url
               MIDAssetId:item.itemID
               MCOAssetId:item.mcoAssetID
            ShareMetadata:nil
          CompletionBlock:^(NSURL *url, NSError *error) {
              dispatch_async(dispatch_get_main_queue(), ^{
                  if (!error) {
                      [weakself smsWithURL:url fromController:controller];
                  } else {
                      [error showAsAlertInController:controller];
                  }
              });
          }];
}

- (void)shareItemViaEmail:(SHMIDMediaItem *)item
       fromViewController:(UIViewController *)controller {
    __weak typeof(self) weakself = self;
    [self generateEmailShareableURLForContentURL:item.url
                MIDAssetId:item.itemID
                MCOAssetId:item.mcoAssetID
             ShareMetadata:nil
           CompletionBlock:^(NSURL *url, NSError *error) {
               dispatch_async(dispatch_get_main_queue(), ^{
                   if (!error) {
                       [weakself emailWithURL:url fromController:controller];
                   } else {
                       [error showAsAlertInController:controller];
                   }
               });
           }];
}

#pragma mark - Share Custom

- (void)shareContentWithURL:(NSString *)url
                 MCOAssetId:(NSString *)mcoAssetId
                 MIDAssetId:(NSString *)midAssetId
             FromController:(UIViewController *)controller {
    NSURL *contentURL = [NSURL URLWithString:url];
    if (![self canResumeSession]) {
        [self sendToAuthorizationViewFromController:controller completionBlock:^(NSError *error) {
            if (error) return;
        }];
    }
    [self showShareOptionsWithContentURL:contentURL
                              MCOAssetId:mcoAssetId
                              MIDAssetId:midAssetId
                          FromController:controller];
}

#pragma mark - Share UIActionSheet

- (void)showShareOptionsWithContentURL:(NSURL *)contentURL
                            MCOAssetId:(NSString *)mcoAssetId
                            MIDAssetId:(NSString *)midAssetId
                        FromController:(UIViewController *)controller {
    __weak typeof(self) weakself = self;
    UIAlertController *shareController =
        [UIAlertController alertControllerWithTitle:nil
                                            message:nil
                                     preferredStyle:UIAlertControllerStyleActionSheet];
    [shareController addAction:
        [UIAlertAction actionWithTitle:@"Text"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * _Nonnull action) {
                                   [weakself generateSMSShareableURLForContentURL:contentURL
                                       MIDAssetId:midAssetId
                                       MCOAssetId:mcoAssetId
                                    ShareMetadata:nil
                                  CompletionBlock:^(NSURL *url, NSError *error) {
                                      if (!url) {
                                          url = contentURL;
                                      }
                                      [weakself smsWithURL:url fromController:controller];
                                   }];
                               }]];
    [shareController addAction:
        [UIAlertAction actionWithTitle:@"Email"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * _Nonnull action) {
                                   [weakself generateEmailShareableURLForContentURL:contentURL
                                     MIDAssetId:midAssetId
                                     MCOAssetId:mcoAssetId
                                  ShareMetadata:nil
                                CompletionBlock:^(NSURL *url, NSError *error) {
                                    if (!url) {
                                        url = contentURL;
                                    }
                                    [weakself emailWithURL:url fromController:controller];
                                   }];
                               }]];
    [shareController addAction:
        [UIAlertAction actionWithTitle:@"Facebook"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * _Nonnull action) {
                                   [weakself generateFacebookShareableURLForContentURL:contentURL
                                        MIDAssetId:midAssetId
                                        MCOAssetId:mcoAssetId
                                     ShareMetadata:nil
                                   CompletionBlock:^(NSURL *url, NSError *error) {
                                       if (!url) {
                                           url = contentURL;
                                       }
                                       [weakself facebookPostWithURL:url fromController:controller];
                                   }];
                               }]];
    [shareController addAction:
        [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [controller presentViewController:shareController animated:YES completion:nil];
}

#pragma mark - Share iOS Activity Sheet

- (void)showShareActivityControllerForURL:(NSURL *)url fromController:(UIViewController *)controller {
    NSString *urlToString = url.absoluteString;
    UIActivityViewController *shareController =
    [[UIActivityViewController alloc] initWithActivityItems:@[url, urlToString]
                                      applicationActivities:nil];
    [controller presentViewController:shareController animated:YES completion:nil];
}

#pragma mark - Share iOS Social Framework

- (void)smsWithURL:(NSURL *)url fromController:(UIViewController *)controller {
    MFMessageComposeViewController *messageComposeViewController = [[MFMessageComposeViewController alloc] init];
    messageComposeViewController.messageComposeDelegate = self;
    messageComposeViewController.body = url.absoluteString;
    [controller presentViewController:messageComposeViewController animated:YES completion:nil];
}

- (void)emailWithURL:(NSURL *)url fromController:(UIViewController *)controller {
    BOOL mailConfigured = [MFMailComposeViewController canSendMail];
    if (mailConfigured) {
        MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
        mailComposeViewController.mailComposeDelegate = self;
        [mailComposeViewController setMessageBody:url.absoluteString isHTML:NO];
        [controller presentViewController:mailComposeViewController animated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Email not setup"
                                                                       message:@"Please add an email account in the Mail App to enable sharing."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [controller presentViewController:alert animated:YES completion:nil];
    }
}

- (void)facebookPostWithURL:(NSURL *)url fromController:(UIViewController *)controller {
    SLComposeViewController *fbComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [fbComposeViewController addURL:url];
    [controller presentViewController:fbComposeViewController animated:YES completion:nil];
}

#pragma mark - MID API

- (void)generateGoogleShareableURLForContentURL:(NSURL *)url
                                     MIDAssetId:(NSString *)midAssetId
                                     MCOAssetId:(NSString *)mcoAssetId
                                  ShareMetadata:(NSDictionary *)metadata
                                CompletionBlock:(void(^)(NSURL *url, NSError *error))block {
    [self generateShareableURLForContentURL:url
                                 MIDAssetId:midAssetId
                                 MCOAssetId:mcoAssetId
                                   Metadata:metadata
                             SocialProvider:@"google"
                            CompletionBlock:block];
}

- (void)generateFacebookShareableURLForContentURL:(NSURL *)url
                                       MIDAssetId:(NSString *)midAssetId
                                       MCOAssetId:(NSString *)mcoAssetId
                                    ShareMetadata:(NSDictionary *)metadata
                                  CompletionBlock:(void(^)(NSURL *url, NSError *error))block {
    [self generateShareableURLForContentURL:url
                                 MIDAssetId:midAssetId
                                 MCOAssetId:mcoAssetId
                                   Metadata:metadata
                             SocialProvider:@"facebook"
                            CompletionBlock:block];
}

- (void)generateEmailShareableURLForContentURL:(NSURL *)url
                                    MIDAssetId:(NSString *)midAssetId
                                    MCOAssetId:(NSString *)mcoAssetId
                                 ShareMetadata:(NSDictionary *)metadata
                               CompletionBlock:(void(^)(NSURL *url, NSError *error))block {
    [self generateShareableURLForContentURL:url
                                 MIDAssetId:midAssetId
                                 MCOAssetId:mcoAssetId
                                   Metadata:metadata
                             SocialProvider:@"email"
                            CompletionBlock:block];
}

- (void)generateSMSShareableURLForContentURL:(NSURL *)url
                                  MIDAssetId:(NSString *)midAssetId
                                  MCOAssetId:(NSString *)mcoAssetId
                               ShareMetadata:(NSDictionary *)metadata
                             CompletionBlock:(void(^)(NSURL *url, NSError *error))block {
    [self generateShareableURLForContentURL:url
                                 MIDAssetId:midAssetId
                                 MCOAssetId:mcoAssetId
                                   Metadata:metadata
                             SocialProvider:@"text"
                            CompletionBlock:block];
}

- (void)generateShareableURLForContentURL:(NSURL *)url
                               MIDAssetId:(NSString *)midAssetId
                               MCOAssetId:(NSString *)mcoAssetId
                                 Metadata:(NSDictionary *)metadata
                           SocialProvider:(NSString *)provider
                          CompletionBlock:(void(^)(NSURL *url, NSError *error))block {
    SHMIDShareMetadata *shareMetadata = [[SHMIDShareMetadata alloc] initWithAttributes:metadata];
    shareMetadata.mcoAssetId = mcoAssetId;
    shareMetadata.assetId    = midAssetId;
    shareMetadata.contentURL = url.absoluteString;
    if ([shareMetadata error]) {
        block(nil, [shareMetadata error]);
        return;
    }
    NSString *endpointPathString = [NSString stringWithFormat:@"/api/share/%@", provider];
    [[SHUbeAPIClient sharedClient]
     POST:endpointPathString
     parameters:[shareMetadata toRequestParamDictionary]
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
         NSLog(@"\n[POST - %@] {\n\tResponse: %@\n\tFailure: %@\n}", endpointPathString,
               [responseObject description], [task.error getFailureMessageInResponseData]);
         NSURL *url = [NSURL URLWithString:NilToEmptyString(responseObject[@"link"])];
         block(url, task.error);
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"\n[POST - %@] {Failure: %@\n}", endpointPathString,
               [error getFailureMessageInResponseData]);
         block(nil, error);
     }];
}
@end
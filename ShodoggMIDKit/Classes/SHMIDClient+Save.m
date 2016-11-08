//
//  SHMIDClient+Save.m
//  Pods
//
//  Created by Aamir Khan on 12/10/15.
//
//

#import "SHMIDClient+Save.h"

NSString* const kSaveAppScheme = @"mid-save://";

#warning TODO: finish all todos
@implementation SHMIDClient (Save)

- (void)saveContentWithURL:(NSString *)url fromController:(UIViewController *)controller {
    //TODO: Save favorite
    [self configureAndShowDoneAlertInController:controller];
}

- (void)configureAndShowDoneAlertInController:(UIViewController *)controller {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Saved"
                                                                   message:@"Watch your video anytime from Save App."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    if ([self saveAppInstalled]) {
        UIAlertAction *open = [UIAlertAction actionWithTitle:@"Open"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [self openShodoggApp];
                                                     }];
        [alert addAction:open];
    }
    UIAlertAction *close = [UIAlertAction actionWithTitle:@"Close"
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil];
    [alert addAction:close];
    [controller presentViewController:alert animated:YES completion:nil];
}

- (void)openShodoggApp {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kSaveAppScheme]];
}

- (BOOL)saveAppInstalled {
    NSURL *saveAppURL = [NSURL URLWithString:kSaveAppScheme];
    if ([[UIApplication sharedApplication] canOpenURL:saveAppURL]) {
        return YES;
    }
    return NO;
}
@end

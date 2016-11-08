//
//  NSError+SHAPIError.m
//  Pods
//
//  Created by Aamir Khan on 11/12/15.
//
//

#import "NSError+SHAPIError.h"
#import "SHUbeAPIClient.h"
#import <AFNetworking/AFURLResponseSerialization.h>

@implementation NSError (SHAPIError)

+ (NSString *)serverBaseURL {
    return [[SHUbeAPIClient sharedClient] baseURL].absoluteString;
}

+ (NSError *)errorWithDomain:(NSString *)domain
        localizedDescription:(NSString *)description
               failureReason:(NSString *)reason
          recoverySuggestion:(NSString *)suggestion {
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    userInfo[NSLocalizedDescriptionKey]             = NSLocalizedString(description, nil);
    userInfo[NSLocalizedFailureReasonErrorKey]      = NSLocalizedString(reason, nil);
    userInfo[NSLocalizedRecoverySuggestionErrorKey] = NSLocalizedString(suggestion, nil);
    return [NSError errorWithDomain:domain code:-57 userInfo:userInfo];
}

+ (NSError *)errorWithLocalizedDescription:(NSString *)description
                             failureReason:(NSString *)reason
                        recoverySuggestion:(NSString *)suggestion {
    NSString *domain = [NSError serverBaseURL];
    return [[self class] errorWithDomain:domain
                    localizedDescription:description
                           failureReason:reason
                      recoverySuggestion:suggestion];
}

+ (NSError *)errorWithLocalizedDescription:(NSString *)description {
    
    return [NSError errorWithLocalizedDescription:description
                                    failureReason:nil
                               recoverySuggestion:nil];
}

- (NSString *)getFailureMessageInResponseData {
    
    NSString *message = nil;
    NSDictionary *userInfo = self.userInfo;
    
    id object = userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    if (object) {
        message = [NSError parseJSONObject:object];
    }
    
    if (![message length]) {
        message = self.localizedDescription;
    }
    
    return message;
}

- (void)showAsAlertInController:(UIViewController *)controller {
    if (!self) {
        return;
    }
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:[self localizedFailureReason]
                                        message:[self getFailureMessageInResponseData]
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismiss =
    [UIAlertAction actionWithTitle:@"Ok"
                             style:UIAlertActionStyleCancel
                           handler:nil];
    [alert addAction:dismiss];
    [controller presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Parser

+ (NSString *)parseJSONObject:(id)object {

    NSError *error;
    NSData *data = object;
    if ([object isMemberOfClass:[NSString class]]) {
        object = [object dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSJSONReadingOptions options = NSJSONReadingAllowFragments;
    NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:options error:&error];
    return info[@"message"];
}
@end
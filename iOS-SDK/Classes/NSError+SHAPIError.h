;//
//  NSError+SHAPIError.h
//  Pods
//
//  Created by Aamir Khan on 11/12/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSError (SHAPIError)

+ (NSError *)errorWithLocalizedDescription:(NSString *)description;
+ (NSError *)errorWithDomain:(NSString *)domain
        localizedDescription:(NSString *)description
               failureReason:(NSString *)reason
          recoverySuggestion:(NSString *)suggestion;
+ (NSError *)errorWithLocalizedDescription:(NSString *)description
                             failureReason:(NSString *)reason
                        recoverySuggestion:(NSString *)suggestion;
- (NSString *)getFailureMessageInResponseData;
- (void)showAsAlertInController:(UIViewController *)controller;
@end
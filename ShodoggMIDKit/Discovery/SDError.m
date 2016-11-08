//
//  SDError.m
//  ShodoggSDK
//
//  Created by stepukaa on 11/3/15.
//  Copyright © 2015 stepukaa. All rights reserved.
//

#import "SDError.h"

#warning TODO: Error Domain?
NSString * const SDErrorDomain = @"com.shodogg.sdk.error";

@implementation SDError

+ (NSError*)wrappedErrorForError:(NSError *)error {
    if ([error.domain isEqualToString:ConnectErrorDomain]) {
        return [NSError errorWithDomain:SDErrorDomain
                                   code:error.code
                               userInfo:error.userInfo];
    } else {
        return error;
    }
}

@end

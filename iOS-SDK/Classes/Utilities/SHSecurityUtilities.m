//
//  SHSecurityUtilities.m
//  ShodoggSDK
//
//  Created by Aamir Khan on 9/17/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import "SHSecurityUtilities.h"
#include <CommonCrypto/CommonDigest.h>

@implementation SHSecurityUtilities

+ (NSString *)sha512ForString:(NSString *)string {
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [NSData dataWithBytes:cstr length:string.length];
    unsigned char digest[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(keyData.bytes, (CC_LONG)keyData.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH *2];
    for (int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

+ (NSString *)saltAndHashPassword:(NSString *)pwdString forUserWithEmail:(NSString *)emailString {
    NSString *hashedEmail = [self sha512ForString:emailString];
    NSString *preHashedPwd = [NSString stringWithFormat:@"%@--%@", hashedEmail, pwdString];
    NSString *hashedAndSaltedPwd = [self sha512ForString:preHashedPwd];
    return hashedAndSaltedPwd;
}

+ (NSString *)caseInsensitiveHashedPassword:(NSString *)password forEmail:(NSString *)email {
    NSString *caseInsensitiveEmail = [email lowercaseString];
    return [[self class] saltAndHashPassword:password forUserWithEmail:caseInsensitiveEmail];
}

@end
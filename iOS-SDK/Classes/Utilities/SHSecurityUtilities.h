//
//  SHSecurityUtilities.h
//  ShodoggSDK
//
//  Created by Aamir Khan on 9/17/13.
//  Copyright (c) 2013 Shodogg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHSecurityUtilities : NSObject

+ (NSString *)saltAndHashPassword:(NSString *)pwdString forUserWithEmail:(NSString *)emailString;
+ (NSString *)caseInsensitiveHashedPassword:(NSString *)password forEmail:(NSString *)email;
@end

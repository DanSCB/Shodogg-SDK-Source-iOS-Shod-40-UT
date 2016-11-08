//
//  SHMIDKeychain.h
//  Pods
//
//  Created by Aamir Khan on 1/8/16.
//
//

#import <Foundation/Foundation.h>

@interface SHMIDKeychain : NSObject
+ (void)initialize;
+ (NSDictionary *)credentials;
+ (void)deleteCredentials;
+ (void)setCredentials:(NSDictionary *)credentials;
@end

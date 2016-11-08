//
//  SHCookie.h
//  Pods
//
//  Created by Aamir Khan on 12/2/15.
//
//

#import <Foundation/Foundation.h>

@interface SHCookie : NSObject

@property (nonatomic, copy) NSString *guid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *domain;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) NSDate *expiresDate;
@property (nonatomic, strong) NSDate *created;

+ (SHCookie *)cookieWithProperties:(NSDictionary *)properties;
- (instancetype)initWithProperties:(NSDictionary *)properties;
- (NSDictionary *)toDictionary;
- (BOOL)hasExpired;
- (void)saveToLocalStorage;
- (void)removeFromLocalStorage;
@end
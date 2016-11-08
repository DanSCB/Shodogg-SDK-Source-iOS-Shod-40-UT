//
//  SHMIDKeychain.m
//  Pods
//
//  Created by Aamir Khan on 1/8/16.
//
//

#import "SHMIDKeychain.h"
#import "SHMIDClient.h"

static NSDictionary *kMIDKeychainDictionary;
static NSString* const kMIDKeychainAccessGroup = @"39GP2XZY5Z.com.shodogg.mid.shared-keychain";

@implementation SHMIDKeychain

+ (void)initialize {
    NSURL *environment = [NSURL URLWithString:ShodoggMIDDefaultServerURLString];
    if ([self class] != [SHMIDKeychain class]) return;
    kMIDKeychainDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                              (id)kSecClassGenericPassword, (id)kSecClass,
                              environment.host, (id)kSecAttrService,
                              kMIDKeychainAccessGroup, (id)kSecAttrAccessGroup,
                              (id)kCFBooleanTrue, (id)kSecAttrSynchronizable, nil];
}

+ (NSDictionary *)credentials {
    NSMutableDictionary *searchDict = [NSMutableDictionary dictionaryWithDictionary:kMIDKeychainDictionary];
    [searchDict setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    [searchDict setObject:(id)kCFBooleanTrue    forKey:(id)kSecReturnAttributes];
    [searchDict setObject:(id)kCFBooleanTrue    forKey:(id)kSecReturnData];
    NSDictionary *attrDict = nil;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)searchDict, (CFTypeRef *)&attrDict);
    [attrDict autorelease];
    NSData *foundValue = [attrDict objectForKey:(id)kSecValueData];
    if (status == noErr && foundValue) {
        NSLog(@"%s: success reading credentials with status(%i)", __PRETTY_FUNCTION__, (int32_t)status);
        return [NSKeyedUnarchiver unarchiveObjectWithData:foundValue];
    } else {
        if (status != errSecItemNotFound) {
            NSLog(@"%s: error reading stored credentials (%i)", __PRETTY_FUNCTION__, (int32_t)status);
        }
        return nil;
    }
}

+ (void)setCredentials:(NSDictionary *)credentials {
    NSData *credentialData = [NSKeyedArchiver archivedDataWithRootObject:credentials];
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionaryWithDictionary:kMIDKeychainDictionary];
    [attrDict setObject:credentialData forKey:(id)kSecValueData];
    [attrDict setObject:(id)kSecAttrAccessibleAfterFirstUnlock forKey:(id)kSecAttrAccessible];
    OSStatus status = noErr;
    if ([self credentials]) {
        [attrDict removeObjectForKey:(id)kSecClass];
        NSLog(@"%s: success updating credentials with status(%i)", __PRETTY_FUNCTION__, (int32_t)status);
        status = SecItemUpdate((CFDictionaryRef)kMIDKeychainDictionary, (CFDictionaryRef)attrDict);
    } else {
        NSLog(@"%s: success adding new credentials with status(%i)", __PRETTY_FUNCTION__, (int32_t)status);
        status = SecItemAdd((CFDictionaryRef)attrDict, NULL);
    }
    if (status != noErr) {
        NSLog(@"%s: error saving credentials (%i)", __PRETTY_FUNCTION__, (int32_t)status);
    }
}

+ (void)deleteCredentials {
    OSStatus status = SecItemDelete((CFDictionaryRef)kMIDKeychainDictionary);
    if (status != noErr) {
        NSLog(@"%s: error deleting credentials (%i)", __PRETTY_FUNCTION__, (int32_t)status);
    }
}

@end

//
//  PocketCredentials.m
//  Pocket API
//
//  Created by Tyler Nettleton on 9/16/12.
//  Copyright (c) 2012 Tyler Nettleton. All rights reserved.
//

#import "PocketCredentials.h"

@implementation PocketCredentials


+ (NSMutableDictionary *)setupSearchDirectoryForIdentifier:(NSString *)identifier {
    
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    [searchDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [searchDictionary setObject:@"pocket" forKey:(__bridge id)kSecAttrService];
	
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrGeneric];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrAccount];
	
    return searchDictionary;
}

+ (NSData *)searchKeychainCopyMatchingIdentifier:(NSString *)identifier
{
    NSMutableDictionary *searchDictionary = [self setupSearchDirectoryForIdentifier:identifier];
    [searchDictionary setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
	
    [searchDictionary setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
	
    NSData *result = nil;
    CFTypeRef foundDict = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary, &foundDict);
    
    if (status == noErr) {
        result = (__bridge_transfer NSData *)foundDict;
    } else {
        result = nil;
    }
    
    return result;
}

+ (NSString *)getValueFromKey:(NSString *)key {
    NSData *valueData = [self searchKeychainCopyMatchingIdentifier:key];
    if (valueData) {
        NSString *value = [[NSString alloc] initWithData:valueData
                                                encoding:NSUTF8StringEncoding];
        return value;
    } else {
        return nil;
    }
}

+ (BOOL)createValue:(NSString *)value forKey:(NSString *)key { 
    
    NSMutableDictionary *dictionary = [self setupSearchDirectoryForIdentifier:key];
    NSData *valueData = [value dataUsingEncoding:NSUTF8StringEncoding];
    [dictionary setObject:valueData forKey:(__bridge id)kSecValueData];
    
    [dictionary setObject:(__bridge id)kSecAttrAccessibleWhenUnlocked forKey:(__bridge id)kSecAttrAccessible];
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);
	
    if (status == errSecSuccess) {
        return YES;
    } else if (status == errSecDuplicateItem){
        return [self updateValue:value forKey:key];
    } else {
        return NO;
    }
}

+ (BOOL)updateValue:(NSString *)value forKey:(NSString *)Key {
    
    NSMutableDictionary *searchDictionary = [self setupSearchDirectoryForIdentifier:Key];
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    NSData *valueData = [value dataUsingEncoding:NSUTF8StringEncoding];
    [updateDictionary setObject:valueData forKey:(__bridge id)kSecValueData];
	
    // Update.
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)searchDictionary,
                                    (__bridge CFDictionaryRef)updateDictionary);
	
    if (status == errSecSuccess) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)removeValueForKey:(NSString *)key
{
    NSMutableDictionary *searchDictionary = [self setupSearchDirectoryForIdentifier:key];
    CFDictionaryRef dictionary = (__bridge CFDictionaryRef)searchDictionary;
    
    SecItemDelete(dictionary);
}





@end

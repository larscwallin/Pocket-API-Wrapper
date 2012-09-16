//
//  PocketCredentials.h
//  Pocket API
//
//  Created by Tyler Nettleton on 9/16/12.
//  Copyright (c) 2012 Tyler Nettleton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PocketCredentials : NSObject


+ (NSString *)getValueFromKey:(NSString *)key;

+ (BOOL)createValue:(NSString *)value forKey:(NSString *)key;

+ (BOOL)updateValue:(NSString *)value forKey:(NSString *)Key;

+ (void)removeValueForKey:(NSString *)key;


@end

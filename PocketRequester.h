//
//  PocketRequester.h
//  Pocket API
//
//  Created by Tyler Nettleton on 9/16/12.
//  Copyright (c) 2012 Tyler Nettleton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PocketRequest.h"

typedef enum {
    PocketErrorNoUserName,
    PocketErrorNoPassword,
    PocketErrorNoAPIKey
} PocketError;

@protocol PocketRequesterDelegate <NSObject>

- (void)didFailWithError:(PocketError)error;

@end

@interface PocketRequester : NSObject


+ (id)sharedInstance;

- (void)requestWithRequest:(PocketRequest *)request;

- (void)setUsername:(NSString *)username andPassword:(NSString *)password;

- (void)setAPIKey:(NSString *)APIKey;

@property (nonatomic, weak) id <PocketRequesterDelegate> delegate;


@end

//
//  PocketResponse.h
//  Pocket API
//
//  Created by Tyler Nettleton on 9/16/12.
//  Copyright (c) 2012 Tyler Nettleton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PocketRequest.h"


typedef enum {
    PocketReturnStatusOk,
    PocketReturnStatusInvalidRequest,
    PocketReturnStatusInvalidLogin,
    PocketReturnStatusRateLimit,
    PocketReturnStatusDownForMaintenance
} PocketReturnStatus;

@interface PocketResponse : NSObject



- (id)initWithRequest:(PocketRequest *)request;
- (NSString *)stringValue;
- (BOOL)authed;
- (int)response;
@end

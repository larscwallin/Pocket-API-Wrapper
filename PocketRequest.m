//
//  PocketRequest.m
//  Pocket API
//
//  Created by Tyler Nettleton on 9/16/12.
//  Copyright (c) 2012 Tyler Nettleton. All rights reserved.
//

#import "PocketRequest.h"


#define BASE_URL @"https://readitlaterlist.com/v2/"

@interface PocketRequest ()

@end


@implementation PocketRequest



- (id)initWithRequestType:(PocketRequestType)type {
    self = [super init];
    
    if (self) {
        _PocketDidBeginLoadingDictionary = [[NSMutableDictionary alloc] init];
        _PocketDidFinishDictionary = [[NSMutableDictionary alloc] init];
        _PocketDidFailDictionary = [[NSMutableDictionary alloc] init];
        _URL = [NSString stringWithFormat:@"%@", BASE_URL];
        _type = type;
        _responseData = [[NSMutableData alloc] init];
    }
    return self;
}



- (void)addTarget:(id)target action:(SEL)selector forEvent:(PocketEvent)event {
    switch (event) {
        case PocketEventBegan:
            CFDictionaryAddValue((__bridge CFMutableDictionaryRef)(self.PocketDidBeginLoadingDictionary), (__bridge const void *)(target), (__bridge const void *)(NSStringFromSelector(selector)));
            break;
        case PocketEventDidFinish:
            CFDictionaryAddValue((__bridge CFMutableDictionaryRef)(self.PocketDidFinishDictionary), (__bridge const void *)(target), (__bridge const void *)(NSStringFromSelector(selector)));
            break;
        case PocketEventDidFail:
            CFDictionaryAddValue((__bridge CFMutableDictionaryRef)(self.PocketDidFailDictionary), (__bridge const void *)(target), (__bridge const void *)(NSStringFromSelector(selector)));
            break;
        default:
            break;
    }
}


@end

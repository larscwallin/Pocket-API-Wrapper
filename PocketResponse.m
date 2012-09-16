//
//  PocketResponse.m
//  Pocket API
//
//  Created by Tyler Nettleton on 9/16/12.
//  Copyright (c) 2012 Tyler Nettleton. All rights reserved.
//

#import "PocketResponse.h"
#import "PocketRequest.h"

@interface PocketResponse ()

@property (nonatomic, strong) PocketRequest *request;

@end

@implementation PocketResponse
- (id)initWithRequest:(PocketRequest *)request {
    self = [super init];
    if (self) {
        _request = request;
    }
return self;
}

- (NSString *)stringValue {
    return [[NSString alloc] initWithData:self.request.responseData encoding:NSUTF8StringEncoding];
}

- (BOOL)authed {
    NSCharacterSet *numberSet = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
    NSString *originalString = [[NSString alloc] initWithData:self.request.responseData encoding:NSUTF8StringEncoding];
    NSString *newString = [[originalString componentsSeparatedByCharactersInSet:
                            [numberSet invertedSet]]
                           componentsJoinedByString:@""];
    if (self.request.type == PocketRequestTypeLogin) {
        if ([newString isEqualToString:@"200"]) {
            return true;
        } else {
            return false;
        }
    }
    return false;
}

- (int)response {
    
    NSCharacterSet *numberSet = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
    NSString *originalString = [[NSString alloc] initWithData:self.request.responseData encoding:NSUTF8StringEncoding];
    NSString *newString = [[originalString componentsSeparatedByCharactersInSet:
                            [numberSet invertedSet]]
                           componentsJoinedByString:@""];    
    
    if (self.request.type == PocketRequestTypeSave) {
        switch ([newString intValue]) {
            case 200:
                return PocketReturnStatusOk;
                break;
            case 400:
                return PocketReturnStatusInvalidRequest;
                break;
            case 401:
                return PocketReturnStatusInvalidLogin;
                break;
            case 403:
                return PocketReturnStatusRateLimit;
                break;
            case 503:
                return PocketReturnStatusDownForMaintenance;
                break;
            default:
                break;
        }
    }
    return false;
}

@end

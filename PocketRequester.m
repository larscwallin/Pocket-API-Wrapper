//
//  PocketRequester.m
//  Pocket API
//
//  Created by Tyler Nettleton on 9/16/12.
//  Copyright (c) 2012 Tyler Nettleton. All rights reserved.
//

#import "PocketRequester.h"
#import "PocketRequest.h"
#import "PocketResponse.h"
#import "PocketCredentials.h"
#import <objc/message.h>


#define BASE_URL @"https://readitlaterlist.com/v2/"

@interface PocketRequester ()

@property (nonatomic, assign) CFMutableDictionaryRef connectionData;

@end

@implementation PocketRequester

static PocketRequester *sharedInstance = nil;


+ (PocketRequester *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        _connectionData = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    }
    return self;
}


- (void)requestWithRequest:(PocketRequest *)request {
    switch (request.type) {
        case PocketRequestTypeLogin:
            // TODO - Validate login
            [self validateLoginRequest:request];
            break;
        case PocketRequestTypeSave:
            [self saveURLForRequest:request];
            break;
        default:
            break;
    }
}

- (void)validateLoginRequest:(PocketRequest *)pocketRequest {
    if (!pocketRequest.username) {
        if ([self.delegate respondsToSelector:@selector(didFailWithError:)])  {
            [self.delegate didFailWithError:PocketErrorNoUserName];
        }
    }
    if (!pocketRequest.password) {
        if ([self.delegate respondsToSelector:@selector(didFailWithError:)])  {
            [self.delegate didFailWithError:PocketErrorNoPassword];
        }
    }
    if (!pocketRequest.APIKey) {
        if ([self.delegate respondsToSelector:@selector(didFailWithError:)])  {
            [self.delegate didFailWithError:PocketErrorNoAPIKey];
        }
    }
    
    [self setUsername:pocketRequest.username andPassword:pocketRequest.password];
    [self setAPIKey:pocketRequest.APIKey];
        
    NSString *urlString = [NSString stringWithFormat:@"%@%@?username=%@&password=%@&apikey=%@", BASE_URL, @"auth", pocketRequest.username, pocketRequest.password, pocketRequest.APIKey];
    NSURL *requestURL = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection *requestConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    if (!requestConnection ) {
        // TODO - Add error handling
    }
    
    CFDictionaryAddValue(self.connectionData, (__bridge const void *)(requestConnection), (__bridge const void *)(pocketRequest));
}

- (void)saveURLForRequest:(PocketRequest *)pocketRequest {
    //username=name&password=123&apikey=yourapikey&url=http://google.com&title=Google
    NSString *urlString = [NSString stringWithFormat:@"%@%@?username=%@&password=%@&apikey=%@&url=%@&title=%@", BASE_URL, @"add", [PocketCredentials getValueFromKey:@"username"], [PocketCredentials getValueFromKey:@"password"], [PocketCredentials getValueFromKey:@"APIKey"], pocketRequest.articleURL, pocketRequest.articleTitle];
    NSURL *requestURL = [NSURL URLWithString:urlString];
    NSLog(@"Sending url %@", urlString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection *requestConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    if (!requestConnection ) {
        // TODO - Add error handling
    }
    
    CFDictionaryAddValue(self.connectionData, (__bridge const void *)(requestConnection), (__bridge const void *)(pocketRequest));
}

- (void)setUsername:(NSString *)username andPassword:(NSString *)password {
    [PocketCredentials createValue:username forKey:@"username"];
    [PocketCredentials createValue:password forKey:@"password"];
}

- (void)setAPIKey:(NSString *)APIKey {
    [PocketCredentials createValue:APIKey forKey:@"APIKey"];
}



#pragma mark - NSURLConnectionDelegate Protocol Implementation

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    PocketRequest *pocketRequest = (__bridge PocketRequest *)(CFDictionaryGetValue(self.connectionData, (__bridge const void *)(connection)));
    
    for (id target in [pocketRequest.PocketDidBeginLoadingDictionary allKeys]) {
        SEL action = NSSelectorFromString([pocketRequest.PocketDidBeginLoadingDictionary objectForKey:target]);
        objc_msgSend(target, action);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    PocketRequest *pocketRequest = (__bridge PocketRequest *)(CFDictionaryGetValue(self.connectionData, (__bridge const void *)(connection)));    
    [pocketRequest.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    PocketRequest *pocketRequest = (__bridge PocketRequest *)(CFDictionaryGetValue(self.connectionData, (__bridge const void *)(connection)));
    PocketResponse *httpResponse = [[PocketResponse alloc] initWithRequest:pocketRequest];
    
    for (id target in [pocketRequest.PocketDidFinishDictionary allKeys]) {
        SEL action = NSSelectorFromString([pocketRequest.PocketDidFinishDictionary objectForKey:target]);
        objc_msgSend(target, action, httpResponse);
    }
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    PocketRequest *pocketRequest = (__bridge PocketRequest *)(CFDictionaryGetValue(self.connectionData, (__bridge const void *)(connection)));
    
    for (id target in [pocketRequest.PocketDidFailDictionary allKeys]) {
        SEL action = NSSelectorFromString([pocketRequest.PocketDidFailDictionary objectForKey:target]);
        objc_msgSend(target, action, error);
    }
}


#pragma mark - Override Alloc/Copy for Singleton

+ (id)allocWithZone:(NSZone*)zone {
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}


@end

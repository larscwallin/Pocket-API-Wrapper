//
//  PocketRequest.h
//  Pocket API
//
//  Created by Tyler Nettleton on 9/16/12.
//  Copyright (c) 2012 Tyler Nettleton. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    PocketEventBegan,
    PocketEventDidFinish,
    PocketEventDidFail
} PocketEvent;

typedef enum {
    PocketRequestTypeLogin,
    PocketRequestTypeSave
} PocketRequestType;



@interface PocketRequest : NSObject

@property (nonatomic, strong) NSURLConnection *requestConnection;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSMutableDictionary *PocketDidBeginLoadingDictionary;
@property (nonatomic, strong) NSMutableDictionary *PocketDidFinishDictionary;
@property (nonatomic, strong) NSMutableDictionary *PocketDidFailDictionary;
@property (nonatomic, strong) NSString *URL;
@property (nonatomic, assign) PocketRequestType type;
@property (nonatomic, assign) NSString *username;
@property (nonatomic, assign) NSString *password;
@property (nonatomic, assign) NSString *APIKey;
@property (nonatomic, assign) NSString *articleURL;
@property (nonatomic, assign) NSString *articleTitle;





- (id)initWithRequestType:(PocketRequestType)type;

- (void)addTarget:(id)target action:(SEL)selector forEvent:(PocketEvent)event;

@end

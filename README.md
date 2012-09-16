Pocket-API-Wrapper
==================

This is a simple, quickly put togeather API wrapper for the pocket service.

Cool Features
=============
- Response objects
- Mutiple callbacks for events

Example Usage
=============

Logging in
----------
```objc
PocketRequest *newRequest = [[PocketRequest alloc] initWithRequestType:PocketRequestTypeLogin];
[newRequest setUsername:@"username"];
[newRequest setPassword:@"password"];
[newRequest setAPIKey:@"yourapikey"];
[newRequest addTarget:self action:@selector(didLogin:) forEvent:PocketEventDidFinish];
[[PocketRequester sharedInstance] requestWithRequest:newRequest];
```

Saving an article
-----------------
```objc
PocketRequest *newRequest = [[PocketRequest alloc] initWithRequestType:PocketRequestTypeSave];
[newRequest setArticleURL:@"http://google.com"];
[newRequest setArticleTitle:@"google"];
[newRequest addTarget:self action:@selector(savedURL:) forEvent:PocketEventDidFinish];
[[PocketRequester sharedInstance] requestWithRequest:newRequest];


/*
	PocketReturnStatusOk,
	PocketReturnStatusInvalidRequest,
	PocketReturnStatusInvalidLogin,
	PocketReturnStatusRateLimit,
	PocketReturnStatusDownForMaintenance
*/
- (void)savedURL:(PocketResponse *)pocketResponse {
    switch ([pocketResponse response]) {
        case PocketReturnStatusOk:
            NSLog(@"ok");
            break;
            
        default:
            break;
    }
}

```
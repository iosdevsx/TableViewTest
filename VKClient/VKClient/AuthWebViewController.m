//
//  AuthWebViewController.m
//  VKClient
//
//  Created by jsd on 15.03.16.
//  Copyright © 2016 jsd. All rights reserved.
//

#import "AuthWebViewController.h"
#import "JDAccessToken.h"

static NSString* const VK_APP_ID = @"5277780";

@interface AuthWebViewController ()

@end

@implementation AuthWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (NSHTTPCookie* cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
        
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
    NSString* loginUrlString = [NSString stringWithFormat:
    @"https://oauth.vk.com/authorize?"
    "client_id=%@&"
    "display=mobile&"
    "redirect_uri=https://oauth.vk.com/blank.html&"
    "scope=139286&"
    "response_type=token&"
    "v=5.50", VK_APP_ID];
    
    NSURL* loginUrl = [NSURL URLWithString:loginUrlString];
    NSURLRequest* loginRequest = [NSURLRequest requestWithURL:loginUrl];
    [self.webView loadRequest:loginRequest];
}

-(void)dealloc
{
    NSLog(@"dealloc");
    self.webView.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[[request URL] description] rangeOfString:@"#access_token="].location != NSNotFound)
    {
        NSString* fragment = [[request URL] fragment];
        NSArray* items = [fragment componentsSeparatedByString:@"&"];
        
        NSString* token;
        NSString* userId;
        NSDate* expireDate;
        
        for (NSString* item in items)
        {
            NSArray* components = [item componentsSeparatedByString:@"="];
            
            NSString* key = [components firstObject];
            NSString* value = [components lastObject];
            
            if ([key isEqualToString:@"access_token"])
            {
                token = value;
            } else if ([key isEqualToString:@"expires_in"])
            {
                NSTimeInterval interval = [value doubleValue];
                expireDate = [[NSDate date] dateByAddingTimeInterval:interval];
                
            } else if ([key isEqualToString:@"user_id"])
            {
                userId = value;
            }
        }
        
        if (self.JDAuthCompletionBlock)
        {
            self.JDAuthCompletionBlock([JDAccessToken accessTokenWith:token userId:userId expireDate:expireDate]);
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    return YES;
}


@end

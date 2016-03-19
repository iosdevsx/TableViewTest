//
//  AuthWebViewController.h
//  VKClient
//
//  Created by jsd on 15.03.16.
//  Copyright © 2016 jsd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDAccessToken;

@interface AuthWebViewController : UIViewController

@property (copy, nonatomic) void(^JDAuthCompletionBlock)(JDAccessToken*token);
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

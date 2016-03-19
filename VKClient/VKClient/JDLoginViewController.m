//
//  JDLoginViewController.m
//  VKClient
//
//  Created by jsd on 15.03.16.
//  Copyright © 2016 jsd. All rights reserved.
//

#import "JDLoginViewController.h"
#import "AuthWebViewController.h"
#import "JDAccessToken.h"
#import "JDServerManager.h"
#import "JDUser.h"

@interface JDLoginViewController ()

@end

@implementation JDLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void) showInfoForUser: (JDUser*) user
{
    [JDUser setCurrentUser:user];
    if (self.loginSuccess)
    {
        self.loginSuccess();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Actions

- (IBAction)actionLogin:(UIButton *)sender
{
    AuthWebViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthWebViewController"];
    [vc setJDAuthCompletionBlock:^(JDAccessToken* token) {
        NSError* error;
        [JDAccessToken addToken:token error:&error];
        if (error)
        {
            NSLog(@"%@", [error localizedDescription]);
            return;
        }
        [[JDServerManager sharedManager] getUserInfoForId:token.userId onSuccess:^(JDUser *user, BOOL cached) {
            [self showInfoForUser:user];
        } failure:^(NSError *error) {
           if (error)
           {
               NSLog(@"%@", [error localizedDescription]);
           }
        }];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}



@end

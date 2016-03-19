//
//  JDUserInfoViewController.m
//  VKClient
//
//  Created by jsd on 15.03.16.
//  Copyright © 2016 jsd. All rights reserved.
//

#import "JDUserInfoViewController.h"
#import "JDLoginViewController.h"
#import "JDAccessToken.h"
#import "JDServerManager.h"
#import "JDUser.h"

@interface JDUserInfoViewController ()

@end

@implementation JDUserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    JDAccessToken* token = [JDAccessToken currentToken];
    if (!token.isValid)
    {
        [self showLoginController];
    } else
    {
        [self setupUserInfoForToken:token];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void) showLoginController
{
    JDLoginViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"JDLoginViewController"];
    [vc setLoginSuccess:^{
        JDAccessToken* token = [JDAccessToken currentToken];
        if (token)
        {
            [self setupUserInfoForToken:token];
        } else
        {
            NSLog(@"error occuring");
        }
    }];
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void) setupUserInfoForToken: (JDAccessToken*) token
{
    [[JDServerManager sharedManager] getUserInfoForId:token.userId onSuccess:^(JDUser *user, BOOL cached)
     {
         self.firstName.text = user.first_name;
         self.lastName.text = user.last_name;
         
         NSURL* url = [NSURL URLWithString:user.photo_50];
         NSURLRequest* request = [NSURLRequest requestWithURL:url];
         
         UIImage* placeholder = [UIImage imageNamed:@"placeholder.png"];
         [self.photo setImageWithURLRequest:request placeholderImage:placeholder success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
             self.photo.image = image;
         } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
             [self printError:error];
         }];
     } failure:^(NSError *error) {
         [self printError:error];
     }];
}

- (void) printError:(NSError*) error
{
    if (error)
    {
        NSLog(@"%@", [error localizedDescription]);
    }
}

#pragma mark - Actions

- (IBAction)actionLogout:(UIBarButtonItem *)sender
{
    JDUser* current = [JDUser currentUser];
    
    [current MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
    
    [JDUser setCurrentUser:nil];
    [self showLoginController];
}

@end

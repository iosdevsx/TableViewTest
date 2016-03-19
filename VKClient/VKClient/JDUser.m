//
//  JDUser.m
//  VKClient
//
//  Created by jsd on 15.03.16.
//  Copyright © 2016 jsd. All rights reserved.
//

#import "JDUser.h"
#import "NSString+Helper.h"

@implementation JDUser

+ (JDUser*) currentUser
{
    NSDictionary* dictionary = [NSDictionary dictionaryWithContentsOfFile:[NSString pathForFileName:@"user.plist"]];
    if (!dictionary)
    {
        return nil;
    }
    return [JDUser MR_findFirstByAttribute:@"id" withValue:dictionary[@"currentUserId"]];
}

+ (void) setCurrentUser: (nullable JDUser*) user
{
    NSString* path = [NSString pathForFileName:@"user.plist"];
    if (!user)
    {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        return;
    }
    NSDictionary* dictionary = @{@"currentUserId":user.id};
    [dictionary writeToFile:path atomically:NO];
}

@end

//
//  JDAccessToken.m
//  VKClient
//
//  Created by jsd on 15.03.16.
//  Copyright © 2016 jsd. All rights reserved.
//

#import "JDAccessToken.h"
#import "JDUser.h"

static NSString* TokenKey = @"token";
static NSString* UserIdKey = @"userId";
static NSString* ExpireDateKey = @"expireDate";

static NSString* KeyChainService = @"com.keychain.access_token";

@implementation JDAccessToken

+ (instancetype) currentToken
{
    JDUser* user = [JDUser currentUser];
    return [JDAccessToken tokenWithUserId:[user.id stringValue]];
}

//fetching token from keychain for userid
+ (instancetype) tokenWithUserId: (NSString*) userId
{
    if (!userId)
    {
        return nil;
    }
    UICKeyChainStore* keyChain = [UICKeyChainStore keyChainStoreWithService:KeyChainService];
    return [NSKeyedUnarchiver unarchiveObjectWithData:[keyChain dataForKey:userId]];
}

//Add new token to keychain
+ (void) addToken: (JDAccessToken*) token error: (NSError**) error
{
    if (!token)
    {
        return;
    }
    UICKeyChainStore* keyChain = [UICKeyChainStore keyChainStoreWithService:KeyChainService];
    [keyChain removeItemForKey:token.userId];
    [keyChain setData:[NSKeyedArchiver archivedDataWithRootObject:token] forKey:token.userId error:error];
}

- (BOOL) isValid
{
    if (!self.expireDate)
    {
        return NO;
    }
    return [[NSDate date] compare:self.expireDate] == NSOrderedAscending;
}

+ (instancetype) accessTokenWith: (NSString*) token userId: (NSString*) userId expireDate: (NSDate*) date
{
    return [[JDAccessToken alloc] initWithToken:token userId:userId expireDate:date];
}

- (instancetype)initWithToken: (NSString*) token userId: (NSString*) userId expireDate: (NSDate*) date
{
    if (!token || !userId || !date)
    {
        return nil;
    }
    
    self = [super init];
    if (self)
    {
        self.token = token;
        self.userId = userId;
        self.expireDate = date;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.token = [coder decodeObjectOfClass:[NSString class] forKey:TokenKey];
        self.userId = [coder decodeObjectOfClass:[NSString class] forKey:UserIdKey];
        self.expireDate = [coder decodeObjectOfClass:[NSDate class] forKey:ExpireDateKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.token forKey:TokenKey];
    [coder encodeObject:self.userId forKey:UserIdKey];
    [coder encodeObject:self.expireDate forKey:ExpireDateKey];
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end

//
//  JDAccessToken.h
//  VKClient
//
//  Created by jsd on 15.03.16.
//  Copyright © 2016 jsd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UICKeyChainStore/UICKeyChainStore.h>

@interface JDAccessToken : NSObject <NSSecureCoding>

@property (strong, nonatomic) NSString* token;
@property (strong, nonatomic) NSString* userId;
@property (strong, nonatomic) NSDate* expireDate;
@property (assign, nonatomic) BOOL isValid;

+ (JDAccessToken*) currentToken;
+ (void) addToken: (JDAccessToken*) token error: (NSError**) error;
+ (instancetype) accessTokenWith: (NSString*) token userId: (NSString*) userId expireDate: (NSDate*) date;

@end

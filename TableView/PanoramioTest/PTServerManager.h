//
//  PTServerManager.h
//  PanoramioTest
//
//  Created by Dev on 08.02.16.
//  Copyright © 2016 Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <CoreLocation/CoreLocation.h>

@interface PTServerManager : NSObject

@property (strong, nonatomic) AFHTTPSessionManager* sessionManager;

+ (PTServerManager*) sharedManager;
- (void) getPhotosWithCount: (NSInteger) count
                   andOffset: (NSInteger) offset
                  onSuccess: (void(^)(NSArray* photos)) success
                  onFailure: (void(^)(NSError* error)) failure;

@end

//
//  PTServerManager.m
//  PanoramioTest
//
//  Created by Dev on 08.02.16.
//  Copyright © 2016 Dev. All rights reserved.
//

#import "PTServerManager.h"
#import "PTPhoto.h"

@implementation PTServerManager

+ (PTServerManager*) sharedManager
{
    static PTServerManager* sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[PTServerManager alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSURL* baseURL = [NSURL URLWithString:@"http://www.panoramio.com/map/"];
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    }
    return self;
}

- (void) getPhotosWithCount: (NSInteger) count
                   andOffset: (NSInteger) offset
                  onSuccess: (void(^)(NSArray* photos)) success
                  onFailure: (void(^)(NSError* error)) failure
{
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"public", @"set",
                            @(offset), @"from",
                            @(offset + count), @"to",
                            @(-180), @"minx",
                            @(-90), @"miny",
                            @(180), @"maxx",
                            @(90), @"maxy",
                            @"medium", @"size",
                            @"true", @"mapfilter",
                            nil];
    [self.sessionManager
     GET:@"get_panoramas.php?"
     parameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSArray* photos = [responseObject objectForKey:@"photos"];
         NSMutableArray* photoObjects = [NSMutableArray array];
         for (NSDictionary* dictionary in photos)
         {
             PTPhoto* photoObject = [[PTPhoto alloc] initWithDictionary:dictionary];
             [photoObjects addObject:photoObject];
         }
         success(photoObjects);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

@end

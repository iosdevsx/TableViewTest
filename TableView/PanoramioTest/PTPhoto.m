//
//  PTPhoto.m
//  PanoramioTest
//
//  Created by Dev on 08.02.16.
//  Copyright © 2016 Dev. All rights reserved.
//

#import "PTPhoto.h"

@implementation PTPhoto

- (instancetype)initWithDictionary: (NSDictionary*) dictionary
{
    self = [super init];
    if (self)
    {
        self.photoTitle = [dictionary objectForKey:@"photo_title"];
        NSString* photoString = [dictionary objectForKey:@"photo_url"];
        if (photoString)
        {
            self.photoUrl = [NSURL URLWithString:photoString];
        }
        
        NSString* photoFileString = [dictionary objectForKey:@"photo_file_url"];
        if (photoFileString)
        {
            self.photoFileUrl = [NSURL URLWithString:photoFileString];
        }
        double longitude = [[dictionary objectForKey:@"longitude"] doubleValue];
        double latitude = [[dictionary objectForKey:@"latitude"] doubleValue];
        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        self.photoId = [[dictionary objectForKey:@"photo_id"] intValue];
        self.height = [[dictionary objectForKey:@"height"] floatValue];
        self.width = [[dictionary objectForKey:@"width"] floatValue];
    }
    return self;
}
@end

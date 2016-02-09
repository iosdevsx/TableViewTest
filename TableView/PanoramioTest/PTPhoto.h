//
//  PTPhoto.h
//  PanoramioTest
//
//  Created by Dev on 08.02.16.
//  Copyright © 2016 Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface PTPhoto : NSObject

@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGFloat width;
@property (strong, nonatomic) NSString* photoTitle;
@property (strong, nonatomic) NSURL* photoFileUrl;
@property (strong, nonatomic) NSURL* photoUrl;
@property (assign, nonatomic) NSInteger photoId;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

- (instancetype)initWithDictionary: (NSDictionary*) dictionary;

@end

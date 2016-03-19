//
//  JDLoginViewController.h
//  VKClient
//
//  Created by jsd on 15.03.16.
//  Copyright © 2016 jsd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDLoginViewController : UIViewController

@property (copy, nonatomic) void(^loginSuccess)();

@end

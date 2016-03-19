//
//  JDUser+CoreDataProperties.h
//  VKClient
//
//  Created by jsd on 15.03.16.
//  Copyright © 2016 jsd. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "JDUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface JDUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *first_name;
@property (nullable, nonatomic, retain) NSString *last_name;
@property (nullable, nonatomic, retain) NSString *photo_50;
@property (nullable, nonatomic, retain) NSNumber *id;

@end

NS_ASSUME_NONNULL_END

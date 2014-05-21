//
//  Event.h
//  Locations
//
//  Created by Aditya Narayan on 5/19/14.
//  Copyright (c) 2014 TurnToTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;

@end

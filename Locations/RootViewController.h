//
//  RootViewController.h
//  Locations
//
//  Created by Aditya Narayan on 5/19/14.
//  Copyright (c) 2014 TurnToTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Event.h"

@interface RootViewController : UITableViewController <CLLocationManagerDelegate>


@property (nonatomic, retain) NSMutableArray *eventsArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) UIBarButtonItem *addButton;


-(void)addEvent;

@end

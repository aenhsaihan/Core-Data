//
//  RootViewController.m
//  Locations
//
//  Created by Aditya Narayan on 5/19/14.
//  Copyright (c) 2014 TurnToTech. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.title = @"Locations";
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEvent)];
    self.addButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = self.addButton;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.locationManager.delegate = self;
    
    [self.locationManager startUpdatingLocation];
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [request setSortDescriptors:sortDescriptors];
    
    
    NSError *error = nil;
    
    NSMutableArray *mutableFetchRequests = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchRequests == nil) {
        
        //Handle the error...
        
    }
    
    [self setEventsArray:mutableFetchRequests];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.eventsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // A date formatter for the date stamp.
    
    static NSDateFormatter *dateFormatter = nil;
    
    if (dateFormatter == nil) {
        
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    }
    
    
    // A number formatter for the latitude and longitude
    
    static NSNumberFormatter *numberFormatter = nil;
    if (numberFormatter == nil) {
        
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [numberFormatter setMaximumFractionDigits:3];
    }
    
    
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) { cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier]; }
    
    Event *event = (Event *)[self.eventsArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dateFormatter stringFromDate:[event creationDate]];
    
    NSString *string = [NSString stringWithFormat:@"%@, %@",
                        [numberFormatter stringFromNumber:[event latitude]],
                        [numberFormatter stringFromNumber:[event longitude]]];
    
    cell.detailTextLabel.text = string;
    
    // Configure the cell...
    
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the managed object at the given index path
        NSManagedObject *eventToDelete = [self.eventsArray objectAtIndex:indexPath.row];
        [self.managedObjectContext deleteObject:eventToDelete];
        
        
        // Delete the row from the data source
        [self.eventsArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
        // Commit the change
        NSError *error = nil;
        
        if (![self.managedObjectContext save:&error]) {
            
            // Handle the error...
            
            NSLog(@"Error: %@", [error localizedDescription]);
            
        }
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

//-(CLLocationManager *)locationManager
//{
//    
//    if (self.locationManager != nil) {
//        return self.locationManager;
//    }
//    
//    self.locationManager = [[CLLocationManager alloc] init];
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
//    self.locationManager.delegate = self;
//    
//    return self.locationManager;
//}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.addButton.enabled = YES;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.addButton.enabled = NO;
}

-(void)addEvent
{
    
    CLLocation *location = [self.locationManager location];
    
    if (!location) {
        return;
    }
    
    //Create and configure a new instance of the Event entity
    
    Event *event = (Event *)[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    
    
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    [event setLatitude:[NSNumber numberWithDouble:coordinate.latitude]];
    [event setLongitude:[NSNumber numberWithDouble:coordinate.longitude]];
    [event setCreationDate:[NSDate date]];
    
    
    NSError *error = nil;
    
    if (![self.managedObjectContext save:&error]) {
        
        //Handle the error...
        
    }
    
    
    [self.eventsArray insertObject:event atIndex:0];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    
}

@end

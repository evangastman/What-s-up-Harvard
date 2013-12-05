//
//  MyTableDateController.m
//  What's Up Harvard
//
//  Created by Alex Yang on 2013-11-14.
//  Copyright (c) 2013 Alex Yang. All rights reserved.
//  Based off of ParseStarterProject created by James Yu on 12/29/11.
//

#import "MyTableDateController.h"
#import "EventDateCell.h"
#import "EventDetailViewController.h"
#import "EventDetailModel.h"
UIImage *tempimage;


@interface MyTableDateController() <UISearchDisplayDelegate, UISearchBarDelegate> {
    
}
// create search bar
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;

// objects to handle search method
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, retain) NSMutableDictionary *sections;
@property (nonatomic, retain) NSMutableDictionary *sectionToDateMap;

// additional objects to be passed on to event detail view controller
@property (strong, nonatomic) UIImage *tempimage2;
@property (strong, nonatomic) NSString *eventtime2;
@property (strong, nonatomic) NSString *eventdate2;
@property (strong, nonatomic) NSString *eventid2;

@end


@interface MyTableDateController ()

@end

@implementation MyTableDateController

// synthesize search method handlers
@synthesize sections = _sections;
@synthesize sectionToDateMap = _sectionToDateMap;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super initWithClassName:@"Events"];
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        // Initialize the table
        // The className to query on
        self.parseClassName = @"Events";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"name";
        
        // The title for this table in the Navigation Controller.
        self.title = @"By Date";
        
        // Enable pull-to-refresh
        self.pullToRefreshEnabled = YES;
        
        // Enable built-in pagination
        self.paginationEnabled = YES;
        
        self.sections = [NSMutableDictionary dictionary];
        self.sectionToDateMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // load search bar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
    self.tableView.tableHeaderView = self.searchBar;
    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.delegate = self;
    
    
    CGPoint offset = CGPointMake(0, self.searchBar.frame.size.height);
    self.tableView.contentOffset = offset;
    
    self.searchResults = [NSMutableArray array];
    
    //Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (PFQuery *)queryForTable {
    
    // query for all events and sort by ascending date
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    if (self.pullToRefreshEnabled) {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"date"];
    
    return query;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // set number of sections
    return self.sections.allKeys.count;
}

- (NSString *)timeForSection:(NSInteger)section {
    
    // define name for each section
    return [self.sectionToDateMap objectForKey:[NSNumber numberWithInt:section]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    // display number of events that occur at the same time
    NSString *eventTime = [self timeForSection:section];
    NSArray *rowIndecesInSection = [self.sections objectForKey:eventTime]; return rowIndecesInSection.count;
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    [self.sections removeAllObjects];
    [self.sectionToDateMap removeAllObjects];
    
    NSInteger section = 0;
    NSInteger rowIndex = 0;
    
    for (PFObject *object in self.objects) {
        NSString *date = [object objectForKey:@"datestring"];
        NSMutableArray *objectsInSection = [self.sections objectForKey:date];
        if (!objectsInSection) {
            objectsInSection = [NSMutableArray array];
            
            [self.sectionToDateMap setObject:date forKey:[NSNumber numberWithInt:section++]];
        }
        
        [objectsInSection addObject:[NSNumber numberWithInt:rowIndex++]];
        [self.sections setObject:objectsInSection forKey:date];
    }
}

- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {NSString *eventTime = [self timeForSection:indexPath.section];
    
    NSArray *rowIndecesInSection = [self.sections objectForKey:eventTime];
    
    NSNumber *rowIndex = [rowIndecesInSection objectAtIndex:indexPath.row];
    return [self.objects objectAtIndex:[rowIndex intValue]];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // define section header properties
    UILabel *sectionHeader = [[UILabel alloc] initWithFrame:CGRectNull];
    sectionHeader.backgroundColor = [UIColor groupTableViewBackgroundColor];
    sectionHeader.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    //sectionHeader.textColor = [UIColor whiteColor];
    sectionHeader.text = [self timeForSection:section];
    return sectionHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:  (NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"EventDateCell";
    
    PFTableViewCell *cell = (PFTableViewCell *)[tableView   dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle    reuseIdentifier:CellIdentifier];
    }
    
    if (tableView != self.searchDisplayController.searchResultsTableView) {
    cell.textLabel.text = [object objectForKey:@"name"];
    cell.detailTextLabel.text = [object objectForKey:@"location"];

    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    
    // define header height
    return 15;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([[segue identifier] isEqualToString:@"ShowEventDateDetails"])
    {
        NSIndexPath *selectedRowIndexPath = [self.tableView indexPathForSelectedRow];
        UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:selectedRowIndexPath];
        
        EventDetailViewController *detailViewController =[segue destinationViewController];
       
        // query the parse database to retrieve additional information
        PFQuery *query = [PFQuery queryWithClassName:@"Events"];
        
        // query based on selected cell name
        [query whereKey:@"name" equalTo:selectedCell.textLabel.text];
        NSError *error=nil;
        NSArray *objects=[query findObjects:&error];
        
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            
            for (PFObject *object in objects) {
                
                // get image associated with event
                PFFile *userImageFile = object[@"image"];
                NSData *imageData = [userImageFile getData];
                self.tempimage2 = [UIImage imageWithData:imageData];
                
                // get date, time and event id associated with event
                self.eventdate2 = [object objectForKey:@"datestring"];
                self.eventtime2 = [object objectForKey:@"time"];
                self.eventid2 = [object objectId];
                
                
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }

        // pass the retrieved information onto the detailViewController
        detailViewController.EventDetailModel = @[selectedCell.textLabel.text, selectedCell.detailTextLabel.text, self.eventdate2, self.eventtime2, self.eventid2];
        detailViewController.eventimage = self.tempimage2;
        
    }
}




//old code
#pragma mark - View lifecycle
/*
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
    self.tableView.tableHeaderView = self.searchBar;
    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.delegate = self;
    
    
    CGPoint offset = CGPointMake(0, self.searchBar.frame.size.height);
    self.tableView.contentOffset = offset;
    
    self.searchResults = [NSMutableArray array];
    
    //Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
*/
#pragma mark - Parse




// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
 static NSString *CellIdentifier = @"EventCell";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
 }
 
 // Configure the cell
 cell.textLabel.text = [object objectForKey:@"name"];
 cell.detailTextLabel.text = [NSString stringWithFormat:@"Location: %@", [object objectForKey:@"location"]];
 PFFile *userImageFile = object[@"image"];
 [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
 UIImage *image = [UIImage imageWithData:imageData];
 cell.imageView.image = image;
 cell.imageView.frame = CGRectMake(0,0,0,0);
 cell.imageView.hidden = YES;
 
 }];
 
 return cell;
 }
 */
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"EventDateCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    if (tableView != self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [object objectForKey:@"name"];
        cell.detailTextLabel.text = [object objectForKey:@"location"];
        
        PFFile *userImageFile = object[@"image"];
        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            UIImage *image = [UIImage imageWithData:imageData];
            cell.imageView.image = image;
            cell.imageView.frame = CGRectMake(20,20,20,20);
            cell.imageView.hidden = NO;
            
        }];
    }
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        
        PFUser *obj2 = [self.searchResults objectAtIndex:indexPath.row];
        cell.textLabel.text = [obj2 objectForKey:@"name"];
        cell.detailTextLabel.text = [object objectForKey:@"location"];
        
    }
    return cell;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowEventDateDetails"])
    {
        NSIndexPath *selectedRowIndexPath = [self.tableView indexPathForSelectedRow];
        UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:selectedRowIndexPath];
        
        EventDetailViewController *detailViewController =[segue destinationViewController];
        
        detailViewController.EventDetailModel = @[selectedCell.textLabel.text, selectedCell.detailTextLabel.text, @"time", selectedCell.imageView.image];
        
 
         PFQuery *query = [PFQuery queryWithClassName:@"Events"];
         [query whereKey:@"name" equalTo:selectedCell.textLabel.text];
         [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
         
         if (!error) {
         // The find succeeded.
         NSLog(@"Successfully retrieved %d scores.", objects.count);
         
         // Do something with the found objects
         for (PFObject *object in objects) {
         
         PFFile *userImageFile = object[@"image"];
         [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
         if (!error) {
         UIImage *image = [UIImage imageWithData:imageData];
         [image setAccessibilityIdentifier:@"image.jpg"] ;
         tempimage = image;
         
         //self.tableView.backgroundView = [[UIImageView alloc] initWithImage:image];
         NSLog(@"%@", image.accessibilityIdentifier);
         }
         }];
         
         
         }
         
         
         } else {
         // Log details of the failure
         NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
         }];
         
 
        if ([self.searchDisplayController isActive]) {
            NSLog(@"searched");
            //selectedRowIndexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            //selectedCell = [self.searchDisplayController.searchResultsTableView cellForRowAtIndexPath:selectedRowIndexPath];
            //detailViewController.EventDetailModel = @[selectedCell.textLabel.text, selectedCell.detailTextLabel.text, selectedCell.imageView.image];
        }
        
        //[searchResults objectAtIndex:myIndexPath.row];
        
    }
    
}


-(void)filterResults:(NSString *)searchTerm {
    
    [self.searchResults removeAllObjects];
    
    PFQuery *query = [PFQuery queryWithClassName: self.parseClassName];
    //[query whereKeyExists:@"name"];  //this is based on whatever query you are trying to accomplish
    [query whereKey:@"namelower" containsString:searchTerm];
    
    NSArray *results  = [query findObjects];
    
    //NSLog(@"%@", results);
    //NSLog(@"%u", results.count);
    
    [self.searchResults addObjectsFromArray:results];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterResults:searchString];
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.tableView) {
        //if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        return self.objects.count;
        
    } else {
        
        return self.searchResults.count;
        
    }
    
}



 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [objects objectAtIndex:indexPath.row];
 }
 */

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */

#pragma mark - Table view data source

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

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

#pragma mark - Table view delegate
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSLog(@"Search1");
        [self performSegueWithIdentifier: @"ShowEventDateDetails" sender: self];
        NSLog(@"Search2");
    }
    
    
    // load next view and set title:
    
}
*/

@end


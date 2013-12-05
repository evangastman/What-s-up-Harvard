//
//  MyTableController.m
//  What's Up Harvard
//
//  Created by Alex Yang on 2013-11-14.
//  Copyright (c) 2013 Alex Yang. All rights reserved.
//  Based off of ParseStarterProject created by James Yu on 12/29/11.
//

#import "MyTableController.h"
#import "EventCell.h"
#import "EventDetailViewController.h"
#import "EventDetailModel.h"
#import <QuartzCore/QuartzCore.h>
#import "MyLogInViewController.h"
#import "MySignUpViewController.h"


@interface MyTableController() <UISearchDisplayDelegate, UISearchBarDelegate> {
    
}
// create search bar
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;

// objects to handle search method
@property (nonatomic, strong) NSMutableArray *searchResults;

// additional objects to be passed on to event detail view controller
@property (strong, nonatomic) UIImage *tempimage;
@property (strong, nonatomic) NSString *eventtime;
@property (strong, nonatomic) NSString *eventdate;
@property (strong, nonatomic) NSString *eventid;

@end


@interface MyTableController ()

@end

@implementation MyTableController

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    
    if (self) {

        // Initialize the table
        // The className to query on
        self.parseClassName = @"Events";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"name";
        
        // The title for this table in the Navigation Controller.
        self.title = @"Trending";
        
        // Enable pull-to-refresh
        self.pullToRefreshEnabled = YES;
        
        // Enable built-in pagination
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 7;
    }
    return self;
}

#pragma mark - View lifecycle

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
    
    //Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        NSLog(@"not logged in");
        
        MyLogInViewController *logInViewController = [[MyLogInViewController alloc] init];
        logInViewController.delegate = self;
        
        // Create the sign up view controller
         MySignUpViewController *signUpViewController = [[MySignUpViewController alloc] init];
         signUpViewController.delegate = self;
        
        // Assign the sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
}

- (IBAction)logOutButtonTapAction:(id)sender {
    [PFUser logOut];
    [self viewDidAppear:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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

}

#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}


 // Override to customize what kind of query to perform on the class. The default is to query for
 // all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
 
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    // query for all events and sort by ascending priority
    [query orderByDescending:@"priority"];
 
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"EventCell";

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    // set the labels of the cell equal to the event name and location
    if (tableView != self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [object objectForKey:@"name"];
        cell.detailTextLabel.text = [object objectForKey:@"location"];
         }
    
    // if search results are present, set lables of the cell equal to the event names and locations retrieved from the search
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        
        PFUser *obj2 = [self.searchResults objectAtIndex:indexPath.row];
        cell.textLabel.text = [obj2 objectForKey:@"name"];
        cell.detailTextLabel.text = [object objectForKey:@"location"];

    }
    return cell;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowEventDetails"])
    {
        NSIndexPath *selectedRowIndexPath = [self.tableView indexPathForSelectedRow];
        UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:selectedRowIndexPath];

        EventDetailViewController *detailViewController =[segue destinationViewController];
        
        if (self.searchDisplayController.active) {
            NSLog(@"searched");
            selectedRowIndexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            selectedCell = [self.searchDisplayController.searchResultsTableView cellForRowAtIndexPath:selectedRowIndexPath];
            detailViewController.EventDetailModel = @[selectedCell.textLabel.text, selectedCell.detailTextLabel.text, @"date", @"time", @"id"];
            detailViewController.eventimage = self.tempimage;
            
        }
        
        else {
        // query the parse database to retrieve additional information

        PFQuery *query = [PFQuery queryWithClassName:@"Events"];
            
        // query based on selected cell name
        [query whereKey:@"name" equalTo:selectedCell.textLabel.text];
        NSError *error= nil;
        NSArray *objects=[query findObjects:&error];
            
            if (!error) {
                // The find succeeded.
                NSLog(@"Successfully retrieved %d scores.", objects.count);
                
                for (PFObject *object in objects) {
                
                    // get image associated with event
                    PFFile *userImageFile = object[@"image"];
                    NSData *imageData = [userImageFile getData];
                    self.tempimage = [UIImage imageWithData:imageData];
                    
                    // get date, time and event id associated with event
                    self.eventdate = [object objectForKey:@"datestring"];
                    self.eventtime = [object objectForKey:@"time"];
                    self.eventid = [object objectId];
                    
                }

            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        
        // pass the retrieved information onto the detailViewController
        detailViewController.EventDetailModel = @[selectedCell.textLabel.text, selectedCell.detailTextLabel.text, self.eventdate, self.eventtime, self.eventid];
        detailViewController.eventimage = self.tempimage;
        
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
/*
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            NSLog(@"Search1");
            [self performSegueWithIdentifier: @"ShowEventDetails" sender: self];
            NSLog(@"Search2");
        }
    
    
    // load next view and set title:

}

#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length && password.length) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"User dismissed the logInViewController");
}


#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || !field.length) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}


#pragma mark - ()

@end

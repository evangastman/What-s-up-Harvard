//
//  CarTableViewController.m
//  TableViewStory
//
//  Created by Alex Yang on 2013-10-27.
//  Copyright (c) 2013 Alex Yang. All rights reserved.
//

#import "CarTableViewController.h"
#import "CarTableViewCell.h"
#import "EventDetailViewController.h"

@interface CarTableViewController ()

@end

@implementation CarTableViewController{
    NSArray *searchResults;
}

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
    
    _Images = @[@"obama.jpg",
                   @"formal.jpg",
                   @"crimson.jpg",
                   @"oprah.jpg",
                   @"movie.jpg",
                   @"entrepreneurship.jpg",
                   @"bloomberg.jpg"];
    
    _Events = @[@"IOP - Barack Obama",
                  @"Freshman Formal",
                  @"Crimson Football vs Yale",
                  @"Oprah Winfrey",
                  @"Movie Night",
                  @"Entrepreneurship Forum",
                  @"FDO: Lunch with Mayor Michael Bloomberg"];
    
    _Descriptions = @[@"JFK Jr. Forum - Nov. 2nd, 6pm",
                   @"Annenberg - Nov. 5th, 7pm",
                   @"Stadium - Nov. 9th, 1pm",
                   @"Sanders Theater - Nov. 11th, 3pm",
                   @"Science Center D - Nov. 11th, 9pm",
                   @"Boylston Hall - Nov. 20th, 4pm",
                   @"Strauss Common Room - Nov. 21st, 12pm"];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowEventDetails"])
    {
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        
        EventDetailViewController *detailViewController =[segue destinationViewController];
        long row = [myIndexPath row];
        
        detailViewController.EventDetailModel = @[_Events[row],_Descriptions[row], _Images[row]];
        
        if ([self.searchDisplayController isActive]) {
            myIndexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            detailViewController.EventDetailModel = @[searchResults[row],searchResults[row], _Images[row]];

            
            //[searchResults objectAtIndex:myIndexPath.row];
            
        }
    }
    
}

// search for text
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    
    searchResults = [_Events filteredArrayUsingPredicate:resultPredicate];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return searchResults.count;
        
    } else {
        return _Events.count;
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventCell";
    UITableViewCell *cell = [tableView
                              dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [_Descriptions objectAtIndex:indexPath.row];

    } else {
        cell.textLabel.text = [_Events objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [_Descriptions objectAtIndex:indexPath.row];
    }

    return cell;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        [self performSegueWithIdentifier: @"ShowEventDetails" sender: self];
    }
}
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end

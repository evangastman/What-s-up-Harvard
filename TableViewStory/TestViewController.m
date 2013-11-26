#import "TestViewController.h"
#import "EventDateCell.h"
#import "EventDetailViewController.h"
#import "EventDetailModel.h"

@interface TestViewController ()
@property (nonatomic, retain) NSMutableDictionary *sections;
@property (nonatomic, retain) NSMutableDictionary *sectionToDateMap;
@end

@implementation TestViewController
@synthesize sections = _sections;
@synthesize sectionToDateMap = _sectionToDateMap;


- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super initWithClassName:@"Events"];
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        self.parseClassName = @"Events";
        
        self.textKey = @"name";
        
        self.pullToRefreshEnabled = YES;
        
        
        self.paginationEnabled = YES;
        
        
        self.sections = [NSMutableDictionary dictionary];
        self.sectionToDateMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
 [super viewWillAppear:animated];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.sections.allKeys.count;
}

- (NSString *)timeForSection:(NSInteger)section {
    return [self.sectionToDateMap objectForKey:[NSNumber numberWithInt:section]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    NSString *athleteType = [self timeForSection:section];
    NSArray *rowIndecesInSection = [self.sections objectForKey:athleteType]; return rowIndecesInSection.count;
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

- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {NSString *athleteType = [self timeForSection:indexPath.section];
    
    NSArray *rowIndecesInSection = [self.sections objectForKey:athleteType];
    
    NSNumber *rowIndex = [rowIndecesInSection objectAtIndex:indexPath.row];
    return [self.objects objectAtIndex:[rowIndex intValue]];
}

- (PFQuery *)queryForTable {
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *sectionHeader = [[UILabel alloc] initWithFrame:CGRectNull];
    sectionHeader.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //sectionHeader.font = [UIFont boldSystemFontOfSize:26];
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
    
    cell.textLabel.text = [object objectForKey:@"name"];
    cell.detailTextLabel.text = [object objectForKey:@"location"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([[segue identifier] isEqualToString:@"ShowEventDetail"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self objectAtIndexPath:indexPath];
        PFFile *file = [object objectForKey:@"image"];
        [[segue destinationViewController] setFile:file];
        
    }
}

@end
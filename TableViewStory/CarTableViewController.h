//
//  CarTableViewController.h
//  TableViewStory
//
//  Created by Alex Yang on 2013-10-27.
//  Copyright (c) 2013 Alex Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CarTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *Images;
@property (nonatomic, strong) NSArray *Events;
@property (nonatomic, strong) NSArray *Descriptions;

@end

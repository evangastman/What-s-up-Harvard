//
//  EventDetailViewController.m
//  TableViewStory
//
//  Created by Alex Yang on 2013-10-27.
//  Copyright (c) 2013 Alex Yang. All rights reserved.
//

#import "EventDetailViewController.h"
#import <Parse/Parse.h>

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    _eventLabel.text = _EventDetailModel[0];
    _descriptionLabel.text = _EventDetailModel[1];
    [self.imageView setImage:_EventDetailModel[2]];
    
    //[UIImage imageNamed:@"obama.jpg"];
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:nil];
    
    NSArray *actionButtonItems = @[shareItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

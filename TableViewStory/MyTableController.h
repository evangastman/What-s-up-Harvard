//
//  MyTableController.h
//  What's Up Harvard
//
//  Created by Alex Yang on 2013-11-14.
//  Copyright (c) 2013 Alex Yang. All rights reserved.
//  Based off of ParseStarterProject created by James Yu on 12/29/11.
//

#import <Parse/Parse.h>
#import <UIKit/UIKit.h>

@interface MyTableController : PFQueryTableViewController <UITableViewDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
- (IBAction)logOutButtonTapAction:(id)sender;
@end

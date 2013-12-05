//
//  EventCell.h
//  What's Up Harvard
//
//  Created by Alex Yang on 2013-11-14.
//  Copyright (c) 2013 Alex Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCell: UITableViewCell
// create two labels for information to be viewed in table cell
@property (strong, nonatomic) IBOutlet UILabel *eventLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

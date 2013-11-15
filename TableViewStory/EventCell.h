//
//  EventCell.h
//  TableViewStory
//
//  Created by Alex Yang on 2013-11-14.
//  Copyright (c) 2013 Alex Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCell: UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *eventLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

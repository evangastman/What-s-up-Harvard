//
//  EventDetailViewController.h
//  What's Up Harvard
//
//  Created by Alex Yang on 2013-10-27.
//  Copyright (c) 2013 Alex Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailViewController : UIViewController

// model to hold event detail information
@property (strong, nonatomic) NSArray *EventDetailModel;

// objects to be displayed on detail page
@property (strong, nonatomic) UIImage *Eventimage;
@property (strong, nonatomic) IBOutlet UILabel *eventLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UISwitch *priority;
@end

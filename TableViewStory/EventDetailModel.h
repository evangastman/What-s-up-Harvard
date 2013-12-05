//
//  EventDetailModel.h
//  What's Up Harvard
//
//  Created by Alex Yang on 2013-11-18.
//  Copyright (c) 2013 Alex Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventDetailModel : NSObject

@property (nonatomic, readwrite, copy) NSString *event;
@property (nonatomic, readwrite, copy) NSString *description;
@property (nonatomic, readwrite, strong) UIImage *image;

@end

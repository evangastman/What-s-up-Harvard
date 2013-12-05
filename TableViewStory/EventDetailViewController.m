//
//  EventDetailViewController.m
//  What's Up Harvard
//
//  Created by Alex Yang on 2013-10-27.
//  Copyright (c) 2013 Alex Yang. All rights reserved.
//

#import "EventDetailViewController.h"
#import <Parse/Parse.h>
#import <MessageUI/MessageUI.h>

@interface EventDetailViewController () <MFMessageComposeViewControllerDelegate>
{
    IBOutlet UISwitch *priority;
}
- (IBAction)switchValueChanged:(id)sender;

@end

@implementation EventDetailViewController
@synthesize priority;

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
    
    // assign elements in EventDetailModel to labels and UIImage
    _eventLabel.text = _EventDetailModel[0];
    _descriptionLabel.text = _EventDetailModel[1];
    _timeLabel.text = [NSString stringWithFormat:@"%@%@%@",_EventDetailModel[2], @", " ,_EventDetailModel[3]];
    [self.imageView setImage:_Eventimage];
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButtonTapped)];
    
    NSArray *actionButtonItems = @[shareButton];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
}

- (IBAction)switchValueChanged:(id)sender {
    
        // update the priority of an event if the switch button is pressed
        PFQuery *query = [PFQuery queryWithClassName:@"Events"];
        
        // Retrieve the event by id
        [query getObjectInBackgroundWithId:_EventDetailModel[4] block:^(PFObject *event, NSError *error) {
            
            if (priority.on)
            {
                // increase the priority by 1
                [event incrementKey:@"priority"byAmount: @1];
                NSLog(@"on");
            }
            else
            {
                // decrease the priority by 1
                [event incrementKey:@"priority"byAmount: @-1];
                NSLog(@"off");
            }
            
            // update the database
            [event saveInBackground];
            
        }];

}
-(void)shareButtonTapped

{
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    //NSArray *recipents = @[@"12345678", @"72345524"];
    NSString *message = [NSString stringWithFormat:@"Check out %@ on %@ at %@!", _eventLabel.text, _EventDetailModel[2], _EventDetailModel[3]];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:nil];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

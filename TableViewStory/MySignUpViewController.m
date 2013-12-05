//
//  MySignUpViewController.m
//  What's Up Harvard
//
//  Created by Alex Yang on 2013-10-27.
//  Based off of LogInAndSignUpDemo by Mattieu Gamache-Asselin on 6/15/12.
//
//

#import "MySignUpViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MySignUpViewController ()
@property (nonatomic, strong) UIImageView *fieldsBackground;
@end

@implementation MySignUpViewController

@synthesize fieldsBackground;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"whatsuplogo.png"]]];
    [self.signUpView setBackgroundColor:[UIColor whiteColor]];
    
    // Remove text shadow
    CALayer *signuplayer = self.signUpView.usernameField.layer;
    signuplayer.shadowOpacity = 0.0f;
    signuplayer = self.signUpView.passwordField.layer;
    signuplayer.shadowOpacity = 0.0f;
    signuplayer = self.signUpView.emailField.layer;
    signuplayer.shadowOpacity = 0.0f;
    self.signUpView.signUpButton.titleLabel.shadowOffset = CGSizeMake(0.0f,0.0f);
    
    
    // Set field text color
    [self.signUpView.usernameField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.passwordField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.emailField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    
    // Set button images and names
    [self.signUpView.signUpButton setBackgroundImage:[UIImage imageNamed:@"SignUp.png"] forState:UIControlStateNormal];
    [self.signUpView.signUpButton setBackgroundImage:[UIImage imageNamed:@"SignUpDown.png"] forState:UIControlStateHighlighted];
    [self.signUpView.signUpButton setTitle:@"Sign up" forState:UIControlStateNormal];
    [self.signUpView.signUpButton setTitle:@"Sign up" forState:UIControlStateHighlighted];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Move all fields down on smaller screen sizes
    float yOffset = [UIScreen mainScreen].bounds.size.height <= 480.0f ? 30.0f : 0.0f;

    CGRect fieldFrame = self.signUpView.usernameField.frame;

    [self.signUpView.dismissButton setFrame:CGRectMake(5.0f, 20.0f, 40.0f, 40.0f)];
    [self.signUpView.logo setFrame:CGRectMake(20.0f, 35.0f, 288.0f, 144.0f)];
    [self.signUpView.signUpButton setFrame:CGRectMake(35.0f, 385.0f, 250.0f, 40.0f)];
    [self.fieldsBackground setFrame:CGRectMake(35.0f, fieldFrame.origin.y + yOffset, 250.0f, 174.0f)];
    
    [self.signUpView.usernameField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                       fieldFrame.origin.y + yOffset,
                                                       fieldFrame.size.width - 10.0f,
                                                       fieldFrame.size.height)];
    yOffset += fieldFrame.size.height;
    
    [self.signUpView.passwordField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                       fieldFrame.origin.y + yOffset,
                                                       fieldFrame.size.width - 10.0f,
                                                       fieldFrame.size.height)];
    yOffset += fieldFrame.size.height;
    
    [self.signUpView.emailField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                    fieldFrame.origin.y + yOffset,
                                                    fieldFrame.size.width - 10.0f,
                                                    fieldFrame.size.height)];
    yOffset += fieldFrame.size.height;
    
    [self.signUpView.additionalField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                         fieldFrame.origin.y + yOffset,
                                                         fieldFrame.size.width - 10.0f,
                                                         fieldFrame.size.height)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

//
//  MyLogInViewController.m
//  What's Up Harvard
//
//  Created by Alex Yang on 2013-10-27.
//  Based off of LogInAndSignUpDemo by Mattieu Gamache-Asselin on 6/15/12.
//
//

#import "MyLogInViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MyLogInViewController ()
@property (nonatomic, strong) UIImageView *fieldsBackground;
@end

@implementation MyLogInViewController

@synthesize fieldsBackground;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set logo picture
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"whatsuplogo.png"]]];
    [self.logInView setBackgroundColor:[UIColor whiteColor]];
    
    // Remove text shadow
    CALayer *layer = self.logInView.usernameField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.logInView.passwordField.layer;
    layer.shadowOpacity = 0.0f;
    self.logInView.logInButton.titleLabel.shadowOffset = CGSizeMake(0.0f,0.0f);
    self.logInView.signUpButton.titleLabel.shadowOffset = CGSizeMake(0.0f,0.0f);
    
    // Set field text color
    [self.logInView.usernameField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.logInView.passwordField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    
    // Set button images and names
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"SignUp.png"] forState:UIControlStateNormal];
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"SignUpDown.png"] forState:UIControlStateHighlighted];
    [self.logInView.signUpButton setTitle:@"Sign up for what's up!" forState:UIControlStateNormal];
    [self.logInView.signUpButton setTitle:@"Sign up for what's up!" forState:UIControlStateHighlighted];
    self.logInView.signUpLabel.text = nil;

    
    [self.logInView.logInButton setBackgroundImage:[UIImage imageNamed:@"Login.png"] forState:UIControlStateNormal];
    [self.logInView.logInButton setBackgroundImage:[UIImage imageNamed:@"LoginDown.png"] forState:UIControlStateHighlighted];
    
    [self.logInView.passwordForgottenButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.logInView.passwordForgottenButton setBackgroundImage:nil forState:UIControlStateHighlighted];

    [self.logInView.passwordForgottenButton setTitle:@"Forgot?" forState:UIControlStateNormal];
    [self.logInView.passwordForgottenButton setTitle:@"Forgot?" forState:UIControlStateHighlighted];
    [self.logInView.passwordForgottenButton setTitleColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    self.logInView.passwordForgottenButton.font = [UIFont systemFontOfSize:10.0f];
    
    [self.logInView.dismissButton setImage:nil forState:UIControlStateNormal];
    [self.logInView.dismissButton setImage:nil forState:UIControlStateHighlighted];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Set frame for elements
    [self.logInView.dismissButton setFrame:CGRectMake(5.0f, 20.0f, 40.0f, 40.0f)];
    [self.logInView.logo setFrame:CGRectMake(20.0f, 35.0f, 288.0f, 144.0f)];
    [self.logInView.signUpButton setFrame:CGRectMake(35.0f, 385.0f, 250.0f, 40.0f)];
    [self.logInView.logInButton setFrame:CGRectMake(35.0f, 310.0f, 250.0f, 40.0f)];
    [self.logInView.usernameField setFrame:CGRectMake(35.0f, 175.0f, 250.0f, 50.0f)];
    [self.logInView.passwordField setFrame:CGRectMake(35.0f, 225.0f, 250.0f, 50.0f)];
    [self.logInView.passwordForgottenButton setFrame:CGRectMake(35.0f, 260.0f, 250.0f, 50.0f)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

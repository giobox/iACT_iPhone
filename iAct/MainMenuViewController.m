//
//  MainMenuViewController.m
//  iAct
//
//  Created by Giovanni Paolo Coia on 02/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController
@synthesize recordThoughtButton;
@synthesize thoughtHistoryButton;
@synthesize actInformationButton;
@synthesize aboutIACTButton;
@synthesize welcomeLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //set wallpaper
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"black-material.jpg"]];
    //print users name at top
    self.welcomeLabel.text = [NSString stringWithFormat:@"Hi, %@", [userDefaults objectForKey:@"name"]];    
    [self customButtons];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setWelcomeLabel:nil];
    [self setRecordThoughtButton:nil];
    [self setThoughtHistoryButton:nil];
    [self setActInformationButton:nil];
    [self setAboutIACTButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/**
 Logout method. when logout button pressed user is logged out of application, their username and password removed from NSUserDefaults
 property list. Logged in status BOOL set to NO and segue to login screen performed.
 */
- (IBAction)logOut:(id)sender {
    AppDelegate *sharedData = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //set all of the login details to null/no etc
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:@"loginStatus"];
    [userDefaults setObject:@"" forKey:@"username"];
    [userDefaults setObject:@"" forKey:@"password"];
    [self dismissModalViewControllerAnimated:YES];
    
    //clear the logged in user from memory
    sharedData.loggedInUser = nil;
}

/**
 Applies custom formatting to UIButtons.
 */
- (void)customButtons {
    //load the images
    UIImage *blueButtonImage = [[UIImage imageNamed:@"blueButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *blueButtonImageHighlight = [[UIImage imageNamed:@"blueButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    UIImage *blackButtonImage = [[UIImage imageNamed:@"blackButton.png"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *blackButtonImageHighlight = [[UIImage imageNamed:@"blackButtonHighlight.png"]
                                         resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    UIImage *tanButtonImage = [[UIImage imageNamed:@"tanButton.png"]
                                 resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *tanButtonImageHighlight = [[UIImage imageNamed:@"tanButtonHighlight.png"]
                                          resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    UIImage *greenButtonImage = [[UIImage imageNamed:@"greenButton.png"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *greenButtonImageHighlight = [[UIImage imageNamed:@"greenButtonHighlight.png"]
                                         resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    // Set the background for the buttons
    
    [thoughtHistoryButton setBackgroundImage:greenButtonImage forState:UIControlStateNormal];
    [thoughtHistoryButton setBackgroundImage:greenButtonImageHighlight forState:UIControlStateHighlighted];
    
    [recordThoughtButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
    [recordThoughtButton setBackgroundImage:blueButtonImageHighlight forState:UIControlStateHighlighted];
        
    [actInformationButton setBackgroundImage:tanButtonImage forState:UIControlStateNormal];
    [actInformationButton setBackgroundImage:tanButtonImageHighlight forState:UIControlStateHighlighted];
    
    [aboutIACTButton setBackgroundImage:blackButtonImage forState:UIControlStateNormal];
    [aboutIACTButton setBackgroundImage:blackButtonImageHighlight forState:UIControlStateHighlighted];
}

@end



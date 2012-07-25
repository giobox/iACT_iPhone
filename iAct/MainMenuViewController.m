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
@synthesize thoughtMapButton;
@synthesize actInformationButton;
@synthesize aboutIACTButton;
@synthesize welcomeLabel;

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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //set wallpaper
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"black-material.jpg"]];
    //print users name at top
    self.welcomeLabel.text = [NSString stringWithFormat:@"Hi, %@", [userDefaults objectForKey:@"name"]];
    
    //Custom buttons
    [self customButtons];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setWelcomeLabel:nil];
    [self setRecordThoughtButton:nil];
    [self setThoughtHistoryButton:nil];
    [self setThoughtMapButton:nil];
    [self setActInformationButton:nil];
    [self setAboutIACTButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)logOut:(id)sender {
    //save the user's model
    AppDelegate *sharedData = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [sharedData saveModelToDisk];
    
    //set all of the login details to null/no etc
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:@"loginStatus"];
    [userDefaults setObject:@"" forKey:@"username"];
    [userDefaults setObject:@"" forKey:@"password"];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)customButtons {
    //load the images
    UIImage *blueButtonImage = [[UIImage imageNamed:@"blueButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *blueButtonImageHighlight = [[UIImage imageNamed:@"blueButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    UIImage *whiteButtonImage = [[UIImage imageNamed:@"whiteButton.png"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *whiteButtonImageHighlight = [[UIImage imageNamed:@"whiteButtonHighlight.png"]
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
    
    [thoughtMapButton setBackgroundImage:whiteButtonImage forState:UIControlStateNormal];
    [thoughtMapButton setBackgroundImage:whiteButtonImageHighlight forState:UIControlStateHighlighted];
    
    [actInformationButton setBackgroundImage:whiteButtonImage forState:UIControlStateNormal];
    [actInformationButton setBackgroundImage:whiteButtonImageHighlight forState:UIControlStateHighlighted];
    
    [aboutIACTButton setBackgroundImage:whiteButtonImage forState:UIControlStateNormal];
    [aboutIACTButton setBackgroundImage:whiteButtonImageHighlight forState:UIControlStateHighlighted];
}

@end



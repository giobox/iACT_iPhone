//
//  AboutACTViewController.m
//  iAct
//
//  Created by Giovanni Paolo Coia on 02/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AboutACTViewController.h"

@interface AboutACTViewController ()

@end

@implementation AboutACTViewController
@synthesize resetIACTButton;
@synthesize sendFeedbackButton;

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
    //set wallpaper
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"paper.jpg"]];
    [self customButtons];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setResetIACTButton:nil];
    [self setSendFeedbackButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)sendFeedback:(id)sender {
    //create an email modal display
    MFMailComposeViewController *mailComposer;
    NSArray *emailAddresses;
    emailAddresses=[[NSArray alloc]initWithObjects:@"1105874C@student.gla.ac.uk", nil];
    
    mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setToRecipients:emailAddresses];
    [mailComposer setSubject:@"iACT Feedback"];
    [self presentModalViewController:mailComposer animated:YES];
}

//method clears model and deletes saved data
- (IBAction)resetIACT:(id)sender {
    //display action sheet to confirm user really wants to do this
    UIActionSheet *actionSheet;
    actionSheet=[[UIActionSheet alloc] initWithTitle:@"Are you sure you want to reset iACT and delete all of your data?"
                                            delegate:self
                                   cancelButtonTitle:@"Cancel"
                              destructiveButtonTitle:@"Reset iACT"
                                   otherButtonTitles:nil];
    actionSheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [actionSheet showFromRect:[(UIButton *)sender frame]
                       inView:self.view animated:YES];
}

//protocol method for dismissing the email composer window
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark actionsheet UI delegate method

- (void)actionSheet:(UIActionSheet *)actionSheet

//if user clicks reset, delete data
clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString *buttonTitle=[actionSheet buttonTitleAtIndex:buttonIndex];
	if ([buttonTitle isEqualToString:@"Reset iACT"]) {
       // NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //AppDelegate *sharedData = (AppDelegate *)[[UIApplication sharedApplication] delegate];
       // NSManagedObjectContext  *managedObjectContext = sharedData.managedObjectContext;
        //}
}
}
    
- (void)customButtons {
    //load the images
    
    UIImage *whiteButtonImage = [[UIImage imageNamed:@"whiteButton.png"]
                                 resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *whiteButtonImageHighlight = [[UIImage imageNamed:@"whiteButtonHighlight.png"]
                                          resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    UIImage *redButtonImage = [[UIImage imageNamed:@"orangeButton.png"]
                               resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *redButtonImageHighlight = [[UIImage imageNamed:@"orangeButtonHighlight.png"]
                                        resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    // Set the background for the buttons
    
    [sendFeedbackButton setBackgroundImage:whiteButtonImage forState:UIControlStateNormal];
    [sendFeedbackButton setBackgroundImage:whiteButtonImageHighlight forState:UIControlStateHighlighted];
    
    [resetIACTButton setBackgroundImage:redButtonImage forState:UIControlStateNormal];
    [resetIACTButton setBackgroundImage:redButtonImageHighlight forState:UIControlStateHighlighted];
}



@end

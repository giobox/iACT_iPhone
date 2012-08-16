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
    [self customButtons];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setSendFeedbackButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/**
 This method launches a pre-populated email sending view. Allows the user to easily email feedback on the application
 */
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

//protocol method for dismissing the email composer window
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissModalViewControllerAnimated:YES];
}

/**
 Applies custom formatting to UIButtons
 */
- (void)customButtons {
    UIImage *whiteButtonImage = [[UIImage imageNamed:@"whiteButton.png"]
                                 resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *whiteButtonImageHighlight = [[UIImage imageNamed:@"whiteButtonHighlight.png"]
                                          resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
        
    [sendFeedbackButton setBackgroundImage:whiteButtonImage forState:UIControlStateNormal];
    [sendFeedbackButton setBackgroundImage:whiteButtonImageHighlight forState:UIControlStateHighlighted];
    
}

@end

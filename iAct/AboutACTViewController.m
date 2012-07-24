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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
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
		AppDelegate *sharedData = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [sharedData resetIACT];
	}
}

@end

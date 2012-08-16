//
//  AboutACTViewController.h
//  iAct
//
//  Created by Giovanni Paolo Coia on 02/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//import for email sending functions
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import "User.h"

/**
 Class to display the about iACT view. Also has a button to send feedback using the MessageUI library.
 */
@interface AboutACTViewController : UIViewController <MFMailComposeViewControllerDelegate>

- (IBAction)sendFeedback:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *sendFeedbackButton; /**< Send feedback button. */

@end

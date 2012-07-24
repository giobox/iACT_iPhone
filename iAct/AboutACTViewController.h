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

@interface AboutACTViewController : UIViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

- (IBAction)sendFeedback:(id)sender;

- (IBAction)resetIACT:(id)sender;

@end

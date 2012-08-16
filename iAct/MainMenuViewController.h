//
//  MainMenuViewController.h
//  iAct
//
//  Created by Giovanni Paolo Coia on 02/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

/**
Class to display the main menu of the application.
 */
@interface MainMenuViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *welcomeLabel; /**< Label to display welcome message with user's name. */
- (IBAction)logOut:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *recordThoughtButton; /**< Button for record thought function. */
@property (strong, nonatomic) IBOutlet UIButton *thoughtHistoryButton; /**< Button for record thought history function. */
@property (strong, nonatomic) IBOutlet UIButton *actInformationButton; /**< Button for ACT information function. */
@property (strong, nonatomic) IBOutlet UIButton *aboutIACTButton; /**< Button for about iACT function. */

@end

/**<  */
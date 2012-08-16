//
//  ViewController.h
//  iAct
//
//  Created by Giovanni Paolo Coia on 02/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <RestKit/RestKit.h>
#import "User.h"

/**
 Class to control login to application. Will create new data model if user logs in for the first time.
 Also checks if existing login session already created, if so automatically segues to main menu.
 */
@interface ViewController : UIViewController <RKRequestDelegate>

@property (strong, nonatomic) IBOutlet UITextField *emailAddressField; /**< Email address input field */
@property (strong, nonatomic) IBOutlet UITextField *passwordField; /**< Password input field */
@property (strong, nonatomic) IBOutlet UIButton *signInButton; /**< Sign in Button */

//Helper variables for CoreData implementation
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController; /**< CoreData search support */
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext; /**< CoreData Model */

- (IBAction)LoginButton:(id)sender;

- (IBAction)hideKeyboard:(id)sender;

@end

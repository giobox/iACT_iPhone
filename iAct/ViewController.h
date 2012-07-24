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

@interface ViewController : UIViewController <RKRequestDelegate>
@property (strong, nonatomic) IBOutlet UITextField *emailAddressField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)LoginButton:(id)sender;
- (void)userIsLoggedIn;
- (IBAction)hideKeyboard:(id)sender;

@end

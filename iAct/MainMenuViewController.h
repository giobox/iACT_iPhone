//
//  MainMenuViewController.h
//  iAct
//
//  Created by Giovanni Paolo Coia on 02/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MainMenuViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *welcomeLabel;
- (IBAction)logOut:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *recordThoughtButton;
@property (strong, nonatomic) IBOutlet UIButton *thoughtHistoryButton;
@property (strong, nonatomic) IBOutlet UIButton *thoughtMapButton;
@property (strong, nonatomic) IBOutlet UIButton *actInformationButton;
@property (strong, nonatomic) IBOutlet UIButton *aboutIACTButton;

@end

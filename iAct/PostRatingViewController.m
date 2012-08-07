//
//  PostRatingViewController.m
//  iAct
//
//  Created by Giovanni Paolo Coia on 05/08/2012.
//
//

#import "PostRatingViewController.h"


@interface PostRatingViewController ()

@property (strong, nonatomic) NSUserDefaults *userDefaults;
@property (strong, nonatomic) AppDelegate *sharedData;

@end

@implementation PostRatingViewController


@synthesize thought;
@synthesize occurance;
@synthesize newThought;
@synthesize secondRatingSlider;
@synthesize doneButton;
@synthesize managedObjectContext;
@synthesize sharedData;
@synthesize userDefaults;

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
    sharedData = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = sharedData.managedObjectContext;
    userDefaults = [NSUserDefaults standardUserDefaults];
    [self customButtons];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setOccurance:nil];
    [self setThought:nil];
    [self setSharedData:nil];
    [self setManagedObjectContext:nil];
    [self setUserDefaults:nil];
    [self setSecondRatingSlider:nil];
    [self setDoneButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)finishedRating:(id)sender {
    //add the second rating to the thought occurance object
    occurance.postRating = [NSNumber numberWithFloat:secondRatingSlider.value];
    
    if(newThought) {
        
        [self uploadThoughtWithThought:thought andOccurance:occurance];
    }
    //otherwise we are just recording an occurance
    else {
        [self uploadThoughtOccurance:occurance forThought:thought];
    }
    //save model return to root of the navigation menu
    [self.managedObjectContext save:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//Add a brand new thought to iACT server
-(void)uploadThoughtWithThought:(Thought *)uploadThought andOccurance:(ThoughtOccurance *)newOccurance {
    NSString *userID = [userDefaults objectForKey:@"ID"];
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:userID, @"id", uploadThought.content, @"content", newOccurance.initialRating, @"InitialRating", newOccurance.postRating, @"postRating",  nil];
    [[RKClient sharedClient] post:@"/iphonerecordthought" params:parameters delegate:nil];
}

//this method is used to add occurance to an existing thought
- (void)uploadThoughtOccurance:(ThoughtOccurance *)thoughtOccurance forThought:(Thought *)uploadThought {
    NSString *userID = [userDefaults objectForKey:@"ID"];
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:userID, @"id", uploadThought.content, @"content", thoughtOccurance.initialRating, @"InitialRating", thoughtOccurance.postRating, @"postRating",  nil];
    [[RKClient sharedClient] post:@"/iphonerecordoccurance" params:parameters delegate:nil];
}

- (void)customButtons {
    //load the images
    UIImage *blueButtonImage = [[UIImage imageNamed:@"blueButton.png"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *blueButtonImageHighlight = [[UIImage imageNamed:@"blueButtonHighlight.png"]
                                         resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    [doneButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
    [doneButton setBackgroundImage:blueButtonImageHighlight forState:UIControlStateHighlighted];
    
    
}


@end

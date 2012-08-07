//
//  ACTManipilationViewController.m
//  iAct
//
//  Created by Giovanni Paolo Coia on 05/08/2012.
//
//

#import "ACTManipilationViewController.h"

@implementation ACTManipilationViewController

@synthesize thought;
@synthesize occurance;
@synthesize newThought;
@synthesize movingButton;
@synthesize thoughtDescriptionLabel;
@synthesize lastRotation;
@synthesize lastScale;


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
    thoughtDescriptionLabel.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(labelDragged:)] ;
	[thoughtDescriptionLabel addGestureRecognizer:gesture];
    
    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
    [rotationRecognizer setDelegate:self];
    [self.view addGestureRecognizer:rotationRecognizer];
    
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
    [pinchRecognizer setDelegate:self];
    [self.view addGestureRecognizer:pinchRecognizer];
    
    
    //hide the back button
    self.navigationItem.hidesBackButton = TRUE;
    thoughtDescriptionLabel.text = thought.content;
    
    //set BG to a random colour
    UIColor *bgColor = [self randomColor];
    self.view.backgroundColor = bgColor;
    
    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setMovingButton:nil];
    [self setOccurance:nil];
    [self setThought:nil];
    [self setThoughtDescriptionLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[ segue identifier] isEqualToString:@"saveThought"]) {
        //pass the created thought and occurance to the next view
        PostRatingViewController *RatingViewController = [segue destinationViewController];
        RatingViewController.thought = self.thought;
        RatingViewController.occurance = self.occurance;
        RatingViewController.newThought = self.newThought;
    }
}

#pragma mark - animation actions

- (IBAction) btnMoveTo:(id)sender
{
    UIButton* button= (UIButton*)sender;
    [thoughtDescriptionLabel moveTo:
     CGPointMake(button.center.x - (thoughtDescriptionLabel.frame.size.width/2),
                 button.frame.origin.y - (thoughtDescriptionLabel.frame.size.height + 5.0))
                duration:1.0 option:0];	// above the tapped button
}

- (IBAction)moveToTap:(id)sender {
}

- (void)labelDragged:(UIPanGestureRecognizer *)gesture
{
	UILabel *label = (UILabel *)gesture.view;
	CGPoint translation = [gesture translationInView:label];
    
	// move label
	label.center = CGPointMake(label.center.x + translation.x,
                               label.center.y + translation.y);
    
	// reset translation
	[gesture setTranslation:CGPointZero inView:label];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    float scaleFactor = 1;
    float angle = 0;
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    CGAffineTransform scaleTrans =
    CGAffineTransformMakeScale(scaleFactor, scaleFactor);
    CGAffineTransform rotateTrans =
    CGAffineTransformMakeRotation(angle * M_PI / 180);
    thoughtDescriptionLabel.transform = CGAffineTransformConcat(scaleTrans, rotateTrans);
    angle = (angle == 180 ? 360 : 180);
    scaleFactor = (scaleFactor == 2 ? 1 : 2);
    thoughtDescriptionLabel.center = location;
    [UIView commitAnimations];

}

-(void)rotate:(id)sender {

    
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        lastRotation = 0.0;
        return;
    }
    
    CGFloat rotation = 0.0 - (lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
    
    CGAffineTransform currentTransform = thoughtDescriptionLabel.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [thoughtDescriptionLabel setTransform:newTransform];
    
    lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
    //[self showOverlayWithFrame:thoughtDescriptionLabel.frame];
}

-(void)scale:(id)sender {
    
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        lastScale = 1.0;
    }
    
    CGFloat scale = 1.0 - (lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    
    CGAffineTransform currentTransform = thoughtDescriptionLabel.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [thoughtDescriptionLabel setTransform:newTransform];
    
    lastScale = [(UIPinchGestureRecognizer*)sender scale];
}


//obtained from BOOKMARK
- (UIColor *) randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end

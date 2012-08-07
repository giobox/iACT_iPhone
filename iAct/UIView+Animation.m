//
//  UIView+Animation.m
//  iAct
//
//  Created by Giovanni Paolo Coia on 06/08/2012.
//
//

#import "UIView+Animation.h"

@implementation UIView (Animation)


- (void) moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option
{
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         self.frame = CGRectMake(destination.x,destination.y, self.frame.size.width, self.frame.size.height);
                     }
                     completion:nil];
}

@end

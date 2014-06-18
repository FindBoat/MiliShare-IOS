//
//  BounceAnimator.m
//  MiliShare
//
//  Created by Hang Zhao on 5/28/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "BounceAnimator.h"

@implementation BounceAnimator

static CGFloat const kChildViewPadding = 16;
static CGFloat const kDamping = 0.62f;
static CGFloat const kInitialSpringVelocity = 0.5f;

- (instancetype)initWithOperation:(UINavigationControllerOperation)operation {
    self = [super init];
    if (self) {
        _operation = operation;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 1;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    // When sliding the views horizontally, in and out, figure out whether we are going left or right.
    BOOL goingRight = (self.operation == UINavigationControllerOperationPop);
    
    CGFloat travelDistance = [transitionContext containerView].bounds.size.width + kChildViewPadding;
    CGAffineTransform travel = CGAffineTransformMakeTranslation (goingRight ? travelDistance : -travelDistance, 0);
    
    [[transitionContext containerView] addSubview:toViewController.view];
    toViewController.view.alpha = 0;
    toViewController.view.transform = CGAffineTransformInvert (travel);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:kDamping initialSpringVelocity:kInitialSpringVelocity options:0x00 animations:^{
        fromViewController.view.transform = travel;
        fromViewController.view.alpha = 0;
        toViewController.view.transform = CGAffineTransformIdentity;
        toViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        fromViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end

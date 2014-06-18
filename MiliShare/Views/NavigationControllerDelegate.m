//
//  NavigationControllerDelegate.m
//  MiliShare
//
//  Created by Hang Zhao on 5/28/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "NavigationControllerDelegate.h"
#import "BounceAnimator.h"

@implementation NavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPop ||
        operation == UINavigationControllerOperationPush) {
        return [[BounceAnimator alloc] initWithOperation:operation];
    }
    return nil;
}

@end

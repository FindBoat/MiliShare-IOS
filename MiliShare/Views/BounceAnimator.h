//
//  BounceAnimator.h
//  MiliShare
//
//  Created by Hang Zhao on 5/28/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BounceAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property(nonatomic) UINavigationControllerOperation operation;

- (instancetype)initWithOperation:(UINavigationControllerOperation)operation;

@end

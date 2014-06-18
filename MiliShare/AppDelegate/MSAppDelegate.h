//
//  MSAppDelegate.h
//  MiliShare
//
//  Created by Hang Zhao on 5/21/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NavigationControllerDelegate;

@interface MSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NavigationControllerDelegate *navigationControllerDelegate;

@end

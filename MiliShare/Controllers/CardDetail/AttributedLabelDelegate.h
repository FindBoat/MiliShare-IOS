//
//  AttributedLabelDelegate.h
//  MiliShare
//
//  Created by Hang Zhao on 6/4/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "TTTAttributedLabel.h"

@interface AttributedLabelDelegate : NSObject <TTTAttributedLabelDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) UIViewController *viewController;

- (instancetype)initWithViewController:(UIViewController *)viewController;

@end

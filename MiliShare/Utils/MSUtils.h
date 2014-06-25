//
//  MSUtils.h
//  MiliShare
//
//  Created by Hang Zhao on 5/23/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "OLGhostAlertView.h"

@interface MSUtils : NSObject

+ (UIColor *)colorWithHexString:(NSString *)hex;

+ (void)showErrorAlertWithTitle:(NSString *)title andMessage:(NSString *)message;

+ (void)showErrorAlertWithTitle:(NSString *)title andMessage:(NSString *)message andPosition:(OLGhostAlertViewPosition)position;

+ (BOOL)isChannelValid:(NSString *)channel;

+ (void)openAddressInMap:(NSString *)address;

@end

//
//  MSObjectManager.h
//  MiliShare
//
//  Created by Hang Zhao on 5/21/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "RKObjectManager.h"

@interface MSObjectManager : RKObjectManager

+ (instancetype) sharedManager;

- (void) setupRequestDescriptors;
- (void) setupResponseDescriptors;

@end

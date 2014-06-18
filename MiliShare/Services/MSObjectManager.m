//
//  MSObjectManager.m
//  MiliShare
//
//  Created by Hang Zhao on 5/21/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "MSObjectManager.h"
#import <RestKit/RestKit.h>

@implementation MSObjectManager

+ (instancetype)sharedManager {
    NSURL *url = [NSURL URLWithString:BaseServerURL];
    
    MSObjectManager *sharedManager  = [self managerWithBaseURL:url];
    sharedManager.requestSerializationMIMEType = RKMIMETypeJSON;
    /*
     THIS CLASS IS MAIN POINT FOR CUSTOMIZATION:
     - setup HTTP headers that should exist on all HTTP Requests
     - override methods in this class to change default behavior for all HTTP Requests
     - define methods that should be available across all object managers
     */
    
    [sharedManager setupRequestDescriptors];
    [sharedManager setupResponseDescriptors];
    
//    [sharedManager.HTTPClient setDefaultHeader:@"Authorization" value: [NSString stringWithFormat:@"token %@", PERSONAL_ACCESS_TOKEN]];
    
    return sharedManager;
}

- (void) setupRequestDescriptors {
}

- (void) setupResponseDescriptors {
}

@end

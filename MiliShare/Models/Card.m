//
//  Card.m
//  MiliShare
//
//  Created by Hang Zhao on 5/21/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "Card.h"

@implementation Card

- (instancetype)initWithChannel:(NSString *)channel andContent:(NSString *)content {
    self = [super init];
    if (self) {
        _channel = channel;
        _content = content;
    }
    return self;
}

@end

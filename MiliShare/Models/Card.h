//
//  Card.h
//  MiliShare
//
//  Created by Hang Zhao on 5/21/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

@interface Card : NSObject

@property (nonatomic, copy) NSString *channel;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic) BOOL permanent;

- (instancetype)initWithChannel:(NSString *)channel andContent:(NSString *)content;

@end

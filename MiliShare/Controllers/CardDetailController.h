//
//  CardDetailController.h
//  MiliShare
//
//  Created by Hang Zhao on 5/21/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Card;

@interface CardDetailController : UIViewController

@property (nonatomic, strong) Card *card;
@property (nonatomic, copy) NSString *channel;

- (instancetype)initWithCard:(Card *)card;
- (instancetype)initWithChannel:(NSString *)channel;

@end

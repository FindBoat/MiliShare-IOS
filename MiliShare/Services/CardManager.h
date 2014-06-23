//
//  CardManager.h
//  MiliShare
//
//  Created by Hang Zhao on 5/21/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "MSObjectManager.h"

@class Card;

@interface CardManager : MSObjectManager

- (void)getByChannel:(NSString *)channel success:(void (^)(Card *card))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

- (void)getLatestCards:(NSInteger)count success:(void (^)(NSArray *cards))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

- (void)create:(Card *)card success:(void (^)(Card *card))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

@end

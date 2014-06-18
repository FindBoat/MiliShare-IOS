//
//  CardManager.m
//  MiliShare
//
//  Created by Hang Zhao on 5/21/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "CardManager.h"
#import <RestKit/RestKit.h>
#import "MappingProvider.h"
#import "Card.h"

@implementation CardManager


- (void)getByChannel:(NSString *)channel success:(void (^)(Card *card))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure {
    [self getObjectsAtPath:@"/api/cards" parameters:@{@"channel": channel} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (success) {
            Card *card = (Card *)[mappingResult.array firstObject];
            success(card);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

- (void)create:(Card *)card success:(void (^)(Card *card))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure {
    [self postObject:card path:@"/api/cards" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (success) {
            Card *card = (Card *)[mappingResult.array firstObject];
            success(card);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

- (void)setupResponseDescriptors {
    [super setupResponseDescriptors];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[MappingProvider cardMapping] method:RKRequestMethodGET pathPattern:@"/api/cards" keyPath:@"data" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [self addResponseDescriptor:responseDescriptor];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[[MappingProvider cardMapping] inverseMapping] objectClass:[Card class] rootKeyPath:nil method:RKRequestMethodAny];
    [self addRequestDescriptor:requestDescriptor];

}


@end

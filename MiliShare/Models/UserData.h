//
//  UserData.h
//  MiliShare
//
//  Created by Hang Zhao on 5/25/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

@interface UserData : NSObject <NSCoding>

@property (nonatomic, copy) NSString *lastChannel;

+ (instancetype)sharedUserData;

+ (BOOL)saveUserData;


@end

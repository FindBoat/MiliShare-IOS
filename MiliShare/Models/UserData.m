//
//  UserData.m
//  MiliShare
//
//  Created by Hang Zhao on 5/25/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "UserData.h"

static UserData *userData = nil;

@implementation UserData

+ (instancetype)sharedUserData {
    if (!userData) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            // Init from archive.
            NSString *path = [UserData itemArchivePath];
            userData = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
            if (!userData) {
                userData = [[self alloc] init];
            }
        });
    }
    return userData;
}

+ (BOOL)saveUserData {
    NSString *path = [self itemArchivePath];
    
    // Returns YES on success.
    return [NSKeyedArchiver archiveRootObject:[UserData sharedUserData]
                                       toFile:path];
}

+ (NSString *)itemArchivePath {
    // Make sure that the first argument is NSDocumentDirectory
    // and not NSDocumentationDirectory.
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    
    // Get the one document directory from that list.
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"user-data.archive"];
}

#pragma mark - NSCoding.
- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.lastChannel forKey:@"lastChannel"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        _lastChannel = [decoder decodeObjectForKey:@"lastChannel"];
    }
    return self;
}

@end

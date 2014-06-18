//
//  MappingProvider.m
//  MiliShare
//
//  Created by Hang Zhao on 5/21/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "MappingProvider.h"
#import <RestKit/RestKit.h>
#import "Card.h"

@implementation MappingProvider

+ (RKObjectMapping *)cardMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Card class]];
    NSDictionary *mappingDictionary = @{@"channel": @"channel",
                                        @"content": @"content",
                                        @"create_time": @"createTime",
                                        @"permanent": @"permanent"};
    
    [mapping addAttributeMappingsFromDictionary:mappingDictionary];

    // Add date formatter for createTime.
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"ccc, dd LLL yyyy HH:mm:ss vvvv"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSArray *dateFormatters = [[NSArray alloc]initWithObjects:dateFormatter, nil];
    [RKObjectMapping setDefaultDateFormatters:dateFormatters];
    
    return mapping;
}

@end

//
//  MSUtils.m
//  MiliShare
//
//  Created by Hang Zhao on 5/23/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "MSUtils.h"
#import "OLGhostAlertView.h"
#import <MapKit/MapKit.h>

@implementation MSUtils

+ (UIColor *)colorWithHexString:(NSString *)hex {
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (void)showErrorAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    OLGhostAlertView *ghastly = [[OLGhostAlertView alloc] initWithTitle:title message:message];
    ghastly.position = OLGhostAlertViewPositionBottom;
    ghastly.style = OLGhostAlertViewStyleDark;
    ghastly.timeout = 1.5;
    [ghastly show];
}

+ (BOOL)isChannelValid:(NSString *)channel {
    if (!channel || channel.length == 0) {
        return NO;
    }
    NSCharacterSet *alphaSet = [NSCharacterSet alphanumericCharacterSet];
    return [[channel stringByTrimmingCharactersInSet:alphaSet] isEqualToString:@""];
}

+ (void)openAddressInMap:(NSString *)address {
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:address
                     completionHandler:^(NSArray *placemarks, NSError *error) {
                         
                         // Convert the CLPlacemark to an MKPlacemark
                         // Note: There's no error checking for a failed geocode
                         CLPlacemark *geocodedPlacemark = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc]
                                                   initWithCoordinate:geocodedPlacemark.location.coordinate
                                                   addressDictionary:geocodedPlacemark.addressDictionary];
                         
                         // Create a map item for the geocoded address to pass to Maps app
                         MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
                         [mapItem setName:geocodedPlacemark.name];
                         
                         [mapItem openInMapsWithLaunchOptions:nil];
                     }];
    }
}


@end

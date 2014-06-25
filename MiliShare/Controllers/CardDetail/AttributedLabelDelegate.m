//
//  AttributedLabelDelegate.m
//  MiliShare
//
//  Created by Hang Zhao on 6/4/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "AttributedLabelDelegate.h"
#import "MSUtils.h"
#import "MSWebViewController.h"

@interface AttributedLabelDelegate()

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *address;

@end

@implementation AttributedLabelDelegate

int const kActionSheetForLink = 0;
int const kActionSheetForAddress = 1;

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        _viewController = viewController;
    }
    return self;
}

#pragma mark - TTTAttributedLabelDelegate.
- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    self.url = [url absoluteString];
    MSWebViewController *webViewController = [[MSWebViewController alloc] init];
    webViewController.url = [NSURL URLWithString:self.url];
    [self.viewController.navigationController pushViewController:webViewController animated:YES];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber {
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]]];
    } else {
        [MSUtils showErrorAlertWithTitle:nil andMessage:@"Your device doesn't support phone call."];
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithAddress:(NSDictionary *)addressComponents {
    self.address = [self extractAddressFromText:label.text withAddressComponent:addressComponents];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:self.address
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Open in map", nil), nil];
    actionSheet.tag = kActionSheetForAddress;
    [actionSheet showInView:self.viewController.view];

}

#pragma mark - UIActionSheetDelegate.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    switch (actionSheet.tag) {
        case kActionSheetForAddress:
            [MSUtils openAddressInMap:self.address];
        default:
            break;
    }
}

// This is a very hacky way.
- (NSString *)extractAddressFromText:(NSString *)text withAddressComponent:(NSDictionary *)addressComponents {
    int start = 0, end = text.length;
    for (int i = 0; i < text.length; ++i) {
        for (int j = i; j <= text.length; ++j) {
            NSString *substr = [text substringWithRange:NSMakeRange(i, j - i)];
            if (substr.length > end - start) {
                continue;
            }
            BOOL containAll = YES;
            for (id key in addressComponents) {
                NSString *value = addressComponents[key];
                if ([substr rangeOfString:value].location == NSNotFound) {
                    containAll = NO;
                    break;
                }
            }
            if (containAll) {
                start = i;
                end = j;
            }
        }
    }
    
    return [text substringWithRange:NSMakeRange(start, end - start)];
}


@end

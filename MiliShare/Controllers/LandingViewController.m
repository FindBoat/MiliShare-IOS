//
//  LandingViewController.m
//  MiliShare
//
//  Created by Hang Zhao on 5/21/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "LandingViewController.h"
#import "LandingView.h"
#import "CardManager.h"
#import "CardDetailController.h"
#import "UserData.h"
#import "MSUtils.h"
#import "SVProgressHUD.h"
#import "OLGhostAlertView.h"
#import "Card.h"


@interface LandingViewController () <UITextFieldDelegate>

@property (nonatomic, strong) LandingView *landingView;
@property (nonatomic, strong) NSArray *suggestions;

@end

@implementation LandingViewController

- (void)loadView {
    self.navigationItem.title = @"MilliSync";
    self.landingView = [[LandingView alloc] initWithFrame:CGRectZero];
    self.landingView.channelTextField.delegate = self;
    self.landingView.channelTextField.text = [[UserData sharedUserData] lastChannel];
    [self.landingView.infoButton addTarget:self action:@selector(infoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.view = self.landingView;
    
    // Tap to dismiss keyboard.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    // Swipe to proceed.
    UISwipeGestureRecognizer * swipeLeft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft:)];
    swipeLeft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // The animation below only happens for once.
    if (self.isFirstTimeLaunch) {
        self.isFirstTimeLaunch = NO;
        [self.landingView appearWithAnimation];
    }

    // Update suggestions if needed.
    if ([self isSuggestionStale]) {
        NSLog(@"Update suggestions");
        [[CardManager sharedManager] getLatestCards:3 success:^(NSArray *cards) {
            self.suggestions = cards;
            [self.landingView setupSuggestButtons:self.suggestions];
            for (UIButton *button in self.landingView.suggestButtons) {
                [button addTarget:self action:@selector(suggestButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            }
        } failure:nil];
    }
}

#pragma mark - Swipe action.
- (void)swipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer {
    NSString *channel = [[UserData sharedUserData] lastChannel];
    if (channel) {
        [self goToChannel:channel andDismissKeyboard:YES];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.landingView showSuggestions];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *channel = textField.text;
    if ([MSUtils isChannelValid:channel]) {
        [self goToChannel:channel andDismissKeyboard:YES];
    } else {
        [MSUtils showErrorAlertWithTitle:@"Invalid channel" andMessage:@"Only letters and digits are allowed." andPosition:OLGhostAlertViewPositionCenter];
        [self.landingView shakeChannelTextField];
    }
    return YES;
}

#pragma mark - Private methods.
- (void)infoButtonAction:(id)sender {
    self.landingView.channelTextField.text = @"About";
    [self goToChannel:@"About" andDismissKeyboard:YES];
}

- (void)suggestButtonAction:(id)sender {
    NSString *channel = [[(UIButton *)sender titleLabel] text];
    self.landingView.channelTextField.text = channel;
    [self goToChannel:channel andDismissKeyboard:YES];
}

- (void)goToChannel:(NSString *)channel andDismissKeyboard:(BOOL)dismiss {
    [SVProgressHUD show];

    if (dismiss) {
        [self dismissKeyboard];
    }
    [[CardManager sharedManager] getByChannel:channel success:^(Card *card) {
        [SVProgressHUD dismiss];
        [[UserData sharedUserData] setLastChannel:channel];
        if (card != nil) {
            NSLog(@"Channel exists.");
            CardDetailController *cardDetailController = [[CardDetailController alloc] initWithCard:card];
            [self.navigationController pushViewController:cardDetailController animated:YES];
        } else {
            NSLog(@"Channel doesn't exist.");
            CardDetailController *cardDetailController = [[CardDetailController alloc] initWithChannel:channel];
            [self.navigationController pushViewController:cardDetailController animated:YES];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [MSUtils showErrorAlertWithTitle:@"Network error" andMessage:@"Please try again :)"];
    }];
}

- (void)dismissKeyboard {
    [self.landingView hideSuggestions];
    [self.landingView.channelTextField resignFirstResponder];
}

- (BOOL)isSuggestionStale {
    if (!self.suggestions || !self.suggestions.count) {
        return YES;
    }
    Card *card = (Card *)self.suggestions[0];
    return (-[card.createTime timeIntervalSinceNow] > 60 * 60);
}

@end

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


@interface LandingViewController () <UITextFieldDelegate>

@property (nonatomic, strong) LandingView *landingView;

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
    if (!self.isFirstTimeLaunch) {
        return;
    }
    self.isFirstTimeLaunch = NO;
    
    [self.landingView appearWithAnimation];
}

#pragma mark - Swipe action.
- (void)swipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer {
    NSString *channel = [[UserData sharedUserData] lastChannel];
    if (channel) {
        [self goToChannel:channel];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *channel = textField.text;
    if ([MSUtils isChannelValid:channel]) {
        [textField resignFirstResponder];
        [self.landingView toggleChannelValidity:YES animated:YES];
        [self goToChannel:channel];
    } else {
        [self.landingView toggleChannelValidity:NO animated:YES];
    }
    return YES;
}

#pragma mark - button.
- (void)infoButtonAction:(id)sender {
    self.landingView.channelTextField.text = @"About";
    [self goToChannel:@"About"];
}

- (void)goToChannel:(NSString *)channel {
    [SVProgressHUD show];
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
    [self.landingView.channelTextField resignFirstResponder];
}

@end

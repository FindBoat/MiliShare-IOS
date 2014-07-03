//
//  CardDetailController.m
//  MiliShare
//
//  Created by Hang Zhao on 5/21/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "CardDetailController.h"
#import "CardDetailView.h"
#import "Card.h"
#import "TTTAttributedLabel.h"
#import "CardManager.h"
#import "GCPlaceholderTextView.h"
#import "MSUtils.h"
#import "AttributedLabelDelegate.h"

@interface CardDetailController ()

@property (nonatomic, strong) AttributedLabelDelegate *attributedLabelDelegate;
@property (nonatomic, strong) CardDetailView *cardDetailView;

@end

@implementation CardDetailController

// Display card mode.
- (instancetype)initWithCard:(Card *)card {
    self = [super init];
    if (self) {
        _card = card;
    }
    return self;
}

// Create card mode.
- (instancetype)initWithChannel:(NSString *)channel {
    self = [super init];
    if (self) {
        _channel = channel;
    }
    return self;
}

- (void)loadView {
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"MilliSync";

    self.cardDetailView = [[CardDetailView alloc] initWithFrame:CGRectZero];
    self.view = self.cardDetailView;

    // Set attribute label delegate.
    self.attributedLabelDelegate = [[AttributedLabelDelegate alloc] initWithViewController:self];
    self.cardDetailView.instructionLabel.delegate = self.attributedLabelDelegate;
    self.cardDetailView.contentLabel.delegate = self.attributedLabelDelegate;

    NSAssert(self.card || self.channel, @"Must provide either card or channel.");
    if (self.card) {
        [self.cardDetailView setCard:self.card andToggleViews:YES animated:NO];
    } else {
        [self.cardDetailView setChannel:self.channel andToggleViews:YES];
        [self.cardDetailView.saveButton addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }

    // Swipe to back.
    UISwipeGestureRecognizer * swipeRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight:)];
    swipeRight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    
    // Tap to dismiss keyboard.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    // This is essential to solve the conflict with TTTAttributedLabel.
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

#pragma mark - Swipe action.
- (void)swipeRight:(UISwipeGestureRecognizer *)gestureRecognizer {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - button.
- (void)saveButtonAction:(id)sender {
    [self.cardDetailView.contentTextView resignFirstResponder];

    Card *card = [[Card alloc] initWithChannel:self.channel andContent:self.cardDetailView.contentTextView.text];

    [[CardManager sharedManager] create:card success:^(Card *card) {
        self.card = card;
        [self.cardDetailView setCard:self.card andToggleViews:YES animated:YES];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [MSUtils showErrorAlertWithTitle:@"Network error" andMessage:@"Please try again :)"];
    }];
}


- (void)dismissKeyboard {
    [self.cardDetailView.contentTextView resignFirstResponder];
}

@end

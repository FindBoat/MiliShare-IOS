//
//  LandingView.m
//  MiliShare
//
//  Created by Hang Zhao on 5/21/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "Card.h"
#import "LandingView.h"
#import "MSUtils.h"
#import "UITextField+Shake.h"
#import <QuartzCore/QuartzCore.h>

#define ARC4RANDOM_MAX      0x100000000

@implementation LandingView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    
    if (self) {
        self.channelTextField = [UITextField new];
        self.channelTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.channelTextField.placeholder = @"Enter a channel";
        self.channelTextField.returnKeyType = UIReturnKeyGo;
        self.channelTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.channelTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.channelTextField.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
        self.channelTextField.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.channelTextField];

        self.instructionLabel = [UILabel new];
        self.instructionLabel.textAlignment = NSTextAlignmentCenter;
        self.instructionLabel.text = @"Visit card by channel or create one with a new channel";
        self.instructionLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
        self.instructionLabel.textColor = [UIColor lightGrayColor];
        self.instructionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.instructionLabel.numberOfLines = 0;
        self.instructionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.instructionLabel];
        
        self.infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
        self.infoButton.tintColor = [UIColor lightGrayColor];
        self.infoButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.infoButton];
        
        self.invalidChannelLabel = [UILabel new];
        self.invalidChannelLabel.textAlignment = NSTextAlignmentCenter;
        self.invalidChannelLabel.text = @"Only letters and digits are allowed.";
        self.invalidChannelLabel.font = [UIFont systemFontOfSize:12.0f];
        self.invalidChannelLabel.textColor = [UIColor darkGrayColor];
        self.invalidChannelLabel.hidden = YES;
        self.invalidChannelLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.invalidChannelLabel];
        
        if (!self.suggestButtons) {
            self.suggestButtons = [NSMutableArray new];
        }
        
        self.backgroundColor = [MSUtils colorWithHexString:@"FAFAFA"];
       
        [self applyConstraints];


    }
    return self;
}

- (void)applyConstraints {
     // Constraints for channelTextField.
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.channelTextField
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.channelTextField
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:200.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.channelTextField
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:40.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.channelTextField
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:220.0f]];

    // Constraints for invalidChannelLabel.
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.invalidChannelLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.invalidChannelLabel
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.channelTextField
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:-10.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.invalidChannelLabel
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:250.0f]];

    // Constraints for instructionLabel.
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.instructionLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.instructionLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.channelTextField
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:30.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.instructionLabel
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:250.0f]];
    
    // Constraints for infoButton.
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.infoButton
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.infoButton
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.instructionLabel
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:30.0f]];
}

- (void)appearWithAnimation {
    // Animation for channelTextField. First set y to 0, then use spring animation to present it.
    CGRect finalPosition = self.channelTextField.frame;
    CGRect startPosition = self.channelTextField.frame;
    startPosition.origin.y = 0;
    self.channelTextField.frame = startPosition;
    
    [UIView animateWithDuration:1.5
                          delay:0.4
         usingSpringWithDamping:0.45
          initialSpringVelocity:0.0
                        options:0
                     animations:^{
                         self.channelTextField.frame = finalPosition;
                     }
                     completion:nil];
    
    // Animatin for instructionLabel and infoButton.
    self.instructionLabel.alpha = 0.0;
    self.infoButton.alpha = 0.0;
    [UIView animateWithDuration:0.5
                          delay:0.9
                        options:0
                     animations:^{
                         self.instructionLabel.alpha = 1.0;
                         self.infoButton.alpha = 1.0;
                     }
                     completion:nil];
}

- (void)toggleChannelValidity:(BOOL)valid animated:(BOOL)animated {
    if (valid) {
        self.invalidChannelLabel.hidden = YES;
    } else {
        if (animated) {
            [self.channelTextField shake:10   // 10 times
                               withDelta:10   // 10 points wide
                                andSpeed:0.05 // 50ms per shake
             ];
        }
        self.invalidChannelLabel.hidden = NO;
    }
}

-(void)setupSuggestButtons:(NSArray *)suggestions {
    if ([self needToRefreshSuggestions:suggestions]) {
        // Remove stale suggest buttons;
        for (UIButton *button in self.suggestButtons) {
            [button removeFromSuperview];
        }
        [self.suggestButtons removeAllObjects];
        
        // Create new suggest buttons.
        for (Card *card in suggestions) {
            UIButton *button = [self createSuggestButtonWithChannel:card.channel];
            [self.suggestButtons addObject:button];
        }
        
        // Setting constraints to display suggest buttons in equal spacing.
        float between = self.frame.size.width / (self.suggestButtons.count + 1);
        for (int i = 0; i < self.suggestButtons.count; i++) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.suggestButtons[i]
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1
                                                              constant:between * (i + 1)]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.suggestButtons[i]
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.channelTextField
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1
                                                              constant:-30.0f]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.suggestButtons[i]
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1
                                                              constant:70]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.suggestButtons[i]
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1
                                                              constant:25]];
        }
        [self needsUpdateConstraints];
    }
}

- (void)showSuggestions {
    for (UIButton *button in self.suggestButtons) {
        [self animateSuggestButton:button appear:YES];
    }
}

- (BOOL)needToRefreshSuggestions:(NSArray *)suggestions {
    if (self.suggestButtons.count != suggestions.count) {
        return YES;
    } else {
        for (int i = 0; i < self.suggestButtons.count; ++i) {
            UIButton *button = self.suggestButtons[i];
            if (![button.titleLabel.text isEqualToString:((Card *)suggestions[i]).channel]) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (UIButton *)createSuggestButtonWithChannel:(NSString *)channel {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
    [button setTitle:channel forState:UIControlStateNormal];
    [[button layer] setCornerRadius:15];
    [[button layer] setBorderWidth:1.0f];
    [[button layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)];
    button.hidden = YES;
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:button];
    
    return button;
}

- (void)animateSuggestButton:(UIButton *)button appear:(BOOL)appear {
    if (appear) {
        float randomDelay = ((double)arc4random() / ARC4RANDOM_MAX) * .3;
        button.hidden = NO;
        button.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [UIView animateKeyframesWithDuration:0.35
                                       delay:randomDelay
                                     options:0
                                  animations:^{
                                      [UIView addKeyframeWithRelativeStartTime:0
                                                              relativeDuration:0.8
                                                                    animations:^{
                                                                        button.transform = CGAffineTransformMakeScale(1.3, 1.3);
                                                                    }];
                                      [UIView addKeyframeWithRelativeStartTime:0.8
                                                              relativeDuration:0.2
                                                                    animations:^{
                                                                        button.transform = CGAffineTransformIdentity;
                                                                    }];
                                  }
                                  completion:nil];
    } else {
        [UIView animateKeyframesWithDuration:0.35
                                       delay:0
                                     options:0
                                  animations:^{
                                      [UIView addKeyframeWithRelativeStartTime:0
                                                              relativeDuration:0.2
                                                                    animations:^{
                                                                        // This is a workaround to fix the weird jump caused by auto layout.
                                                                        CGRect currentFrame = button.frame;
                                                                        currentFrame.origin.y += 0.01;
                                                                        button.frame = currentFrame;
                                                                        button.transform = CGAffineTransformMakeScale(1.3, 1.3);
                                                                    }];
                                      [UIView addKeyframeWithRelativeStartTime:0.2
                                                              relativeDuration:0.8
                                                                    animations:^{
                                                                        button.transform = CGAffineTransformMakeScale(0.01, 0.01);
                                                                    }];
                                  }
                                  completion:^(BOOL finished){
                                      if (finished) {
                                          button.hidden = YES;
                                          button.transform = CGAffineTransformIdentity;
                                      }
                                  }];
    }
}

- (void)hideSuggestions {
    for (UIButton *button in self.suggestButtons) {
        [self animateSuggestButton:button appear:NO];
    }
}

@end

//
//  LandingView.h
//  MiliShare
//
//  Created by Hang Zhao on 5/21/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LandingView : UIView

@property (nonatomic, strong) UITextField *channelTextField;
@property (nonatomic, strong) UILabel *instructionLabel;
@property (nonatomic, strong) UIButton *infoButton;
@property (nonatomic, strong) UILabel *invalidChannelLabel;

// Suggest.
@property (nonatomic, strong) NSMutableArray *suggestButtons;

- (void)appearWithAnimation;
- (void)toggleChannelValidity:(BOOL)valid animated:(BOOL)animated;

- (void)setupSuggestButtons:(NSArray *)suggestions;
- (void)showSuggestions;
- (void)hideSuggestions;

@end

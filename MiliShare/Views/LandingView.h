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

// Suggest.
@property (nonatomic, strong) NSMutableArray *suggestButtons;

- (void)appearWithAnimation:(BOOL)animated;
- (void)shakeChannelTextField;

- (void)setupSuggestButtons:(NSArray *)suggestions;
- (void)showSuggestions;
- (void)hideSuggestions;

@end

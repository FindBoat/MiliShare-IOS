//
//  CardDetailView.h
//  MiliShare
//
//  Created by Hang Zhao on 5/21/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Card;
@class TTTAttributedLabel;
@class GCPlaceholderTextView;

@interface CardDetailView : UIView

@property (nonatomic, strong) Card *card;
@property (nonatomic, copy) NSString *channel;

// Views for display card mode.
@property (nonatomic, strong) UILabel *channelLabel;
@property (nonatomic, strong) TTTAttributedLabel *contentLabel;
@property (nonatomic, strong) UILabel *destructionLabel;

// Views for create card mode.
@property (nonatomic, strong) GCPlaceholderTextView *contentTextView;
@property (nonatomic, strong) UIButton *saveButton;

// Common views.
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) UIView *bottomSeparatorView;
@property (nonatomic, strong) TTTAttributedLabel *instructionLabel;


- (void)setChannel:(NSString *)channel andToggleViews:(BOOL)toggle;
- (void)setCard:(Card *)card andToggleViews:(BOOL)toggle animated:(BOOL)animated;


@end

//
//  CardDetailView.m
//  MiliShare
//
//  Created by Hang Zhao on 5/21/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "CardDetailView.h"
#import "Card.h"
#import "MSUtils.h"
#import "TTTAttributedLabel.h"
#import "GCPlaceholderTextView.h"
#import <QuartzCore/QuartzCore.h>

@interface CardDetailView()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) int secondsLeft;

@end
@implementation CardDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initViews];
    }
    return self;
}

// Init views with no content.
- (void)initViews {
    self.channelLabel = [UILabel new];
    self.channelLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    self.channelLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.channelLabel];
    
    self.contentLabel = [TTTAttributedLabel new];
    self.contentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink | NSTextCheckingTypeAddress | NSTextCheckingTypePhoneNumber;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
    self.contentLabel.textColor = [UIColor darkGrayColor];
    self.contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.contentLabel];
    
    self.destructionLabel = [UILabel new];
    self.destructionLabel.textColor = [UIColor lightGrayColor];
    self.destructionLabel.text = @"00:00:00 before destruction";
    self.destructionLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
    self.destructionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.destructionLabel];
    
    self.separatorView = [UIView new];
    self.separatorView.backgroundColor = [UIColor lightGrayColor];
    self.separatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.separatorView];
    
    self.bottomSeparatorView = [UIView new];
    self.bottomSeparatorView.backgroundColor = [UIColor darkGrayColor];
    self.bottomSeparatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.bottomSeparatorView];
    
    self.instructionLabel = [TTTAttributedLabel new];
    self.instructionLabel.textColor = [UIColor grayColor];
    self.instructionLabel.linkAttributes = @{(id)kCTForegroundColorAttributeName: [UIColor darkGrayColor],
                                             (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleSingle]};
    self.instructionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.instructionLabel.numberOfLines = 0;
    self.instructionLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.instructionLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
    self.instructionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.instructionLabel];
    
    self.contentTextView = [GCPlaceholderTextView new];
    self.contentTextView.font = [UIFont systemFontOfSize:16.0f];
    self.contentTextView.placeholder = @"Tap to edit.\nSwipe back to cancel.";
    self.contentTextView.opaque = NO;
    self.contentTextView.backgroundColor = [UIColor clearColor];
    self.contentTextView.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
    self.contentTextView.textColor = [UIColor darkGrayColor];
    self.contentTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.contentTextView];
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [[self.saveButton layer] setBorderWidth:1.0f];
    [[self.saveButton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    self.saveButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.saveButton];
    
    self.backgroundColor = [MSUtils colorWithHexString:@"FDFDFD"];
    
    [self applyConstraints];
}

#pragma mark - Custom setters.
- (void)setChannel:(NSString *)channel andToggleViews:(BOOL)toggle {
    _channel = channel;

    if (toggle) {
        self.channelLabel.text = channel;
        NSString *link = [NSString stringWithFormat:@"%@/%@", kBaseServerURL, channel];
        self.instructionLabel.text = [NSString stringWithFormat:@"Share this card by channel or visit %@", link];
        NSRange range = [self.instructionLabel.text rangeOfString:link];
        [self.instructionLabel addLinkToURL:[NSURL URLWithString:link] withRange:range];

        [self toggleViewsHasCard:NO];
    }
}

- (void)setCard:(Card *)card andToggleViews:(BOOL)toggle animated:(BOOL)animated {
    _card = card;

    if (toggle) {
        self.channelLabel.text = card.channel;
        self.contentLabel.text = card.content;
        NSString *link = [NSString stringWithFormat:@"%@/%@", kBaseServerURL, card.channel];
        self.instructionLabel.text = [NSString stringWithFormat:@"Share this card by channel or visit %@", link];
        NSRange range = [self.instructionLabel.text rangeOfString:link];
        [self.instructionLabel addLinkToURL:[NSURL URLWithString:link] withRange:range];
    
        [self toggleViewsHasCard:YES];
        
        if (card.permanent) {
            self.destructionLabel.hidden = YES;
        } else {
            [self startTimer:self.card];
        }
        
        if (animated) {
            [self animateCard];
        }
    }
}

- (void)toggleViewsHasCard:(BOOL)hasCard {
    self.contentLabel.hidden = !hasCard;
    self.destructionLabel.hidden = !hasCard;

    self.contentTextView.hidden = hasCard;
    self.saveButton.hidden = hasCard;
}

#pragma mark - Sets constraints.
- (void)applyConstraints {
    // Constraints for channelLabel.
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.channelLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:30]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.channelLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:90.0f]];
    
    // Constraints for saveButton.
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.saveButton
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:-30]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.saveButton
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.channelLabel
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.saveButton
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:50]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.saveButton
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:25]];

 
    // Contraints for separatorView.
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.separatorView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.channelLabel
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:30]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.separatorView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:20]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.separatorView
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:-20]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.separatorView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:0.5f]];

    // Constraints for contentLabel.
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.separatorView
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:20]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.channelLabel
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationLessThanOrEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:-30]];
    
    // Constraints for contentTextView.
    // We should try to make the text has the exact same position with contentLabel.
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentTextView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.separatorView
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:11.5f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentTextView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.channelLabel
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:-5.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentTextView
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:-30]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentTextView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.bottomSeparatorView
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:-50]];
    
    // Contraints for bottomSeparatorView.
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomSeparatorView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:-100]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomSeparatorView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomSeparatorView
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomSeparatorView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:0.5f]];
    
    // Constraints for destructionLabel.
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.destructionLabel
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.bottomSeparatorView
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:-20]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.destructionLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:-20.0f]];
    

    // Constraints for instructionLabel.
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.instructionLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.bottomSeparatorView
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:20]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.instructionLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:20]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.instructionLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:-20]];
}

#pragma mark - Timer related.
- (void)startTimer:(Card *)card {
    self.secondsLeft = [self calculateSecondsLeft:card.createTime];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
}

- (void)updateCounter:(NSTimer *)theTimer {
    if(self.secondsLeft > 0 ){
        self.secondsLeft--;
        int hours = self.secondsLeft / 3600;
        int minutes = (self.secondsLeft % 3600) / 60;
        int seconds = (self.secondsLeft % 3600) % 60;
        self.destructionLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d before destruction", hours, minutes, seconds];
    }
}

- (int)calculateSecondsLeft:(NSDate *)createTime {
    if (!createTime) {
        return 0;
    }
    NSUInteger componentFlags = NSDayCalendarUnit;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:componentFlags fromDate:createTime];
    [components setDay:1];
    NSDate *deadline = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:createTime options:0];
    
    return [deadline timeIntervalSinceNow];
}

- (void)animateCard {
    // Animation for saveButton.
    [UIView animateWithDuration:0.6
                          delay:0
                        options:0
                     animations:^{
                         self.saveButton.alpha = 0;
                     }
                     completion:nil];
    // Animation for destructionLabel;
    UILabel *label = self.destructionLabel;
    CGRect finalPosition = label.frame;
    CGRect startPosition = label.frame;
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    startPosition.origin.x = screenBound.size.width;
    
    label.frame = startPosition;
    label.alpha = 0;
    label.textColor = [UIColor lightGrayColor];
    
    [UIView animateKeyframesWithDuration:1
                                   delay:0
                                 options:0
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0
                                                          relativeDuration:0.42
                                                                animations:^{
                                                                    CGRect tempPosition = finalPosition;
                                                                    tempPosition.origin.x -= 25;
                                                                    label.frame = tempPosition;
                                                                    label.alpha = 0.9;
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.42
                                                          relativeDuration:0.28
                                                                animations:^{
                                                                    label.frame = finalPosition;
                                                                    label.alpha = 1;
                                                                    label.textColor = [UIColor blackColor];
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.7
                                                          relativeDuration:0.3
                                                                animations:^{
                                                                    label.alpha = 0.6;
                                                                }];
                              }
                              completion:nil];
    
}



@end

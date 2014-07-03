//
//  IntroViewController.m
//  MiliShare
//
//  Created by Hang Zhao on 6/30/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "IntroViewController.h"
#import "MYIntroductionPanel.h"
#import "MYBlurIntroductionView.h"
#import "LandingViewController.h"

@interface IntroViewController () <MYIntroductionDelegate>

@end

@implementation IntroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;

    MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) title:@"\n\nWelcome to MilliSync" description:@"\n\nMilliSync is a lightweight cloud service that lets you share cards (notes) between devices and friends with one link.\n\nEverything is stored anonymously and will be deleted after 24h."];
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) title:@"\n\nStep 1" description:@"\n\nPick a string as channel for your card."];
    MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) title:@"\n\nStep 2" description:@"\n\nEdit the card with anything you want if it's not occupied."];
    MYIntroductionPanel *panel4 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) title:@"\n\nStep 3" description:@"\n\nRevisit the card from any device or share with your friends.\n\n\nGo and explore!"];

    MYBlurIntroductionView *introductionView = [[MYBlurIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    introductionView.delegate = self;
    introductionView.BackgroundImageView.image = [UIImage imageNamed:@"intro7.jpg"];
    [introductionView setBackgroundColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:0.65]];
    //introductionView.LanguageDirection = MYLanguageDirectionRightToLeft;
    
    //Feel free to customize your introduction view here
    
    //Add panels to an array
    NSArray *panels = @[panel1, panel2, panel3, panel4];
    
    //Build the introduction with desired panels
    [introductionView buildIntroductionWithPanels:panels];
    [self.view addSubview:introductionView];
}

-(void)introduction:(MYBlurIntroductionView *)introductionView didFinishWithType:(MYFinishType)finishType {
    LandingViewController *landingViewController = [LandingViewController new];
    landingViewController.isFirstTimeLaunch = YES;
    [self.navigationController setViewControllers:@[landingViewController] animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

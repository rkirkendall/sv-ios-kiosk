//
//  VoterSignInVC.m
//  Kiosk
//
//  Created by Ricky Kirkendall on 1/4/16.
//  Copyright © 2016 SureVoting. All rights reserved.
//

#import "VoterSignInVC.h"
#import "ElectionManager.h"
#import "SVUtil.h"
#import "Vote.h"
#import "PinEntryViewController.h"
@interface VoterSignInVC ()

@end

@implementation VoterSignInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tokenError.hidden = YES;
    self.activityIndicator.hidden = YES;
    self.signInButton.enabled = YES;
    [self.signInButton setColor:[SVUtil buttonGreen]];
    self.voterTokenTextField.text = @"";
    [self.signInButton.titleLabel setFont:[UIFont systemFontOfSize:16 weight:0.4]];
    
    UITapGestureRecognizer *adminTouch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(adminPanelTapped)];
    [adminTouch setNumberOfTouchesRequired:1];
    
    [self.view addGestureRecognizer:adminTouch];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) adminPanelTapped{
    // Display modal presenatation of keypad
    NSLog(@"TAP DONE");
    [self performSegueWithIdentifier:@"showPinEntry" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"showPinEntry"]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        
        PinEntryViewController *dest = (PinEntryViewController *)navController.viewControllers[0];
        dest.parentVC = self;        
    }
    
}


- (IBAction)signInTapped:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kVoteStore];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([self.voterTokenTextField.text isEqualToString:@""]) {
        return;
    }
    
    self.signInButton.enabled = NO;
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    [[ElectionManager Manager] validateVoterToken:self.voterTokenTextField.text withCompletion:^(BOOL valid) {
        
        self.activityIndicator.hidden = YES;
        [self.activityIndicator stopAnimating];
        
        if (!valid) {
            self.signInButton.enabled = YES;
            self.tokenError.hidden = NO;
            
        }else{
            self.tokenError.hidden = YES;
            [self performSegueWithIdentifier:@"showInstructions" sender:self];
        }
        
    }];
    
}
@end

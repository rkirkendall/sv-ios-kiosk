//
//  ViewController.m
//  Kiosk
//
//  Created by Ricky Kirkendall on 12/5/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import "PickElectionVC.h"
#import "ElectionManager.h"
#import "SVUtil.h"
@interface PickElectionVC ()

@end

@implementation PickElectionVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.electionIdField.text = @"";
    
    self.startVotingButton.enabled = YES;
    self.activityIndicator.hidden = YES;
    
    self.invalidElectionMessage.hidden = YES;
    [self.startVotingButton setColor:[SVUtil buttonGreen]];
    [self.startVotingButton.titleLabel setFont:[UIFont systemFontOfSize:16 weight:0.4]];
}

- (IBAction)startVotingTapped:(id)sender {
    
    if ([self.electionIdField.text isEqualToString:@""]) {
        return;
    }
    
    self.startVotingButton.enabled = NO;
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    [[ElectionManager Manager] joinElectionWithId:self.electionIdField.text withCompletion:^(BOOL valid) {
        
        self.activityIndicator.hidden = YES;
        [self.activityIndicator stopAnimating];
        
        if (!valid) {
            self.invalidElectionMessage.hidden = NO;
            self.startVotingButton.enabled = YES;
            
        }else{
            self.invalidElectionMessage.hidden = YES;
            [self performSegueWithIdentifier:@"showSignIn" sender:self];
        }
    }];
}
@end

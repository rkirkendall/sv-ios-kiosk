//
//  ViewController.m
//  DemoApp
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
    self.invalidElectionMessage.hidden = YES;
    [self.startVotingButton setColor:[SVUtil buttonGreen]];
    [self.startVotingButton.titleLabel setFont:[UIFont systemFontOfSize:16 weight:0.4]];
}

- (IBAction)startVotingTapped:(id)sender {
    [[ElectionManager Manager] joinElectionWithId:self.electionIdField.text withCompletion:^(BOOL valid) {
        if (!valid) {
            self.invalidElectionMessage.hidden = NO;
        }else{
            self.invalidElectionMessage.hidden = YES;
            [self performSegueWithIdentifier:@"showInstructions" sender:self];
        }
    }];
}
@end

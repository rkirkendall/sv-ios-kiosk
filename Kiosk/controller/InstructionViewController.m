//
//  InstructionViewController.m
//  Kiosk
//
//  Created by Ricky Kirkendall on 12/14/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import "InstructionViewController.h"
#import "SVUtil.h"
#import "Blockchain.h"
#import "ElectionManager.h"
@interface InstructionViewController ()

@end

@implementation InstructionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.continueButton setColor:[SVUtil buttonGreen]];
    [self.continueButton.titleLabel setFont:[UIFont systemFontOfSize:20 weight:0.5]];
    
    self.firstCellView.layer.cornerRadius = 8;
    self.firstCellView.layer.masksToBounds = true;
    
    self.secondCellView.layer.cornerRadius = 8;
    self.secondCellView.layer.masksToBounds = true;
    self.secondCellView.backgroundColor = [SVUtil voteSelectionGreen];
    self.title = @"Instructions";
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSString *electionID = [[[ElectionManager Manager] currentElection] objectId];
    [Blockchain CreateOrGetBTCAddressForElectionID:electionID withCompletion:^(NSDictionary *address) {
        NSLog(@" got the address.");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)continueTapped:(id)sender {
    
    [self performSegueWithIdentifier:@"showTicketView" sender:self];
}
@end

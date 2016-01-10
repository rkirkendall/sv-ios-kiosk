//
//  VoteReviewVC.m
//  Kiosk
//
//  Created by Ricky Kirkendall on 12/23/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import "VoteReviewVC.h"
#import "SVUtil.h"
#import "ElectionManager.h"
#import "ReviewCell.h"
#import "ReviewHeaderCell.h"
#import "Vote.h"
#import "Blockchain.h"
@interface VoteReviewVC ()

@property (nonatomic, strong) NSMutableDictionary *dataSource;

@end

@implementation VoteReviewVC


-(void)viewDidLoad{
    [self.submitButton setColor:[SVUtil buttonGreen]];
    [self.submitButton.titleLabel setFont:[UIFont systemFontOfSize:20 weight:0.5]];
    self.title = @"Vote Review";
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationItem.hidesBackButton = NO;
    self.activityIndicator.hidden = YES;
    self.submitButton.enabled = YES;
    // Populate data source with offices and voted-on candidates
    
    self.dataSource = [NSMutableDictionary dictionary];
    NSArray *offices = [[[ElectionManager Manager] currentElection] offices];
    
    for (Office *office in offices) {
        self.dataSource[office.objectId] = [office votedCandidates];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *offices = [[[ElectionManager Manager] currentElection] offices];
    Office *office = offices[section];
    NSArray *voted = [office votedCandidates];
    return voted.count+1;

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[[[ElectionManager Manager] currentElection] offices] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"cell";
    if (indexPath.row == 0) {
        CellIdentifier = @"headerCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    NSArray *offices = [[[ElectionManager Manager] currentElection] offices];
    Office *office = offices[indexPath.section];
    if (indexPath.row == 0) {
        ReviewHeaderCell *revCell = (ReviewHeaderCell *)cell;
        revCell.officeLabel.text = office.name;
        [revCell setClearBackground];
    }else{
        ReviewCell *rc = (ReviewCell *)cell;
        NSArray *cans = self.dataSource[office.objectId];
        Candidate *can = cans[indexPath.row-1];
        NSString *text = [NSString stringWithFormat:@"%@. %@", [NSNumber numberWithInteger:indexPath.row], [can displayLabel]];
        rc.candidateLabel.text = text;
        [rc setClearBackground];
    }
    
    return cell;
}

- (IBAction)submitButtonTapped:(id)sender {
    
    self.submitButton.enabled = NO;
    self.activityIndicator.hidden = NO;
    self.navigationItem.hidesBackButton = YES;
    [self.activityIndicator startAnimating];
    
    // Save votes
    Election *current = [[ElectionManager Manager] currentElection];
    NSArray *offices = [current offices];
    NSMutableArray *votedCandidates = [NSMutableArray array];
    
    
    for (Office *office in offices) {
        [votedCandidates addObjectsFromArray:[office votedCandidates]];
    }
    
    NSInteger count = 1;
    for (Candidate *candidate in votedCandidates) {
        Vote *vote = [[Vote alloc] initWithCandidate:candidate];
        vote.voteid = [NSNumber numberWithInteger:count];
        [vote serialize];
        count++;
    }
    [self attemptSendVotes];
}

- (void) attemptSendVotes{
    
    // TODO: Block UI with toast
    
    [Blockchain CastVotesWithCompletion:^(BOOL success) {
        if (success) {
            NSLog(@"Votes cast successfully!");
            [self voteSubmissionSuccessful];
        }else{
            NSLog(@"Votes NOT CAST!");
            [self voteSubmissionFailed];
        }
    }];
}

- (void) voteSubmissionSuccessful{
    
    [[[ElectionManager Manager] currentElection] clearVoteTicket];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Votes Submitted"
                                                                   message:@"Your votes have been successfully submitted! Thank you for your participation in this election."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              // Go back to instruction view
                                                              //[self.navigationController popToRootViewControllerAnimated:YES];
                                                              
                                                              // Go back to voter sign in
                                                              [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                                                              
                                                          }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) voteSubmissionFailed{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Problem"
                                                                   message:@"Your votes have not yet been submitted. Please check your internet connection and try again."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self attemptSendVotes];
                                                          }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];

}


@end

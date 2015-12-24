//
//  VoteTicketViewController.m
//  DemoApp
//
//  Created by Ricky Kirkendall on 12/12/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import "VoteTicketViewController.h"
#import "SVUtil.h"
#import "ElectionManager.h"
#import <QuartzCore/QuartzCore.h>
@interface VoteTicketViewController ()

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) Office *selectedOffice;

@end

@implementation VoteTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.continueButton setColor:[SVUtil buttonGreen]];
    [self.continueButton.titleLabel setFont:[UIFont systemFontOfSize:20 weight:0.5]];
    self.title = [NSString stringWithFormat:@"Voting in \"%@\"",[[ElectionManager Manager] currentElection].name];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.officeIndex) {
        self.officeIndex = 0;
    }
    
    NSLog(@"ix: %d",self.officeIndex);
    
    self.selectedOffice = [[[ElectionManager Manager]currentElection]offices][self.officeIndex];
    self.dataSource = [NSArray arrayWithArray:self.selectedOffice.candidates];
    [self drawLabels];
}

- (void) drawLabels{
    [self updateChosenVotesLabel];
    [self updateRemainingVotesLabel];
    [self updateVotingForLabel];
}

- (NSInteger) numberOfVotesRemaining{
    NSInteger remaining = self.selectedOffice.limit.integerValue - self.selectedOffice.votesCast.integerValue;
    return remaining;
}

- (void) updateRemainingVotesLabel{
    NSInteger remaining = [self numberOfVotesRemaining];
    NSString *string = [NSString stringWithFormat:@"%@ votes remaining.",[NSNumber numberWithInteger:remaining]];
    self.remainingVotesLabel.text = string;
    
}
- (void) updateChosenVotesLabel{
    NSString *string = [NSString stringWithFormat:@"You have chosen %@ out of %@ votes.",self.selectedOffice.votesCast, self.selectedOffice.limit];
    self.chosenVotesLabel.text = string;
}

- (void) updateVotingForLabel{
    NSString *string = [NSString stringWithFormat:@"Voting for: %@",self.selectedOffice.name];
    self.votingForLabel.text = string;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0; // you can have your own choice, of course
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    CandidateTableViewCell *candidateCell = (CandidateTableViewCell *)cell;
    candidateCell.index = indexPath.section;
    candidateCell.candidate = self.dataSource[indexPath.section];
    candidateCell.delegate = self;
    candidateCell.layer.cornerRadius = 8;
    candidateCell.layer.masksToBounds = true;
    
    
    return candidateCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CandidateTableViewCell *cell = (CandidateTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    BOOL isVoteAttempt = !cell.candidate.votedFor;
    if (isVoteAttempt && [self canSelectCandidate]) {
        [cell setSelectionState:YES];
    }else{
        [cell setSelectionState:NO];
    }
    [self drawLabels];
}

- (BOOL)canSelectCandidate{
    NSInteger rem = [self numberOfVotesRemaining];
    if (rem > 0) {
        return YES;
    }else{
        return NO;
    }
}

- (void) goToNextTicket{
    VoteTicketViewController *nextTicket = [self.storyboard instantiateViewControllerWithIdentifier:@"VoteTicketViewController"];
    nextTicket.officeIndex = self.officeIndex+1;
    [self.navigationController pushViewController: nextTicket animated:YES];
}

- (IBAction)continueTapped:(id)sender {
    
    // Is there another office?
    NSInteger officeCount = [[[[ElectionManager Manager] currentElection] offices] count];
    if (officeCount > self.officeIndex+1) {
        [self goToNextTicket];
    }else{
        NSLog(@"Let user verify the submission");
    }
}
@end

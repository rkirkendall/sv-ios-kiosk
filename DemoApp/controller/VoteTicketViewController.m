//
//  VoteTicketViewController.m
//  DemoApp
//
//  Created by Ricky Kirkendall on 12/12/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import "VoteTicketViewController.h"
#import "CandidateTableViewCell.h"
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
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.officeIndex) {
        self.officeIndex = 0;
    }
    
    self.selectedOffice = [[[ElectionManager Manager]currentElection]offices][self.officeIndex];
    self.dataSource = [NSArray arrayWithArray:self.selectedOffice.candidates];
    [self drawLabels];
}

- (void) drawLabels{
    [self updateChosenVotesLabel];
    [self updateRemainingVotesLabel];
    [self updateVotingForLabel];
}

- (void) updateRemainingVotesLabel{
    NSInteger remaining = self.selectedOffice.limit.integerValue - self.selectedOffice.votesCast.integerValue;
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
    candidateCell.layer.cornerRadius = 8;
    candidateCell.layer.masksToBounds = true;
    
    
    return candidateCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CandidateTableViewCell *cell = (CandidateTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    BOOL s = cell.selected;
    [cell setSelected:s];
    [self drawLabels];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    CandidateTableViewCell *cell = (CandidateTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    BOOL s = cell.selected;
    [cell setSelected:s];
    [self drawLabels];
}

- (IBAction)continueTapped:(id)sender {
    
}
@end

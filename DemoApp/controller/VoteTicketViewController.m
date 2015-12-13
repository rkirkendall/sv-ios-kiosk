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

@end

@implementation VoteTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    self.dataSource = [[[ElectionManager Manager] currentElection] candidates];
    self.title = @"Now Voting";
    [self.continueButton setColor:[SVUtil buttonGreen]];
    [self.continueButton.titleLabel setFont:[UIFont systemFontOfSize:20 weight:0.5]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    candidateCell.candidate = self.dataSource[indexPath.section];
    candidateCell.layer.cornerRadius = 8;
    candidateCell.layer.masksToBounds = true;
    
    
    return candidateCell;
}
- (IBAction)continueTapped:(id)sender {
    
}
@end

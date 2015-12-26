//
//  VoteReviewVC.m
//  DemoApp
//
//  Created by Ricky Kirkendall on 12/23/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import "VoteReviewVC.h"
#import "SVUtil.h"
#import "ElectionManager.h"
#import "ReviewCell.h"
#import "ReviewHeaderCell.h"

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
    
}
@end

//
//  VoteTicketViewController.m
//  DemoApp
//
//  Created by Ricky Kirkendall on 12/12/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import "VoteTicketViewController.h"
#import "CandidateTableViewCell.h"
@interface VoteTicketViewController ()

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation VoteTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = @[@"Ricky Kirkendall", @"Genghis Khan", @"Frank Sinatra"];
    self.title = @"Now Voting";
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    CandidateTableViewCell *candidateCell = (CandidateTableViewCell *)cell;
    candidateCell.titleLabel.text = self.dataSource[indexPath.section];
    
    return candidateCell;
}
- (IBAction)continueTapped:(id)sender {
    
}
@end

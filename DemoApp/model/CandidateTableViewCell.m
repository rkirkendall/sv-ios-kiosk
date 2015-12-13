//
//  CandidateTableViewCell.m
//  DemoApp
//
//  Created by Ricky Kirkendall on 12/12/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import "CandidateTableViewCell.h"

@implementation CandidateTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)switchToggled:(id)sender {
}

-(void)setCandidate:(Candidate *)candidate{
    _candidate = candidate;
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",self.candidate.firstName, self.candidate.lastName];
}
@end

//
//  CandidateTableViewCell.m
//  DemoApp
//
//  Created by Ricky Kirkendall on 12/12/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import "CandidateTableViewCell.h"
#import "SVUtil.h"
@implementation CandidateTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)switchToggled:(id)sender {
    
    if ([self.delegate canSelectCandidate]) {
        [self setSelectionState:self.pickedSwitch.isOn];        
        [self.delegate drawLabels];
    }else{
        [self setSelectionState: NO];
        [self.delegate drawLabels];
    }
    
}

- (void)setSelectionState:(BOOL)selected{
    if (selected) {
        self.contentView.backgroundColor = [SVUtil voteSelectionGreen];
    }else{
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    self.candidate.votedFor = selected;
    [self.pickedSwitch setOn: self.candidate.votedFor animated:YES];
}


-(void)setCandidate:(Candidate *)candidate{
    _candidate = candidate;
    self.titleLabel.text = [NSString stringWithFormat:@"%@. %@",[NSNumber numberWithInteger:self.index+1],[candidate displayLabel]];
    [self setSelectionState:_candidate.votedFor];
}
@end

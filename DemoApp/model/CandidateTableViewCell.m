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
    [self setSelected:self.pickedSwitch.isOn];
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        self.contentView.backgroundColor = [SVUtil voteSelectionGreen];
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
    
    self.candidate.votedFor = selected;
    [self.pickedSwitch setOn: self.candidate.votedFor];
}

-(void)setCandidate:(Candidate *)candidate{
    _candidate = candidate;
    self.titleLabel.text = [NSString stringWithFormat:@"%@. %@ %@ [%@]",[NSNumber numberWithInteger:self.index+1] ,self.candidate.firstName, self.candidate.lastName,self.candidate.party.initials];
    [self setSelected:_candidate.votedFor];
}
@end

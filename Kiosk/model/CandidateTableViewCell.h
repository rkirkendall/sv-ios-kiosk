//
//  CandidateTableViewCell.h
//  Kiosk
//
//  Created by Ricky Kirkendall on 12/12/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Candidate.h"

// Add delegate

@protocol CandidateSelection

- (BOOL)canSelectCandidate;
- (void)drawLabels;

@end

@interface CandidateTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *pickedSwitch;
@property (nonatomic, strong) Candidate *candidate;
@property (nonatomic, readwrite) NSInteger index;
@property (nonatomic, strong) id<CandidateSelection> delegate;

- (IBAction)switchToggled:(id)sender;
- (void)setSelectionState:(BOOL)selected;


@end

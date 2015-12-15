//
//  VoteTicketViewController.h
//  DemoApp
//
//  Created by Ricky Kirkendall on 12/12/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BButton.h"
@interface VoteTicketViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *remainingVotesLabel;
@property (weak, nonatomic) IBOutlet UILabel *chosenVotesLabel;
@property (weak, nonatomic) IBOutlet BButton *continueButton;
@property (weak, nonatomic) IBOutlet UILabel *votingForLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, readwrite) NSInteger officeIndex;

- (IBAction)continueTapped:(id)sender;

@end

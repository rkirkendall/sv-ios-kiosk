//
//  VoteReviewVC.h
//  DemoApp
//
//  Created by Ricky Kirkendall on 12/23/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BButton.h"
@interface VoteReviewVC : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;
@property (weak, nonatomic) IBOutlet BButton *submitButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *voteReviewLabel;
- (IBAction)submitButtonTapped:(id)sender;

@end

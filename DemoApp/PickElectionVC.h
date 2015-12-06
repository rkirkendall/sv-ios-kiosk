//
//  ViewController.h
//  DemoApp
//
//  Created by Ricky Kirkendall on 12/5/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickElectionVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *electionIdField;

@property (weak, nonatomic) IBOutlet UIButton *startVotingButton;


- (IBAction)startVotingTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *invalidElectionMessage;


@end


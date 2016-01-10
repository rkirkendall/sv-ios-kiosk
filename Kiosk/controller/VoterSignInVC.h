//
//  VoterSignInVC.h
//  Kiosk
//
//  Created by Ricky Kirkendall on 1/4/16.
//  Copyright © 2016 SureVoting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BButton.h"
@interface VoterSignInVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *tokenError;
@property (weak, nonatomic) IBOutlet BButton *signInButton;
@property (weak, nonatomic) IBOutlet UITextField *voterTokenTextField;

- (IBAction)signInTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

//
//  VoterSignInVC.m
//  Kiosk
//
//  Created by Ricky Kirkendall on 1/4/16.
//  Copyright © 2016 SureVoting. All rights reserved.
//

#import "VoterSignInVC.h"
#import "ElectionManager.h"
#import "SVUtil.h"
@interface VoterSignInVC ()

@end

@implementation VoterSignInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tokenError.hidden = YES;
    self.activityIndicator.hidden = YES;
    self.signInButton.enabled = YES;
    [self.signInButton setColor:[SVUtil buttonGreen]];
    self.voterTokenTextField.text = @"";
    [self.signInButton.titleLabel setFont:[UIFont systemFontOfSize:16 weight:0.4]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)signInTapped:(id)sender {
    
    if ([self.voterTokenTextField.text isEqualToString:@""]) {
        return;
    }
    
    self.signInButton.enabled = NO;
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    [[ElectionManager Manager] validateVoterToken:self.voterTokenTextField.text withCompletion:^(BOOL valid) {
        
        self.activityIndicator.hidden = YES;
        [self.activityIndicator stopAnimating];
        
        if (!valid) {
            self.signInButton.enabled = YES;
            self.tokenError.hidden = NO;
            
        }else{
            self.tokenError.hidden = YES;
            [self performSegueWithIdentifier:@"showInstructions" sender:self];
        }
        
    }];
    
}
@end

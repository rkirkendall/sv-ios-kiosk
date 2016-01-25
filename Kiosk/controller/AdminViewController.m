//
//  AdminViewController.m
//  Kiosk
//
//  Created by Ricky Kirkendall on 1/20/16.
//  Copyright © 2016 SureVoting. All rights reserved.
//

#import "AdminViewController.h"
#import "SVUtil.h"

@interface AdminViewController ()

@end

@implementation AdminViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closeAdmin)];
    self.navigationItem.leftBarButtonItem = closeButton;
    
    self.title = @"Admin";
    
    self.refundButton.enabled = YES;
    [self.refundButton setColor:[SVUtil buttonGreen]];
    [self.refundButton.titleLabel setFont:[UIFont systemFontOfSize:16 weight:0.4]];
    
    self.closeKioskButton.enabled = YES;
    [self.closeKioskButton setColor:[SVUtil buttonGreen]];
    [self.closeKioskButton.titleLabel setFont:[UIFont systemFontOfSize:16 weight:0.4]];
    
    
}

-(void)closeAdmin{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)closeKioskTapped:(id)sender {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Close Kiosk"
                                                                   message:@"Are you sure you want to close this kiosk for the current election?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              // Go back to instruction view
                                                              //[self.navigationController popToRootViewControllerAnimated:YES];
                                                              
                                                              [self dismissViewControllerAnimated:YES completion:^{
                                                                  // Go back to voter sign in
                                                                  [self.parentVC dismissViewControllerAnimated:YES completion:nil];
                                                              }];
                                                              
                                                          }];
    
    UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                          }];
    
    [alert addAction:yesAction];
    [alert addAction:noAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)refundTapped:(id)sender {
    
    
    
}
@end

//
//  PinEntryViewController.m
//  Kiosk
//
//  Created by Ricky Kirkendall on 1/20/16.
//  Copyright © 2016 SureVoting. All rights reserved.
//

#import "PinEntryViewController.h"
#import "AdminViewController.h"
@interface PinEntryViewController ()

@end

@implementation PinEntryViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pinTextField.inputView = ({
        APNumberPad *numberPad = [APNumberPad numberPadWithDelegate:self];

        numberPad.leftFunctionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        numberPad;
    });
    self.pinTextField.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"Admin";
    [self.pinTextField becomeFirstResponder];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelledPinEntry)];
    self.navigationItem.leftBarButtonItem = closeButton;
}

#pragma mark - APNumberPadDelegate

- (void)numberPad:(APNumberPad *)numberPad functionButtonAction:(UIButton *)functionButton textInput:(UIResponder<UITextInput> *)textInput {
    //[textInput insertText:@"#"];
}

-(void) tryPIN{
    NSString *toTry = self.pinTextField.text;
    // Testing
    if ([toTry isEqualToString:@"1111"]) {
        NSLog(@"Nailed it");
        [self.pinTextField resignFirstResponder];
        [self performSegueWithIdentifier:@"showAdminView" sender:self];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string.length == 0) {
        return YES;
    }
    
    if (textField.text.length == 3) {
        self.pinTextField.text = [NSString stringWithFormat:@"%@%@",self.pinTextField.text,string];
        [self tryPIN];
        return NO;
    }else if(textField.text.length > 3){
        return NO;
    }
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showAdminView"]) {
        AdminViewController *dest = segue.destinationViewController;
        dest.parentVC = self.parentVC;
    }
}

- (void) cancelledPinEntry{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end

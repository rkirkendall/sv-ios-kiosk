//
//  PinEntryViewController.h
//  Kiosk
//
//  Created by Ricky Kirkendall on 1/20/16.
//  Copyright © 2016 SureVoting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <APNumberPad/APNumberPad.h>

@interface PinEntryViewController : UIViewController<APNumberPadDelegate, UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UILabel *pinLabel;

@property (weak, nonatomic) IBOutlet UITextField *pinTextField;

@property (nonatomic, strong) UIViewController *parentVC;

@end

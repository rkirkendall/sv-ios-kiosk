//
//  InstructionViewController.h
//  Kiosk
//
//  Created by Ricky Kirkendall on 12/14/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BButton.h"
@interface InstructionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *firstCellView;

@property (weak, nonatomic) IBOutlet UIView *secondCellView;
@property (weak, nonatomic) IBOutlet BButton *continueButton;

- (IBAction)continueTapped:(id)sender;

@end

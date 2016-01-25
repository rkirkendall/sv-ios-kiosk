//
//  AdminViewController.h
//  Kiosk
//
//  Created by Ricky Kirkendall on 1/20/16.
//  Copyright © 2016 SureVoting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BButton.h"
@interface AdminViewController : UIViewController

@property (weak, nonatomic) IBOutlet BButton *closeKioskButton;

@property (weak, nonatomic) IBOutlet BButton *refundButton;

@property (nonatomic, strong) UIViewController *parentVC;

- (IBAction)closeKioskTapped:(id)sender;
- (IBAction)refundTapped:(id)sender;


@end

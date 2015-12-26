//
//  ReviewHeaderCell.h
//  Kiosk
//
//  Created by Ricky Kirkendall on 12/26/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *officeLabel;

-(void)setClearBackground;

@end

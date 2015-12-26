//
//  Election.h
//  Kiosk
//
//  Created by Ricky Kirkendall on 12/5/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface Election : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, strong) NSArray *parties;
@property (nonatomic, strong) NSArray *offices;
@property (nonatomic, strong) NSArray *candidates;

@end

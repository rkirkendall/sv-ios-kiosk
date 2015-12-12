//
//  Election.m
//  DemoApp
//
//  Created by Ricky Kirkendall on 12/5/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import "Election.h"
#import <Parse/PFObject+Subclass.h>
@implementation Election

@dynamic name;
@dynamic startDate;
@dynamic endDate;

+ (NSString *)parseClassName {
    return @"Election";
}

+ (void)load {
    [self registerSubclass];
}

@end
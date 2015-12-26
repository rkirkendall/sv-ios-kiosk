//
//  Party.m
//  Kiosk
//
//  Created by Ricky Kirkendall on 12/12/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import "Party.h"

@implementation Party
@dynamic initials;
@dynamic name;

+ (NSString *)parseClassName {
    return @"Party";
}

+ (void)load {
    [super load];
    [self registerSubclass];
}

@end

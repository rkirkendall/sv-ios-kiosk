//
//  Candidate.m
//  Kiosk
//
//  Created by Ricky Kirkendall on 12/12/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import "Candidate.h"

@implementation Candidate

@dynamic firstName;
@dynamic lastName;
@dynamic btcAddress;
@dynamic creationType;
@dynamic office;
@dynamic party;

@synthesize votedFor;

+ (NSString *)parseClassName {
    return @"Candidate";
}

+ (void)load {
    [super load];
    [self registerSubclass];
}

-(NSString *)displayLabel{
    return [NSString stringWithFormat:@"%@ %@ [%@]" ,self.firstName, self.lastName,self.party.initials];
}

@end

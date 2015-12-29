//
//  Election.m
//  Kiosk
//
//  Created by Ricky Kirkendall on 12/5/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import "Election.h"
#import <Parse/PFObject+Subclass.h>
#import "Candidate.h"
@implementation Election

@synthesize parties;
@synthesize offices;
@synthesize candidates;

@dynamic name;
@dynamic startDate;
@dynamic endDate;

+ (NSString *)parseClassName {
    return @"Election";
}

+ (void)load {
    [super load];
    [self registerSubclass];
}

- (void)clearVoteTicket{
    for (Candidate *cand in self.candidates) {
        cand.votedFor = NO;
    }
}

@end

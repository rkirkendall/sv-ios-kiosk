//
//  Vote.m
//  Kiosk
//
//  Created by Ricky Kirkendall on 12/27/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import "Vote.h"


@implementation Vote

- (instancetype)initWithCandidate:(Candidate *)candidate
{
    self = [super init];
    if (self) {
        self.candidate = candidate;
        self.date = [NSDate date];
    }
    return self;
}


- (void) serialize{
    NSString *btcAddress = self.candidate.btcAddress;
    if (!btcAddress) {
        btcAddress = @"";
    }
    
    NSDictionary *toStore = @{kDate:self.date,
                              kCandidateAddress:btcAddress,
                              kVoteId:self.voteid
                              };
    NSMutableArray *allVotes = [[[NSUserDefaults standardUserDefaults] objectForKey:kVoteStore] mutableCopy];
    if (!allVotes) {
        allVotes = [NSMutableArray array];
    }
    
    [allVotes addObject:toStore];
    
    [[NSUserDefaults standardUserDefaults] setObject:allVotes forKey:kVoteStore];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

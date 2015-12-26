//
//  Office.m
//  DemoApp
//
//  Created by Ricky Kirkendall on 12/12/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import "Office.h"
#import "Candidate.h"
#import "ElectionManager.h"
@implementation Office

@dynamic limit;
@dynamic name;
@dynamic order;
@dynamic election;

+ (NSString *)parseClassName {
    return @"Office";
}

+ (void)load {
    [super load];
    [self registerSubclass];
}

-(NSNumber *)votesCast{
    NSInteger toReturn = 0;
    for (Candidate *can in self.candidates) {
        if (can.votedFor) {
            toReturn++;
        }
    }
    return [NSNumber numberWithInteger:toReturn];
}

- (NSArray *)votedCandidates{
    NSMutableArray *votes = [NSMutableArray array];
    for (Candidate *can in [self candidates]) {
        if (can.votedFor) {
            [votes addObject:can];
        }
    }
    return votes;
}

- (NSArray *)candidates{
    NSArray *all = [[ElectionManager Manager] currentElection].candidates;
    NSMutableArray *forOffice = [NSMutableArray array];
    for (Candidate *c in all) {
        if ([c.office.objectId isEqualToString:self.objectId]) {
            [forOffice addObject:c];
        }
    }
    return forOffice;
}

@end

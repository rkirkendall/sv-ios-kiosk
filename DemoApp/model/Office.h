//
//  Office.h
//  DemoApp
//
//  Created by Ricky Kirkendall on 12/12/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import <Parse/Parse.h>
#import "Election.h"
@interface Office : PFObject<PFSubclassing>

@property (nonatomic, strong) NSNumber *limit;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *order;
@property (nonatomic, strong) Election *election;

- (NSArray *)candidates;

- (NSNumber *)votesCast;

- (NSArray *)votedCandidates;

@end

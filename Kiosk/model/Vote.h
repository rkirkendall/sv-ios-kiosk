//
//  Vote.h
//  Kiosk
//
//  Created by Ricky Kirkendall on 12/27/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Candidate.h"


#define kDate @"date"
#define kCandidateAddress @"address"
#define kVoteId @"voteid"

#define kVoteStore @"storedVotes"

@interface Vote : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) Candidate *candidate;
@property (nonatomic, strong) NSNumber *voteid;

- (instancetype)initWithCandidate:(Candidate *)candidate;

- (void) serialize;

@end

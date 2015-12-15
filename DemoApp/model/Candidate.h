//
//  Candidate.h
//  DemoApp
//
//  Created by Ricky Kirkendall on 12/12/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import <Parse/Parse.h>
#import "Office.h"
#import "Party.h"
@interface Candidate : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *btcAddress;
@property (nonatomic, strong) NSString *creationType;
@property (nonatomic, strong) Office *office;
@property (nonatomic, strong) Party *party;

@property (nonatomic, readwrite) BOOL votedFor;

@end

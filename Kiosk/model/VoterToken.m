//
//  VoterToken.m
//  Kiosk
//
//  Created by Ricky Kirkendall on 1/4/16.
//  Copyright © 2016 SureVoting. All rights reserved.
//

#import "VoterToken.h"

@implementation VoterToken

@dynamic tokenId;
@dynamic expires;

+ (NSString *)parseClassName {
    return @"VoterToken";
}

+ (void)load {
    [super load];
    [self registerSubclass];
}

@end

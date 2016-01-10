//
//  VoterToken.h
//  Kiosk
//
//  Created by Ricky Kirkendall on 1/4/16.
//  Copyright © 2016 SureVoting. All rights reserved.
//

#import <Parse/Parse.h>

@interface VoterToken : PFObject<PFSubclassing>

@property(nonatomic, strong) NSString *tokenId;

@property(nonatomic, strong) NSDate *expires;

@end

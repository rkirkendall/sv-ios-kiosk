//
//  Blockchain.h
//  Kiosk
//
//  Created by Ricky Kirkendall on 12/26/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "Candidate.h"
#import "ElectionManager.h"

#define kAddressKey @"address"
#define kPublicKey @"public"
#define kPrivateKey @"private"

@interface Blockchain : NSObject

+ (void) CreateOrGetBTCAddressForElectionID:(NSString *)electionID withCompletion:(void (^)(NSDictionary *address))completion;

+ (void) CastVotes;

+ (AFHTTPRequestOperation *) SendVote:(NSDictionary *)voteDict withCompletion:(void (^)(BOOL success, NSString *toAddress))completion;

@end

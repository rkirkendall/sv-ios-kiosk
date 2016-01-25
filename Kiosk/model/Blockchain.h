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

+ (void) CreateOrGetBTCAddressForElection:(Election *)election withCompletion:(void (^)(NSDictionary *address))completion;

+ (void) CastVotesWithCompletion:(void (^)(BOOL success))completion;

+ (void) RefundFromCandidates:(void (^)(BOOL success))completion;

+ (void) GetSenderAddressFromTx:(NSString *)txHash withCompletion:(void (^)(BOOL success, NSString *sender))completion;
+ (void) FirstTxForAddress:(NSString *)address withCompletion:(void (^)(BOOL success, NSString *txHash))completion;


@end

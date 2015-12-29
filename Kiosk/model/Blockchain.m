//
//  Blockchain.m
//  Kiosk
//
//  Created by Ricky Kirkendall on 12/26/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import "Blockchain.h"
#import <AFNetworking/AFNetworking.h>
#import "Vote.h"
#define kElectionAddresses @"kElectionAddresses"

@implementation Blockchain


+ (AFHTTPRequestOperation *) SendVote:(NSDictionary *)voteDict withCompletion:(void (^)(BOOL success, NSString *toAddress))completion{
    
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableURLRequest* request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:@"https://api.blockcypher.com/v1/btc/main/txs/f854aebae95150b379cc1187d848d58225f3c4157fe992bcd166f58bd5063449" parameters:nil error:NULL];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request
                                                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                             NSLog(@"HTTP Response Status Code: %ld", [operation.response statusCode]);
                                                                             NSDictionary *respDict = (NSDictionary *)responseObject;
                                                                             NSString *toAddress = respDict[@"to_address"];
                                                                             if (!toAddress) {
                                                                                 // For testing
                                                                                 toAddress = @"";
                                                                             }
                                                                             NSLog(@"HTTP Response Body: %@", responseObject);
                                                                             completion(YES, toAddress);
                                                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                             NSLog(@"HTTP Request failed: %@", error);
                                                                             completion(NO, @"");
                                                                         }];
    
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    return operation;
}

+ (void) CastVotesWithCompletion:(void (^)(BOOL success))completion{
    NSMutableArray *votesToCast = [[[NSUserDefaults standardUserDefaults] objectForKey:kVoteStore] mutableCopy];
    NSMutableArray *toRemove = [NSMutableArray array];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    Election *current = [[ElectionManager Manager] currentElection];
    
    // Get kiosk BTC Address
    
    [Blockchain CreateOrGetBTCAddressForElectionID:current.objectId withCompletion:^(NSDictionary *address) {
        
        
        // Queue up vote networking operations
        
        NSMutableArray *mutableOperations = [NSMutableArray array];
        for (NSDictionary *voteDict in votesToCast) {
            AFHTTPRequestOperation *operation = [Blockchain SendVote:voteDict withCompletion:^(BOOL success, NSString *toAddress) {
                
                // Mark successes as completed
                
                if (success) {
                    [toRemove addObject:toAddress];
                }
            }];
            
            [mutableOperations addObject:operation];
        }
        
        NSArray *voteOps = [AFURLConnectionOperation batchOfRequestOperations:mutableOperations progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
            
            // As network operations return, remove the votes from cache
            
            NSLog(@"%lu of %lu complete", (unsigned long)numberOfFinishedOperations, (unsigned long)totalNumberOfOperations);
            
            NSInteger count = 0;
            NSMutableIndexSet *ixToRemove = [[NSMutableIndexSet alloc]init];
            for (NSString *toAdd in toRemove) {
                for (NSDictionary *vote in votesToCast) {
                    if ([vote[kCandidateAddress] isEqualToString:toAdd]) {
                        [ixToRemove addIndex:count];
                    }
                    count ++;
                }
                count = 0;
            }
            
            [votesToCast removeObjectsAtIndexes:ixToRemove];
            [toRemove removeAllObjects];
            [[NSUserDefaults standardUserDefaults] setObject:votesToCast forKey:kVoteStore];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        } completionBlock:^(NSArray *operations) {
            
            
            // Batching would be nice here...
            
            // If any votes remained cached, there was a networking error and the remaining votes need
            // to be resubmitted.
            
            NSLog(@"All operations in batch complete");
            NSArray *remaining = [[NSUserDefaults standardUserDefaults] objectForKey:kVoteStore];
            NSLog(@"Remaining votes: %lu",remaining.count);
            
            if (remaining.count == 0) {
                completion(YES);
            }else{
                completion(NO);
            }
            
        }];
        
        [manager.operationQueue addOperations:voteOps waitUntilFinished:NO];
    }];    
    
}

+ (void) CreateOrGetBTCAddressForElectionID:(NSString *)electionID withCompletion:(void (^)(NSDictionary *address))completion{
    NSMutableDictionary *addresses = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:kElectionAddresses] mutableCopy];
    
    if (!addresses) {
        addresses = [NSMutableDictionary dictionary];
    }
    
    NSDictionary *address = addresses[electionID];
    
    if (address) {
        
        completion(address);
        
    }else{
        // Create manager
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        // Body
        NSURL* URL = [NSURL URLWithString:@"https://api.blockcypher.com/v1/btc/main/addrs"];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
        [request setHTTPMethod:@"POST"];
        
        // Fetch Request
        AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request
                                                                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                                 
                                                                                 NSDictionary *resp = (NSDictionary *)responseObject;
                                                                                 addresses[electionID] = resp;
                                                                                 
                                                                                 [[NSUserDefaults standardUserDefaults] setObject:addresses forKey:kElectionAddresses];
                                                                                 [[NSUserDefaults standardUserDefaults] synchronize];
                                                                                 completion(resp);
                                                                                 
                                                                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                 NSLog(@"HTTP Request failed: %@", error);
                                                                             }];
        
        [manager.operationQueue addOperation:operation];
    }

}


@end

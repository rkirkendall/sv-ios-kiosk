//
//  Blockchain.m
//  Kiosk
//
//  Created by Ricky Kirkendall on 12/26/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import "Blockchain.h"
#import <AFNetworking/AFNetworking.h>
#import <CoreBitcoin/CoreBitcoin.h>
#import "Vote.h"
#define kElectionAddresses @"kElectionAddresses"

@implementation Blockchain


+ (void) CreateVoteTxWithCompletion:(void (^)(BOOL success, NSDictionary *transaction))completion{
    Election *current = [[ElectionManager Manager] currentElection];
    NSMutableDictionary *addresses = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:kElectionAddresses] mutableCopy];
    NSDictionary *address = addresses[current.objectId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *kioskAddress = address[kAddressKey];
    NSMutableArray *outputs = [[NSMutableArray alloc]init];
    
    NSMutableArray *votesToCast = [[[NSUserDefaults standardUserDefaults] objectForKey:kVoteStore] mutableCopy];
    for (NSDictionary *voteDict in votesToCast) {
        NSString *toAddress = voteDict[kCandidateAddress];
        NSMutableDictionary *mutDict = [[NSMutableDictionary alloc]init];
        mutDict[@"value"] = @2000;
        mutDict[@"addresses"] = @[toAddress];
        [outputs addObject:mutDict];
        
    }
    
    NSArray *inputs = @[
                        @{
                            @"addresses": @[
                                    kioskAddress
                                    ]
                            }
                        ];
    NSDictionary* bodyObject = @{
                                 @"inputs": inputs,
                                 @"outputs": outputs
                                 };
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"https://api.blockcypher.com/v1/btc/main/txs/new" parameters:bodyObject error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request
                                                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                             NSLog(@"HTTP Response Status Code: %ld", [operation.response statusCode]);
                                                                             NSLog(@"HTTP Response Body: %@", responseObject);
                                                                             NSDictionary *trans = (NSDictionary *)responseObject;
                                                                             if ([operation.response statusCode] >= 400) {
                                                                                 completion(NO, nil);
                                                                             }else{
                                                                                 completion(YES, trans);
                                                                                 
                                                                             }
                                                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                             NSLog(@"Problem getting blank transaction");
                                                                             completion(NO, nil);
                                                                         }];
    
    [manager.operationQueue addOperation:operation];

}

+(NSDictionary *) SignVoteTX:(NSDictionary *)transaction{
    NSString *toSignHash = transaction[@"tosign"][0];
    NSMutableDictionary *mutCopy = [transaction mutableCopy];
    
    Election *current = [[ElectionManager Manager] currentElection];
    NSMutableDictionary *addresses = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:kElectionAddresses] mutableCopy];
    NSDictionary *address = addresses[current.objectId];
    
    // Put kiosk's private key for current election here
    NSString *privKey = address[kPrivateKey];
    
    // Put kiosk's public key for current election here
    NSString *pubkey = address[kPublicKey];
    
    NSData *privKeyFromHex = BTCDataFromHex(privKey);
    BTCKey *myKey = [[BTCKey alloc]initWithPrivateKey:privKeyFromHex];
    
    NSString *hashHex = toSignHash;
    NSData *hashData = BTCDataFromHex(hashHex);
    
    NSData *sigForHash = [myKey signatureForHash:hashData];
    
    NSString *sigString = BTCHexFromData(sigForHash);
    NSLog(@"%@",sigString);
    
    mutCopy[@"signatures"] = @[sigString];
    
    // Put pub key
    mutCopy[@"pubkeys"] = @[pubkey];
    
    return mutCopy;
}

+ (void) SendSignedVoteTx:(NSDictionary *)trans withCompletion:(void (^)(BOOL success, NSDictionary *transaction))completion{
    // Send Transaction (POST https://api.blockcypher.com/v1/bcy/test/txs/send)
    
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // JSON Body
    NSDictionary* bodyObject = trans;
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"https://api.blockcypher.com/v1/btc/main/txs/send" parameters:bodyObject error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request
                                                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                             
                                                                             completion(YES, (NSDictionary *)responseObject);
                                                                             
                                                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                             NSLog(@"HTTP Request failed: %@", error);
                                                                             completion(NO, nil);
                                                                         }];
    
    [manager.operationQueue addOperation:operation];
}


+ (void) CastVotesWithCompletion:(void (^)(BOOL success))completion{
    [Blockchain CreateVoteTxWithCompletion:^(BOOL success, NSDictionary *transaction) {
        if (success) {
            NSDictionary *signedTx = [Blockchain SignVoteTX:transaction];
            [Blockchain SendSignedVoteTx:signedTx withCompletion:^(BOOL success, NSDictionary *transaction) {
                [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:kVoteStore];
                [[NSUserDefaults standardUserDefaults] synchronize];
                completion(success);
            }];
        }else{
            completion(success);
        }
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

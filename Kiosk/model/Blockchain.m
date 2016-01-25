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
#import "Kiosk.h"
#define kElectionAddresses @"kElectionAddresses"
#define kBTC_TX_AMT @5000

@implementation Blockchain

+ (void) RefundFromCandidates:(void (^)(BOOL success))completion{
    
    // Get address for funding account
    [Blockchain CreateOrGetBTCAddressForElection:[[ElectionManager Manager] currentElection] withCompletion:^(NSDictionary *address) {
        NSString *addressString = address[kAddressKey];
        [Blockchain FirstTxForAddress:addressString withCompletion:^(BOOL success, NSString *txHash) {
            if (success && txHash && ![txHash isEqualToString:@""]) {
                [Blockchain GetSenderAddressFromTx:txHash withCompletion:^(BOOL success, NSString *sender) {
                    if (success && sender && ![sender isEqualToString:@""]) {
                        NSLog(@"Sender: %@", sender);
                    }
                }];
            }
        }];
    }];
    
    
    // Get all the candidate addresses and private keys
    
    // Get balance for each account
    
    
    // Create a transaction with multiple inputs (cand. addresses) in to one output (funding account)
}

+ (void) GetSenderAddressFromTx:(NSString *)txHash withCompletion:(void (^)(BOOL success, NSString *sender))completion{
    // Get Tx Info (GET https://api.blockcypher.com/v1/btc/main/txs/0c83c8321537a7c79dc6214788944ba6cd5ea76f0594453b6251fcf1856f2e4b)
    
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // Create request
    NSString *urlString = [NSString stringWithFormat:@"https://api.blockcypher.com/v1/btc/main/txs/%@",txHash];
    NSMutableURLRequest* request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:urlString parameters:nil error:NULL];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request
                                                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                             if (responseObject) {
                                                                                 NSDictionary *input1 = responseObject[@"inputs"][0];
                                                                                 NSString *address = input1[@"addresses"][0];
                                                                                 completion(YES, address);
                                                                             }else{
                                                                                 completion(NO, nil);
                                                                             }
                                                                             
                                                                             NSLog(@"HTTP Response Status Code: %ld", [operation.response statusCode]);
                                                                             NSLog(@"HTTP Response Body: %@", responseObject);
                                                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                             completion(NO, nil);
                                                                             NSLog(@"HTTP Request failed: %@", error);
                                                                         }];
    
    [manager.operationQueue addOperation:operation];
    

}

+ (void) FirstTxForAddress:(NSString *)address withCompletion:(void (^)(BOOL success, NSString *txHash))completion{
    
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // Create request
    NSString *urlString = [NSString stringWithFormat:@"https://api.blockcypher.com/v1/btc/main/addrs/%@",address];
    
    NSMutableURLRequest* request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:urlString parameters:nil error:NULL];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request
                                                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                             
                                                                             if (responseObject) {
                                                                                 NSArray *txsRefs= responseObject[@"txrefs"];
                                                                                 if (!txsRefs) {
                                                                                     completion(NO,nil);
                                                                                     return;
                                                                                 }
                                                                                 //sorted: newest first
                                                                                 NSDictionary *firstTx = [txsRefs lastObject];
                                                                                 NSString *txHash = firstTx[@"tx_hash"];
                                                                                 completion(YES, txHash);
                                                                             }else{
                                                                                 completion(NO, nil);
                                                                             }
                                                                             
                                                                             NSLog(@"HTTP Response Status Code: %ld", [operation.response statusCode]);
                                                                             NSLog(@"HTTP Response Body: %@", responseObject);
                                                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                             NSLog(@"HTTP Request failed: %@", error);
                                                                             completion(NO, nil);
                                                                         }];
    
    [manager.operationQueue addOperation:operation];

}

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
        mutDict[@"value"] = kBTC_TX_AMT;
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


+ (void) CreateOrGetBTCAddressForElection:(Election *)election withCompletion:(void (^)(NSDictionary *address))completion{
    NSMutableDictionary *addresses = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:kElectionAddresses] mutableCopy];
    
    if (!addresses) {
        addresses = [NSMutableDictionary dictionary];
    }
    
    NSDictionary *address = addresses[election.objectId];
    
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
                                                                                 
                                                                                 if (responseObject) {
                                                                                     NSDictionary *resp = (NSDictionary *)responseObject;
                                                                                     //Send kiosk object
                                                                                     Kiosk *toRegister = [Kiosk object];
                                                                                     toRegister.election = election;
                                                                                     [toRegister setBtcAddress:resp[kAddressKey]];
                                                                                     [toRegister setPublicKey:resp[kPublicKey]];
                                                                                     NSString *udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
                                                                                     [toRegister setKioskId:udid];
                                                                                     [toRegister saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                                                                         
                                                                                         if (!error) {
                                                                                             addresses[election.objectId] = resp;
                                                                                             [[NSUserDefaults standardUserDefaults] setObject:addresses forKey:kElectionAddresses];
                                                                                             [[NSUserDefaults standardUserDefaults] synchronize];
                                                                                             completion(resp);
                                                                                             
                                                                                         }else{
                                                                                             completion(nil);
                                                                                         }
                                                                                     }];
                                                                                 }
                                                                                 
                                                                                 
                                                                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                 NSLog(@"HTTP Request failed: %@", error);
                                                                             }];
        
        [manager.operationQueue addOperation:operation];
    }

}


@end

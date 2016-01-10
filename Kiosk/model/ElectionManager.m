//
//  ElectionManager.m
//  Kiosk
//
//  Created by Ricky Kirkendall on 12/5/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import "ElectionManager.h"

@implementation ElectionManager

+ (id)Manager {
    static ElectionManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {}
    return self;
}

- (void)validateVoterToken:(NSString *)tokenId withCompletion:(void (^)(BOOL valid))completion{
    VoterToken *vt = [VoterToken objectWithoutDataWithObjectId:tokenId];
    [vt fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (error || !object.objectId) {
            completion(NO);
        }else{
            NSDate *now = [NSDate date];
            if ([vt.expires laterDate:now] == now) {
                completion(NO);
            }else{
                completion(YES);
            }
        }
    }];
}

- (void)joinElectionWithId:(NSString *)eid withCompletion:(void (^)(BOOL valid))completion{
    self.currentElection = [Election objectWithoutDataWithObjectId:eid];
    
    [self.currentElection fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (error || !object) {
            completion(NO);
        }
        NSLog(@"%@",self.currentElection.name);
        
        PFQuery *partyQuery = [PFQuery queryWithClassName:@"Party"];
        [partyQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            self.currentElection.parties = objects;
            
            PFQuery *officeQuery = [PFQuery queryWithClassName:@"Office"];
            [officeQuery whereKey:@"election" equalTo:self.currentElection];
            [officeQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                NSArray *unsortedOffices = objects;
                NSArray *sortedOffices = [unsortedOffices sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                    NSNumber *first = [(Office*)a order];
                    NSNumber *second = [(Office*)b order];
                    return [first compare:second];
                }];
                self.currentElection.offices = sortedOffices;
                PFQuery *candidateQuery = [PFQuery queryWithClassName:@"Candidate"];
                [candidateQuery whereKey:@"election" equalTo:self.currentElection];
                [candidateQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                    self.currentElection.candidates = objects;
                    completion(YES);
                }];
                
            }];
        }];
        
    }];
}

@end

//
//  ElectionManager.m
//  DemoApp
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

- (void)joinElectionWithId:(NSString *)eid withCompletion:(void (^)(BOOL valid))completion{
    self.currentElection = [Election objectWithoutDataWithObjectId:eid];
    [self.currentElection fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (error || !object) {
            completion(NO);
        }
        NSLog(@"%@",self.currentElection.name);
        completion(YES);
    }];
}

@end

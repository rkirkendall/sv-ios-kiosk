//
//  ElectionManager.h
//  DemoApp
//
//  Created by Ricky Kirkendall on 12/5/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Election.h"
@interface ElectionManager : NSObject

@property (nonatomic, strong) Election *currentElection;

+ (id)Manager;

- (void)joinElectionWithId:(NSString *)eid withCompletion:(void (^)(BOOL valid))completion;

@end

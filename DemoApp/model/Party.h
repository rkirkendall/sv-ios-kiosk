//
//  Party.h
//  DemoApp
//
//  Created by Ricky Kirkendall on 12/12/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import <Parse/Parse.h>

@interface Party : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *initials;
@property (nonatomic, strong) NSString *name;

@end

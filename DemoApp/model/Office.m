//
//  Office.m
//  DemoApp
//
//  Created by Ricky Kirkendall on 12/12/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import "Office.h"

@implementation Office

@dynamic limit;
@dynamic name;
@dynamic order;
@dynamic election;

+ (NSString *)parseClassName {
    return @"Office";
}

+ (void)load {
    [super load];
    [self registerSubclass];
}

@end

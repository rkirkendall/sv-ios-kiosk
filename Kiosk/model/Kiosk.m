//
//  Kiosk.m
//  Kiosk
//
//  Created by Ricky Kirkendall on 12/12/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import "Kiosk.h"

@implementation Kiosk
@dynamic btcAddress;
@dynamic election;
@dynamic kioskId;
@dynamic publicKey;

+ (NSString *)parseClassName {
    return @"Kiosk";
}

+ (void)load {
    [super load];
    [self registerSubclass];
}

@end

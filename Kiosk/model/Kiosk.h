//
//  Kiosk.h
//  Kiosk
//
//  Created by Ricky Kirkendall on 12/12/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import <Parse/Parse.h>
#import "Election.h"
@interface Kiosk : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *btcAddress;
@property (nonatomic, strong) Election *election;
@property (nonatomic, strong) NSString *kioskId;
@property (nonatomic, strong) NSString *publicKey;

@end

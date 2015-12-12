//
//  APIKey.h
//  DemoApp
//
//  Created by Ricky Kirkendall on 12/12/15.
//  Copyright © 2015 SureVoting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIKey : NSObject


+ (NSString *)ParseClientKey;
+ (NSString *)ParseAppId;
+ (NSString *)BlockCypherToken;

@end

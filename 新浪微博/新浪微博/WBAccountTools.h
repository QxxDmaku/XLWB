//
//  WBAccountTools.h
//  新浪微博
//
//  Created by qsx on 15-8-9.
//  Copyright (c) 2015年 qsx_one. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBAccountModule.h"

@interface WBAccountTools : NSObject
+(void)saveAccount:(WBAccountModule*)account;
+(WBAccountModule*) account;
@end

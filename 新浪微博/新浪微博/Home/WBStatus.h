//
//  WBStatus.h
//  MJexcepiionTest
//
//  Created by qsx on 15-8-27.
//  Copyright (c) 2015年 qsx_one. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBUser.h"


@interface WBStatus : NSObject
@property(nonatomic,copy)NSString* idstr;
@property(nonatomic,copy)NSString* text;
@property(nonatomic,strong)WBUser* user;
@end

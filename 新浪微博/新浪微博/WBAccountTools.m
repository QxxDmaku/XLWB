//
//  WBAccountTools.m
//  新浪微博
//
//  Created by qsx on 15-8-9.
//  Copyright (c) 2015年 qsx_one. All rights reserved.
//

#import "WBAccountTools.h"
#import "WBAccountModule.h"

/**
 *  返回账户信息在沙盒中的存储的位置
 *  @return NSString*
 */
#define AccountPath  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]

@implementation WBAccountTools

/**
 *  存储账号
 *
 *  @param account 得到的字典转换后的模型
 */
+(void)saveAccount:(WBAccountModule*)account{
       
    [NSKeyedArchiver archiveRootObject:account toFile:AccountPath];
    NSLog(@"save 成功");
}
/**
 *  取出账号，在返回账号之前先判断账号是否过期
 *
 *  @return 账号模型
 */
+(WBAccountModule*) account{
    WBAccountModule* account = [NSKeyedUnarchiver unarchiveObjectWithFile:AccountPath];
    
    //得到当前的时间
    NSDate* now = [NSDate date];
    
    //得到 授权时间 和 过期时间
    long long  expires_in = [account.expires_in longLongValue];
    //计算出了过期的时间
    NSDate* expiresTime = [account.createTime dateByAddingTimeInterval:expires_in];
    
    
    //  expiresTime 《=  now 就说明时间已经过期了
    /** comper返回的三个值
     *  NSOrderedAscending = -1L,   升序  右边大于左边
        NSOrderedSame,              一样
        NSOrderedDescending         降序  左边大于右边
     */
    NSComparisonResult* resault = [expiresTime compare:now];
    if (resault != NSOrderedDescending) {
        return nil;
    }
    
    
    //NSLog(@"%@  %@", expiresTime  , now);
    return  account;
}

@end

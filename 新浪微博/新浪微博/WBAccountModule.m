//
//  WBAccountModule.m
//  新浪微博
//
//  Created by qsx on 15-8-9.
//  Copyright (c) 2015年 qsx_one. All rights reserved.
//

#import "WBAccountModule.h"

@implementation WBAccountModule
//构造方法
+(instancetype)accountWithDict:(NSDictionary*) dict{
    

    WBAccountModule* account = [[WBAccountModule alloc] init];
    account.access_token = dict[@"access_token"];
    account.expires_in = dict[@"expires_in"];
    account.uid  =  dict[@"uid"];
    /**
     *  createTime 属性是得到 token的时间 ，在初始化modle的时候 才赋值存储
     */
    
    NSDate* createTime = [NSDate date];
    account.createTime = createTime;
    
    return account;
}

//说明这个对象的哪一个方法要存进沙盒
-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.access_token forKey:@"access_token"];
    [coder encodeObject:self.expires_in forKey:@"expires_in"];
    [coder encodeObject:self.uid forKey:@"uid"];
    [coder encodeObject:self.createTime forKey:@"createTime"];
    [coder encodeObject:self.name forKey:@"name"];

}

// 取出时说明属性该怎样解析
-(id)initWithCoder:(NSCoder *)aDecoder{
    //构造方法要调用父类的构造方法
    if (self = [super init]) {
        self.access_token = [aDecoder decodeObjectForKey:@"access_token"];
        self.expires_in = [aDecoder decodeObjectForKey:@"expires_in"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.createTime = [aDecoder decodeObjectForKey:@"createTime"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    return  self;
}

@end

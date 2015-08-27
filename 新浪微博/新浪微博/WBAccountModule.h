//
//  WBAccountModule.h
//  新浪微博
//
//  Created by qsx on 15-8-9.
//  Copyright (c) 2015年 qsx_one. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBAccountModule : NSObject<NSCoding>
/** String access_token 接口授权后的 access_token */
@property(nonatomic,copy) NSString* access_token;
/** String expires_in access_token的生命周期 单位是 秒*/
@property(nonatomic,copy) NSNumber* expires_in;
/** String uid  当前用户授权的  UID */
@property(nonatomic,copy) NSString*  uid;
@property(nonatomic,strong) NSDate*  createTime;
/**
 *  存储请求之后得到的昵称信息 ， 等到下一次使用
 */
@property(nonatomic,copy)NSString* name;
+(instancetype)accountWithDict:(NSDictionary*) dict;
@end

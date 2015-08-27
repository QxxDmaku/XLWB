//
//  WBitemTools.m
//  新浪微博
//
//  Created by qsx on 15-7-30.
//  Copyright (c) 2015年 qsx_one. All rights reserved.
//

#import "WBitemTools.h"

@implementation WBitemTools 
+(UIBarButtonItem*)itemWithTarget:(id)target action:(SEL)action image:(NSString*)image heighImage:(NSString*)heighimage{
    //1、设置左边的按钮
    UIButton* buttonview = [UIButton buttonWithType:UIButtonTypeCustom];
    //设置不同状态下的背景
    [buttonview setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [buttonview setBackgroundImage:[UIImage imageNamed:heighimage] forState:UIControlStateHighlighted];
    //设置大小
    CGSize sizeleft = buttonview.currentBackgroundImage.size;
    buttonview.frame = CGRectMake(0, 0, sizeleft.width, sizeleft.height);
    //设置监听事件
    [buttonview addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonviewleft];
    return [[UIBarButtonItem alloc] initWithCustomView:buttonview];
}


@end

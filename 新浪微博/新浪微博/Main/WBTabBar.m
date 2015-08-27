//
//  WBTabBar.m
//  新浪微博
//
//  Created by qsx on 15-8-3.
//  Copyright (c) 2015年 qsx_one. All rights reserved.
//

#import "WBTabBar.h"

@interface WBTabBar ()
@property (nonatomic,weak) UIButton* plasbutton;
@end

@implementation WBTabBar

-(UIButton *)plasbutton{
    if (_plasbutton == nil) {
        UIButton* button = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateNormal];
    
//这个方法没有啊        [button sizeThatFit];
        _plasbutton = button;
        
        [self addSubview:_plasbutton];
    
    }
    return _plasbutton;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //NSLog(@"子控件是 %@",self.subviews);
    
    
    CGFloat W =  self.bounds.size.width;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = W / (self.items.count + 1);  // 得到子控件的数字之后 还要加一个一
    CGFloat btnH = self.bounds.size.height;

    int i = 0;
    
//    // 调整系统上面的 tababr 的 位置
    for (UIView* tabbar in self.subviews) {
        if ([tabbar isKindOfClass:NSClassFromString(@"UITabBarButton")])  {
            if (i == 2) {
                i = 3;
            }
            btnX = i * btnW;
            tabbar.frame  =  CGRectMake(btnX, btnY, btnW,btnH);
            
            i ++;
            //NSLog(@"%@",tabbar);
        }
    }
    
    _plasbutton.center = CGPointMake(W * 0.5, btnH * 0.5);
    _plasbutton.bounds = CGRectMake(0, 0, self.plasbutton.currentBackgroundImage.size.width,  self.plasbutton.currentBackgroundImage.size.height);
    
    
    
    
}

@end

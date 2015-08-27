//
//  WBTitleButton.m
//  新浪微博
//
//  Created by qsx on 15-8-25.
//  Copyright (c) 2015年 qsx_one. All rights reserved.
//
//  标题的按钮

#import "WBTitleButton.h"
#import "UIView+Extension.h"

@implementation WBTitleButton


-(void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    [self sizeToFit];
}
-(void)setImage:(UIImage *)image forState:(UIControlState)state{
    [super setImage:image forState:state];
    [self sizeToFit];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //设置图片居中，可以防止图片 压缩
        self.imageView.contentMode = UIViewContentModeCenter;
        
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
        
    }
    return self;
}

//在专门设置 子控件的方法中同时设置 image 和 title
-(void)layoutSubviews{
    
    //如果仅仅是在 设置 子控件的 位置 x 、 y的时候 ，就是用  layoutSubviews
    //需要设置 位置和大小的时候 ， 就要使用 下面的两个 方法
    
    [super layoutSubviews];
    self.titleLabel.x = self.imageView.x;
    
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame);
    
}



//      下面两个方法在自定义设置的时候，在计算距离的时候，会自己调用自己，这个时候会造成死循环
//
///**
// *   设置按钮内部中image 的frame
// *
// *  @param contentRect 按钮的 bounds
// *
// *  @return
// */
//-(CGRect)imageRectForContentRect:(CGRect)contentRect{
//    CGFloat x = 0;
//    CGFloat y = 0 ;
//    CGFloat width = 0;
//    CGFloat height = 0;
//    return CGRectMake(x,y, width, height);
//}
///**
// *  设置按钮中的 title 的 frame
// *
// *  @param contentRect 按钮的 bounds
// *
// *  @return
// */
//-(CGRect)titleRectForContentRect:(CGRect)contentRect{
//    
//    NSMutableDictionary* attrs = [NSMutableDictionary dictionary];
//    attrs[NSFontAttributeName] = self.titleLabel.font;
//    
//    CGFloat x = 0;
//    CGFloat y = 0 ;
//    CGFloat width = [self.currentTitle sizeWithAttributes:attrs].width;
//    CGFloat height = 0;
//    return CGRectMake(x, y, width, height);
//
//}

@end

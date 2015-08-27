//
//  WBNavigationController.m
//  新浪微博
//
//  Created by qsx on 15-7-30.
//  Copyright (c) 2015年 qsx_one. All rights reserved.
//

#import "WBNavigationController.h"
#import "WBitemTools.h"

@implementation WBNavigationController


//设置 navigation 的文字的格式
+(void)initialize{
    //设置可用的时候的 样式
    UIBarButtonItem* item  = [UIBarButtonItem appearance];
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    dictionary[NSForegroundColorAttributeName] = [UIColor orangeColor];
    dictionary[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    [item setTitleTextAttributes:dictionary forState:UIControlStateNormal];
    
    //设置不可用时候的样式
    NSMutableDictionary* disabledictionary = [NSMutableDictionary dictionary];
    disabledictionary[NSForegroundColorAttributeName] = [UIColor redColor];
    //dictionary[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    [item setTitleTextAttributes:disabledictionary forState:UIControlStateDisabled];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
        //在这里设置返回的箭头，会覆盖默认的返回键
    
    //3、可以根据栈中的push进去的个数来判断 当前的viewController是不是根控制器
    if(self.viewControllers.count > 0){ // 这个时候该push进来的控制器不是第一个，这个时候这上面加上按钮
    
    //4、在这里设置，把传入的 view 的tarbar隐藏
    viewController.hidesBottomBarWhenPushed  = YES;
    //1、initWithCustomView 使用自定的view 放在 navigation 的左上角
    viewController.navigationItem.leftBarButtonItem = [WBitemTools itemWithTarget:self action:@selector(back) image:@"navigationbar_back" heighImage:@"navigationbar_back_highlighted"];
    viewController.navigationItem.rightBarButtonItem= [WBitemTools itemWithTarget:self action:@selector(more) image:@"navigationbar_more" heighImage:@"navigationbar_more_highlighted"];
    }
    
    //设置好之后 才push进去 ，这样的话 前面的if中的值 要大于 0 。、、第一次执行的时候就是 0 ，第一次执行完之后才是1
    [super pushViewController:viewController animated:animated];


}
-(void)back{
    [self popViewControllerAnimated:YES ];
    
}
-(void)more{
    [self popToRootViewControllerAnimated:YES ];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

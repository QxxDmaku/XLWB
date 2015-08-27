//
//  WBMianViewController.m
//  新浪微博
//
//  Created by qsx on 15-7-28.
//  Copyright (c) 2015年 qsx_one. All rights reserved.
//

#import "WBMianViewController.h"
#import "WBTabBar.h"


@interface WBMianViewController ()

@end

@implementation WBMianViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    WBTabBar* tabbar = [[WBTabBar alloc] initWithFrame:self.tabBar.frame];
    // self 的 tabbar 的属 只读的 所以要使用 kvc 的方式来赋值
    [self setValue:tabbar forKey:@"tabBar"];
    
     
    
    // Do any additional setup after loading the view.
    //3、设置子控制器
    WBHomeViewController* homeview = [[WBHomeViewController alloc] init];
    [self addChildVcWith:homeview Title:@"首页" image:@"tabbar_home" selectImage:@"tabbar_home_selected"];
    
    WBMessageViewController* messageView = [[WBMessageViewController alloc] init];
    [self addChildVcWith:messageView Title:@"消息"  image:@"tabbar_message_center" selectImage:@"tabbar_message_center_selected"];
    
    WBDiscoverViewController* discoverView = [[WBDiscoverViewController alloc] init];
    [self addChildVcWith:discoverView Title:@"发现" image:@"tabbar_discover" selectImage:@"tabbar_discover_selected"];
    
    WBProfileViewController* profileView = [[WBProfileViewController alloc] init];
    [self addChildVcWith:profileView Title:@"我" image:@"tabbar_profile" selectImage:@"tabbar_profile_selected"];


}

-(void)viewDidAppear:(BOOL)animated{
    //NSLog(@"%@",self.tabBar.subviews);
}

-(void)addChildVcWith:(UIViewController*)childVie Title:(NSString*)title image:image selectImage:selectImage{
    
    //0、设置自控制器的文字
  
    //childVie.tabBarItem.title = title;
    //childVie.navigationItem.title = title;
      // 下面的这一句 可以上面的两句 ， 同时设置 tabbartitle的文字 和 navicatetitle 的文字
      childVie.title = title;
    
    //1、添加背景 随机的背景
    childVie.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
   

    //2、  设置图片的样式
    // 未选中样式
    childVie.tabBarItem.image = [UIImage imageNamed:image];
    // 选中的样式
    childVie.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //3、 设置文字的样式
    //未选中的时候的样式，默认是灰色的
    NSMutableDictionary* textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    [childVie.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    //选中之后的样式，默认是蓝色的
    NSMutableDictionary* selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVie.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    
    //传进来的自控制器先放到一个导航栏控制器中，再把这个拥有子控制器的导航栏就控制器放到tabbar中去
    //使用自定义的 NavicationController
    
    WBNavigationController* navi = [[WBNavigationController alloc] initWithRootViewController:childVie];
    [self addChildViewController:navi];
}


@end

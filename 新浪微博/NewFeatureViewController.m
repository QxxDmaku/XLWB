//
//  NewFeatureViewController.m
//  新浪微博
//
//  Created by qsx on 15-7-31.
//  Copyright (c) 2015年 qsx_one. All rights reserved.
//

#import "NewFeatureViewController.h"
#import "UIView+Extension.h"
#import "WBMianViewController.h"

@interface NewFeatureViewController ()<UIScrollViewDelegate>
#define  NewFeatureViewcount 4
@property(nonatomic,weak)  UIPageControl* pagecontrol;
@end

@implementation NewFeatureViewController

- (void)viewDidLoad {
     [super viewDidLoad];
    
    
     //1、创建一个 scrollview 来显示 所有图片
    UIScrollView* scrollview = [[UIScrollView alloc] init];
    scrollview.frame = self.view.bounds;
    [self.view addSubview:scrollview];
    
    
    //2、添加图片
    CGFloat scrollW = scrollview.width;
    CGFloat scrollH = scrollview.height;
    for(int i = 0 ; i < NewFeatureViewcount ; i++){
        UIImageView* imageview = [[UIImageView alloc] init];
        imageview.height = scrollH;
        imageview.width  = scrollW;
        imageview.y = 0;
        imageview.x = i * scrollW;
        NSString* image = [NSString stringWithFormat:@"new_feature_%d", i + 1];
        imageview.image = [UIImage imageNamed:image];
        
        if(i == (NewFeatureViewcount - 1)){
            [self setupLastView:imageview];
           
        }
        
        [scrollview addSubview:imageview];
        
       
    }
    
    // scrollview 中可能会存在系统默认的子控件 scrollview的lastobj,不是自定义的最后一个 view
    //scrollview last
    
    //3、设置scroview的其他属性
    //设置滚动的范围
    scrollview.contentSize = CGSizeMake(NewFeatureViewcount * scrollview.width, 0);
    scrollview.bounces = NO;//弹簧特性设置为 no
    scrollview.showsHorizontalScrollIndicator = NO;//水平方向的滚动条消失
    scrollview.delegate = self;
    
    
    //4、设置 pageview
    UIPageControl* pagecontrol = [[UIPageControl alloc] init];
    pagecontrol.numberOfPages = NewFeatureViewcount;
   
   // pagecontrol.backgroundColor = [UIColor redColor];
    pagecontrol.center = CGPointMake(scrollW * 0.5, scrollH * 0.90);
   
    
    pagecontrol.currentPageIndicatorTintColor = [UIColor colorWithRed:arc4random_uniform(253)/255.0 green:arc4random_uniform(0)/255.0 blue:arc4random_uniform(0)/255.0 alpha:1.0];
    pagecontrol.pageIndicatorTintColor = [UIColor colorWithRed:arc4random_uniform(164)/255.0 green:arc4random_uniform(164)/255.0 blue:arc4random_uniform(164)/255.0 alpha:1.0];

    
    [self.view  addSubview:pagecontrol];
    
    //不设置父控件的尺寸的时候，子控件也会显示的，但是不会响应事件，事件是传递到父控件之后才会发给子空间
    
    self.pagecontrol = pagecontrol;
}


-(void)setupLastView:(UIImageView*)lastimageview{
    
    //iamge默认是不允许交互的，在这里设置为交互
    lastimageview.userInteractionEnabled = YES;
    
    
    
    UIButton* shareBtn = [[UIButton alloc] init];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    [shareBtn setTitle:@"分享给大家" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.width = 150;
    shareBtn.height= 30;
    shareBtn.center = CGPointMake(lastimageview.width * 0.5, lastimageview.height *0.65);
    [lastimageview addSubview:shareBtn];
    
    //top left button  right
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0,10,0,0);
    
    //设置内边距
//    shareBtn.titleEdgeInsets;     只影响 title
//    shareBtn.imageEdgeInsets;     值影响 image
//    shareBtn.contentEdgeInsets;   两个都影响
    
    UIButton* startBtn = [[UIButton alloc] init];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    [startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];

    [startBtn setTitle:@"开始微博" forState:UIControlStateNormal];
    startBtn.size = startBtn.currentBackgroundImage.size;
    startBtn.center = CGPointMake(lastimageview.width * 0.5, lastimageview.height *0.75);
    [lastimageview addSubview:startBtn];

    //程序启动会加载Default的图片
    //3.5inch 非retain屏 Default.png
    //3.5inch retain 屏  Default@2.png
    //4.0inch retain屏   Default568h@2.png
}

-(void)share:(UIButton*)shareBtn{
    shareBtn.selected = !shareBtn.isSelected;
}
-(void)start{
    /*
     切换界面的方法
     1.push: push是依赖于navigationcontraller的;控制器的切换是可逆的
     2.modal:控制器的切换是可逆的
     3.切换 window 的根控制器
     
     新特性界面结束之后就要在内存之中销毁，选用第三种方式
     
     */
    
    
    //1.使用第三种方法
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[WBMianViewController alloc] init];

    //2.使用第二种方法的时候 有动画，但是不能自动销毁
    //WBMianViewController* main = [[WBMianViewController alloc] init];
    //[self presentViewController:main animated:YES completion:nil];
}
-(void)dealloc{
    //控制器销毁的时候 毁掉调用这个 方法
    NSLog(@"NewFeatureViewController 对象销毁");
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //滑动时的偏移量 除以 一个页面所占的宽度 。 得到的值再四舍五入
    double page = scrollView.contentOffset.x  /  scrollView.width;
    self.pagecontrol.currentPage = (int)(page+0.5);
}


@end

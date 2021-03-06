 //
//  WBHomeViewController.m
//  新浪微博
//
//  Created by qsx on 15-7-28.
//  Copyright (c) 2015年 qsx_one. All rights reserved.
//

#import "WBHomeViewController.h"
#import "WBitemTools.h"
#import "AFNetworking.h"
#import "WBAccountTools.h"
#import "UIView+Extension.h"
#import "WBTitleButton.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "WBStatus.h"
#import "WBUser.h"
@interface WBHomeViewController ()
/**
 *   微博数组
 */
@property(nonatomic,strong) NSMutableArray *statuses;
@end

@implementation WBHomeViewController

-(NSMutableArray*)statuses{
    
    if (!_statuses) {
        self.statuses = [[NSMutableArray alloc] init];
    }
    return _statuses;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏中的按钮
    [self setupNav];
    
    //获得用户的昵称等信息
    [self setupUserInfo];
    
    // 加载微博数据
   // [self loadNewStatus];
    
    //集成刷新的控件
    [self setupReFresh];
    
}
#pragma mark - setupReFresh 集成刷新的控件
/**
 *   集成刷新的控件
 */
-(void)setupReFresh{
    UIRefreshControl* control = [[UIRefreshControl alloc] init];
    [control addTarget:self action:@selector(refreshChange:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:control];
    //NSLog(@"集成刷新的控件");
    //进入之后手动刷新(这里的只会触发刷新的状态，并不会进入refreshChange 方法)
    [control beginRefreshing];
    
    [self refreshChange:control];
}
-(void)refreshChange:(UIRefreshControl*) control{
     NSLog(@"集成刷新的控件 触发");
    
    //请求的地址  https://api.weibo.com/2/statuses/friends_timeline.json
    //请求的参数   access_token
    //            uid
    //1、请求管理者
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    // 设置服务器默认返回的 格式
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //2、拼接请求参数
    WBAccountModule* account  = [WBAccountTools account];
    
    //3、取出最新的微博 最新的微博 ID 是最大的
    WBStatus* firstStatus  = [self.statuses firstObject];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    if(firstStatus){
        params[@"since_id"] = firstStatus.idstr;
    }
    //3、发送请求
    [manager GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
        //新浪默认返回的是 json
        NSLog(@"refreshChange  发送成功------");
        NSArray* Status = [WBStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        //把返回的数据 添加在 数组的最前面
        NSRange range = NSMakeRange(0, Status.count);
        NSIndexSet* set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statuses insertObjects:Status atIndexes:set];
        
        [self.tableView reloadData];
        
        //结束刷新的状态
        [control endRefreshing];
        
        //显示最新的微博的数量
        [self shwoNewStatusCount:Status.count];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"refreshChange  发送失败-----%@" ,error);
        //结束刷新的状态
        [control endRefreshing];
    }];
    

}
/**
 *  刷新过后显示 最新得到的微博的数量
 *
 *  @param count 得到的最新数据的个数
 */
-(void)shwoNewStatusCount:(int)count{
    //初始化 lab 对象
    UILabel* lab = [[UILabel alloc] init];
    lab.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    lab.width = [UIScreen mainScreen].bounds.size.width;
    lab.height= 35;
    
    //设置其他的属性
    if (count == 0) {
        lab.text = @"没有最新的数据";
    }else{
        lab.text =[NSString stringWithFormat:@"共有%d条最新的微博数据",count];
    }
    //
    lab.textColor = [UIColor whiteColor];
    lab.textAlignment = NSTextAlignmentCenter; //设置文字居中
    lab.font = [UIFont systemFontOfSize:16];
    
    CGRect frame = lab.frame;
    frame.origin.y = 64 - frame.size.height;
    lab.frame = frame;
    //
    //lab.x = 128;
    [self.navigationController.view  insertSubview:lab belowSubview:self.navigationController.navigationBar];
//    [self.navigationController.view addSubview:lab];
    
    CGFloat duration = 1.0;
    CGFloat delay = 1.0;
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = lab.frame;
        frame.origin.y += frame.size.height;
        lab.frame = frame;
        // lab.transform
    } completion:^(BOOL finished) {
        //延迟一下再执行下一个动画
        
        //options:UIViewAnimationOptionCurveLinear 枚举线性匀速动画
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            CGRect frame = lab.frame;
            frame.origin.y -= frame.size.height;
            lab.frame = frame;
        } completion:^(BOOL finished) {
            [lab removeFromSuperview];
        }];
        
    }];
    
}
#pragma mark - loadNewStatus 获取自己和所关注的人的信息
/**
 *   获取自己和所关注的人的信息
 */
-(void)loadNewStatus{
    //请求的地址  https://api.weibo.com/2/statuses/friends_timeline.json
    //请求的参数   access_token
    //            uid
    //1、请求q管理者
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    // 设置服务器默认返回的 格式
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //2、拼接请求参数
    WBAccountModule* account  = [WBAccountTools account];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"count"] = @2;
    
    //3、发送请求
    [manager GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
        //新浪默认返回的是 json
        NSLog(@"发送成功------");
        //NSLog(@"发送成功----%@" , responseObject);
        //self.statuses = responseObject[@"statuses"];
       
//        NSArray* dicts = responseObject[@"statuses"];
//        for (NSDictionary* dict  in dicts) {
//            WBStatus* wbstatus = [WBStatus objectWithKeyValues:dict];
//            [self.statuses addObject:wbstatus];
//             //NSLog(@"wbstatus text is  %@",wbstatus.user.name);
//        }
        //不用上面的方案，直接把  数组  转换成  数组模型
        /**
         *  注意两种添加方法的 不同
         *  [self.statuses addObject:wbstatus];             后者作为前者的子元素添加进去
         *  [self.statuses addObjectsFromArray:Status];     后者的子元素作为前者的子元素添加进去
         */
        NSArray* Status = [WBStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        [self.statuses addObjectsFromArray:Status];
        
        [self.tableView reloadData];
        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发送失败-----%@" ,error);
    }];
    

}
#pragma mark setupUserInfo 获取用户的昵称
/**
 *  获取用户的昵称
 */
-(void)setupUserInfo{
    //请求的地址  https://api.weibo.com/2/users/show.json
    //请求的参数   access_token
    //            uid
    //1、请求管理者
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    // 设置服务器默认返回的 格式
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //2、拼接请求参数
    WBAccountModule* account  = [WBAccountTools account];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
 
    NSLog(@"%@", account.access_token);
    NSLog(@"%@",account.uid);
    //3、发送请求
    [manager GET:@"https://api.weibo.com/2/users/show.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
        //新浪默认返回的是 json
        NSLog(@"发送成功----%@" , responseObject);
        UIButton* titleButton = (UIButton*)self.navigationItem.titleView;
        NSString* name  =  responseObject[@"name"];
        
        [titleButton setTitle:name forState:UIControlStateNormal];
        
        account.name  = name;
        [WBAccountTools saveAccount:account];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发送失败-----%@" ,error);
    }];

    
     
}
#pragma mark setupNav 设置首页导航栏的中 按钮

/**
 *   设置首页导航栏的中 按钮
 */
-(void)setupNav{
    
    //设置两边的按钮
    self.navigationItem.leftBarButtonItem = [WBitemTools itemWithTarget:self action:@selector(friendsearch)image:@"navigationbar_friendsearch"  heighImage:@"navigationbar_friendsearch_highlighted"];
    self.navigationItem.rightBarButtonItem = [WBitemTools itemWithTarget:self action:@selector(pop) image:@"navigationbar_pop"  heighImage:@"navigationbar_pop_highlighted"];
    
    //设置中间的按钮
    WBTitleButton* titleButton = [[WBTitleButton alloc] init];
   
  
    
    NSString* name = [WBAccountTools account].name;
    [titleButton setTitle:name?name:@"首页" forState:UIControlStateNormal];
    
    //设置监听事件
    //这里的设置按钮 大小 可以使用  按钮自适应的 方法 代替
    
    //    titleButton.width = 150;
    //    titleButton.height = 30;
    
    self.navigationItem.titleView  =  titleButton;
    
    
}
/**     下面的代码用在 文字的长度是固定的时候 ， 文字在前 图片在后的 设计
 *      当前面的 文字的长度 是变化的时候 ， 就要使用自定义的 按钮实现
 *
 *
 *     //设置按钮中 图片 和文字的相对距离 ，要把距离算出来
 //要乘以 scale 系数 ，保证 在 retain 屏幕中的图片移动顺序是正确的
 CGFloat titleW = titleButton.titleLabel.width * [UIScreen mainScreen].scale;
 CGFloat imgW   = titleButton.imageView.width * [UIScreen mainScreen].scale;
 NSLog(@"titleW is %f" , titleW);
 NSLog(@"imgW is %f" , imgW);
 CGFloat left = titleW + imgW;
 
 //这里的 参数类型是 像素 ，而上面获取到的宽度是坐标系
 titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, left, 0, 0);
 //titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);

 *
 *
 *
 * 
 */

#pragma mark - 点击导航栏左右按钮的时候的回调方法
/**
 *  点击导航栏左右按钮的时候的回调方法
 */
-(void)friendsearch{
    NSLog(@"friendsearch");
}
-(void)pop{
    NSLog(@"pop");
}

#pragma mark - table view 方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.statuses.count;
    //return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* ID = @"statuses";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
   
    //取出这一行对应的微博字典
    WBStatus* status = self.statuses[indexPath.row];
    
   
    
    //1、取出作者的名字
    WBUser* user = status.user;
    cell.textLabel.text = user.name;
//
//     cell.textLabel.text = @"user";
    
    //2、取出内容
    cell.detailTextLabel.text = status.text;
    
    //3、取出头像
    NSString* imageUrl = user.profile_image_url;
    //占位图
    UIImage* placehoder = [UIImage imageNamed:@"avatar_default_small"];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:placehoder];

        return cell;
}
@end











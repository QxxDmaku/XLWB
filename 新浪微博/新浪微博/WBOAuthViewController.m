//
//  WBOAuthViewController.m
//  新浪微博
//
//  Created by qsx on 15-8-4.
//  Copyright (c) 2015年 qsx_one. All rights reserved.
//

#import "WBOAuthViewController.h"
#import "AFNetworking.h"
#import "WBMianViewController.h"
#import "NewFeatureViewController.h"
#import "WBAccountModule.h"
#import "WBAccountTools.h"
@interface WBOAuthViewController ()<UIWebViewDelegate>

@end

@implementation WBOAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView* web = [[UIWebView alloc] init];
    web.frame = self.view.bounds;
    web.delegate = self;
    [self.view addSubview:web];
    
    
    NSString* urlString = @"https://api.weibo.com/oauth2/authorize?client_id=4080906662&redirect_uri=http://www.baidu.com";
    
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [web loadRequest:request ];
    NSLog(@"--------viewDidLoad run");

}


//拦截请求的方法  webview每次加载之前都会调用这个方法
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //1、截取 url
    NSString* url = request.URL.absoluteString;
    
    //2、判断是否为回调地址
    NSRange  range = [url rangeOfString:@"code="];
    if (range.length !=0) {//有回调
        //截取code后面的参数
        int fromIndex = range.location + range.length;
        NSString* code = [url substringFromIndex:fromIndex];
        
        NSLog(@"%@ %@",code ,url);
    
        //3、利用 code 来换取一个 accessToken
        [self accessTokenWithcode:code];
        
        //返回 no 的是禁止加载 回调的页面
        return NO;
    }
    
    
    return YES;
}
/***
*  url:https://api.weibo.com/oauth2/access_token
*  client_id        :申请应用时分配的 AppKey    4080906662
*  client_secret    :申请应用是分配的 AppScret  afd99d986867c19e723f2171dc34b50a
*  grant_type       :使用 authorization_code
*  redirect_uri     :授权成功后的回调地址        http://www.baidu.com
*  code             :授权成功后返回的code
*/

-(void)accessTokenWithcode:(NSString*)code{
    //1、请求管理者
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    // 设置服务器默认返回的 格式
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    //2、拼接请求参数
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    params[@"client_id"] = @"4080906662";
    params[@"client_secret"] = @"afd99d986867c19e723f2171dc34b50a";
    params[@"grant_type"] = @"authorization_code";
    params[@"redirect_uri"] = @"http://www.baidu.com";
//    params[code] = @"61ec7c80e299fcbb4a7b5b4011cd570e";
    params[@"code"] = code;

    //3、发送请求
    [manager POST:@"https://api.weibo.com/oauth2/access_token" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
        //新浪默认返回的是 json
        NSLog(@"发送成功----%@" , responseObject);
        
        WBAccountModule* account = [WBAccountModule accountWithDict:responseObject];
        [WBAccountTools saveAccount:account];
        //3、跳转到  WBMianViewController 去，首先要判读是否要显示新的版本特性
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        
        NSString* lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyCFBundleVersion"];
        NSString* currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
        if ([currentVersion isEqualToString:lastVersion]) {//和上一次打开的一样

            window.rootViewController = [[WBMianViewController alloc] init];
        }else{
            window.rootViewController =[[NewFeatureViewController alloc] init];

            //2.2版本号存进沙盒 ， 版本号是新的时候才存进 沙盒
            //2.2版本号存进沙盒 ， 版本号是新的时候才存进 沙盒
            [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:@"MyCFBundleVersion"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];//马上存进去

        }

        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发送失败-----%@" ,error);
    }];
}
//协议实现的方法
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //NSLog(@"------webViewDidFinishLoad");
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    //NSLog(@"------webViewDidStartLoad");
}


@end

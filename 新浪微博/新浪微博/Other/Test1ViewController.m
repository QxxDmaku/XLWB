//
//  Test1ViewController.m
//  新浪微博
//
//  Created by qsx on 15-7-28.
//  Copyright (c) 2015年 qsx_one. All rights reserved.
//

#import "Test1ViewController.h"
#import "Test2ViewController.h"

@interface Test1ViewController ()

@end

@implementation Test1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    Test2ViewController* testview = [[Test2ViewController alloc] init];
    testview.title = @"测试2的控制器";
    
    [self.navigationController pushViewController:testview animated:YES];
}





@end

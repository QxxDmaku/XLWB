//
//  WBMessageViewController.m
//  新浪微博
//
//  Created by qsx on 15-7-28.
//  Copyright (c) 2015年 qsx_one. All rights reserved.
//

#import "WBMessageViewController.h"
#import "Test1ViewController.h"


@interface WBMessageViewController ()

@end

@implementation WBMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID ];
    if(cell == nil){
       // NSLog(@"cell nil");
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"点击的行是%ld",(long)indexPath.row];
//    NSLog(@"cell is %ld",indexPath.row );
    cell.backgroundColor = [UIColor blueColor];

    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    Test1ViewController* testview = [[Test1ViewController alloc] init];
    testview.title = @"测试使view";
   // testview.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:testview animated:YES];
}



@end

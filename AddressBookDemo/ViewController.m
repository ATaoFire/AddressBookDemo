//
//  ViewController.m
//  AddressBookDemo
//
//  Created by 洛方 on 16/6/15.
//  Copyright © 2016年 洛方. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThreeViewController.h"
@interface ViewController ()
<UITableViewDelegate,
UITableViewDataSource>
{
    UITableView * vTableView;
    NSArray * dataArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    vTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    vTableView.delegate = self;
    vTableView.dataSource = self;
    vTableView.backgroundColor = [UIColor clearColor];
    vTableView.showsVerticalScrollIndicator = NO;
    vTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    vTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:vTableView];
    
    dataArray = [NSArray arrayWithObjects:@"获取本地通讯录",@"直接选择一个联系人的号码",@"保存联系人到本地通讯录", nil];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    [vTableView reloadData];
    [vTableView deselectRowAtIndexPath:[vTableView indexPathForSelectedRow] animated:YES];
}
#pragma mark -- tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark -- tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * indefile = @"SCUseViewCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:indefile];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indefile];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        FirstViewController * firstVC = [[FirstViewController alloc] init];
        [self.navigationController pushViewController:firstVC animated:YES];
    }
    if (indexPath.row == 1) {
        SecondViewController * firstVC = [[SecondViewController alloc] init];
        [self.navigationController pushViewController:firstVC animated:YES];
    }
    if (indexPath.row == 2) {
        ThreeViewController * firstVC = [[ThreeViewController alloc] init];
        [self.navigationController pushViewController:firstVC animated:YES];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

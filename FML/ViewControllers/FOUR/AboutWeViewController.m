//
//  AboutWeViewController.m
//  FML
//
//  Created by apple on 2018/7/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "AboutWeViewController.h"
#import "AboutWeTopView.h"

#define cellHeight 55

@interface AboutWeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<NSArray *>*  cellTitles;
@property (nonatomic, strong) NSString*            cacheSize;
@property (nonatomic, strong) UITableView*         tableView;
@property (nonatomic, strong) AboutWeTopView*      topView;

@end

@implementation AboutWeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self NavigationItemTitle:@"关于我们" Color:Color1D];
    [self navgationLeftButtonImage:backUp];
    self.view.backgroundColor = ColorWhite;

    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellTitles[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"id"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = Color1D;
    cell.textLabel.text = self.cellTitles[indexPath.section][indexPath.row];
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = @"http://www.shu-qian.com";
    }
    cell.detailTextLabel.textColor = colorWithHexString(@"#999999");
    UIView* line;
    if (!line) {
        line = [[UIView alloc] initWithFrame:CGRectMake(15, 54.5, ScreenWidth - 15, 0.5f)];
        line.tag = 10001111;
        line.backgroundColor = ColorLine;
        [cell.contentView addSubview:line];
    }
    line.hidden = ((indexPath.row + 1) == self.cellTitles[indexPath.section].count);

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        [self checkBuild];
    }
}
- (void)checkBuild {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"ios.json".apifml method:GET args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        if (responseMessage.errorMessage) {
            
        } else {
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            if (![responseMessage.bussinessData[@"version"] isEqualToString:infoDictionary[@"CFBundleShortVersionString"]]) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"当前版本不是最新版本" message:@"为了保证APP的部分功能正常使用，请尽快更新至最新版本" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication ] openURL:[NSURL URLWithString:[responseMessage.bussinessData objectForKey:@"downloadUrl"]]];
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            }else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"当前已是最新版本，无需更新" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
    }];
}
#pragma mark -- lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight - NavHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = ColorWhite;
        _tableView.tableHeaderView = [[AboutWeTopView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 180)];
    }
    return _tableView;
}

- (NSArray<NSArray *> *)cellTitles {
    if (!_cellTitles) {
        _cellTitles = @[@[@"检查更新", @"网址"]];
    }
    return _cellTitles;
}

@end

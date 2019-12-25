//
//  SafeCenterViewController.m
//  FML
//
//  Created by apple on 2018/7/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "SafeCenterViewController.h"
#import "BindPhoneViewController.h"
#define cellHeight 55

@interface SafeCenterViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<NSArray *>*  cellTitles;
@property (nonatomic, strong) NSArray<NSArray *>*  controllers;
@property (nonatomic, strong) UITableView*         tableView;

@end

@implementation SafeCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavigationItemTitle:@"安全中心" Color:Color1D];
    [self navgationLeftButtonImage:backUp];
    self.view.backgroundColor = ColorWhite;
    [self.view addSubview:self.tableView];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.textColor = ColorGrayText;
    if (indexPath.row == 5) {
        cell.detailTextLabel.text = [UserSingle sharedUser].email.length!=0 ? @"已绑定" : @"未绑定";
    } else if (indexPath.row == 3) {
        cell.detailTextLabel.text = [UserSingle sharedUser].msg;
    }else if (indexPath.row==4) {
        cell.detailTextLabel.text = [UserSingle sharedUser].mobile.length!=0 ? @"已绑定" : @"未绑定";
    }
    else {
        cell.detailTextLabel.text = @"";
    }
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
    if (indexPath.row == 0 && [UserSingle sharedUser].isPayPwd) {
        [self showToastHUD:@"您已经设置过支付密码了"];
        return;
    }
    if (indexPath.row == 1 && ![UserSingle sharedUser].isPayPwd) {
        [self showToastHUD:@"您还未设置过支付密码，无法重置"];
        return;
    }
    if (indexPath.row==5||indexPath.row==5) {
        BindPhoneViewController *vc = [[BindPhoneViewController alloc]init];
        if (indexPath.row==5) {
            vc.isEmail = YES;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        id vc = [NSClassFromString(self.controllers[indexPath.section][indexPath.row]) new];
        SEL seletor = NSSelectorFromString(@"type:");
        if ([vc respondsToSelector:seletor]) {
            [vc performSelector:seletor withObject:@(indexPath.row)];
        }
        [self.navigationController pushViewController:vc animated:YES];

    }
}

#pragma mark -- lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight - NavHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = ColorWhite;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSArray<NSArray *> *)cellTitles {
    if (!_cellTitles) {
        _cellTitles = @[@[@"设置支付密码", @"重置支付密码", @"重置登录密码", @"实名认证", @"绑定手机号",@"绑定邮箱", @"银行卡管理"]];
    }
    return _cellTitles;
}

- (NSArray<NSArray *> *)controllers {
    if (!_controllers) {
        _controllers = @[@[@"SetPasswordViewController", @"SetPasswordViewController", @"SetPasswordViewController", @"RealNameViewController",@"BindPhoneViewController", @"BindPhoneViewController", @"BankCardListViewController"]];
    }
    return _controllers;
}

@end

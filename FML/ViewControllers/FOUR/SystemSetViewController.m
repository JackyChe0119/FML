//
//  SystemSetViewController.m
//  FML
//
//  Created by apple on 2018/7/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "SystemSetViewController.h"
#import "FMLAlertView.h"
#import "loginViewController.h"

#define cellHeight 55

@interface SystemSetViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<NSArray *>*  cellTitles;
@property (nonatomic, strong) NSString*            cacheSize;
@property (nonatomic, strong) UITableView*         tableView;

@end

@implementation SystemSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavigationItemTitle:@"系统设置" Color:Color1D];
    [self navgationLeftButtonImage:backUp];
    self.view.backgroundColor = ColorWhite;
    
    _cacheSize = [NSString stringWithFormat:@"%.1fM", [self folderSize]];
    [self.view addSubview:self.tableView];

    UIButton *logOutButton = [UIButton createTextButtonWithFrame:CGRectMake(145/2.0, ScreenHeight - 85, ScreenWidth-145, 45) bgColor:colorWithHexString(@"#999999") textColor:ColorWhite font:16 bold:YES title:@"退出登录"];
    [self.view addSubview:logOutButton];
    logOutButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:bold];
    logOutButton.layer.cornerRadius = 4;
    logOutButton.layer.masksToBounds = YES;
    logOutButton.backgroundColor = colorWithHexString(@"#999999");
    [logOutButton addTarget:self action:@selector(_logOutButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 缓存

- (void)_logOutButtonClick{

    [self showShadowViewWithColor:YES];
    FMLAlertView* alertView = [[FMLAlertView alloc] initWithTitle:@"退出登录" msg:@"确认退出登录么？"];
    [alertView addBtn:@"确定" titleColor:ColorGrayText action:^{
        [[UserSingle sharedUser] loginout];
        [self hiddenShadowView];
        [[UIApplication sharedApplication].delegate window].rootViewController = [[UINavigationController alloc]initWithRootViewController:[[loginViewController alloc]init]];
    }];
    [alertView addBtn:@"取消" titleColor:ColorBlue action:^{
        [self hiddenShadowView];
    }];
    [self.shadowView addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.shadowView);
        make.width.mas_equalTo(ScreenWidth * 0.8);
    }];
}
// 缓存大小
- (CGFloat)folderSize{
    CGFloat folderSize = 0.0;
    
    //获取路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)firstObject];
    
    //获取所有文件的数组
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    
    NSLog(@"文件数：%ld",files.count);
    
    for(NSString *path in files) {
        
        NSString*filePath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",path]];
        
        //累加
        folderSize += [[NSFileManager defaultManager]attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    //转换为M为单位
    CGFloat sizeM = folderSize /1024.0/1024.0;
    
    return sizeM;
}
- (void)removeCache{
    [self showProgressHud];
    //===============清除缓存==============
    //获取路径
    NSString*cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)objectAtIndex:0];
    
    //返回路径中的文件数组
    NSArray*files = [[NSFileManager defaultManager]subpathsAtPath:cachePath];
    
    NSLog(@"文件数：%ld",[files count]);
    if (![files count]) {
         [self hiddenProgressHud];
    }
    for(NSString *p in files){
        NSError*error;
        
        NSString*path = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",p]];
        
        if([[NSFileManager defaultManager]fileExistsAtPath:path])
        {
            [self hiddenProgressHud];
            BOOL isRemove = [[NSFileManager defaultManager]removeItemAtPath:path error:&error];
            if(isRemove) {
                NSLog(@"清除成功");
                //这里发送一个通知给外界，外界接收通知，可以做一些操作（比如UIAlertViewController）
                [self showToastHUD:@"清除成功"];
                CGFloat caheSizeM = [self folderSize];
                _cacheSize = [NSString stringWithFormat:@"%.1fMB",caheSizeM];
                [self.tableView reloadData];
            }else{
                NSLog(@"清除失败");
            }
        } else {
           
        }
    }
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
    cell.detailTextLabel.text = _cacheSize;
    cell.detailTextLabel.textColor = ColorGrayText;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @" ";
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @" ";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self removeCache];
    }
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
    }
    return _tableView;
}

- (NSArray<NSArray *> *)cellTitles {
    if (!_cellTitles) {
        _cellTitles = @[@[@"清除缓存"]];
    }
    return _cellTitles;
}

@end

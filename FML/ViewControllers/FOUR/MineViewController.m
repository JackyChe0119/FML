//
//  MineViewController.m
//  FML
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "MineViewController.h"
#import "ChangeIconViewController.h"
#import "FMLTransitionDelegate.h"
#import "SelectPhotoManager.h"
#import "CommonUtil.h"
#import "AliyunOSSEngine.h"
#import "NickNameChangeVC.h"
@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray*  cellTitles;
@property (nonatomic, strong) NSArray*  cellDetailTitles;
@property (nonatomic, strong) UITableView*         tableView;
@property (nonatomic, strong) FMLTransitionDelegate* delegate;
@property (nonatomic, strong) UIImageView*  icon;
@property (nonatomic, strong)SelectPhotoManager *photoManager;
@property (nonatomic,strong) UILabel *nickName;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cellTitles = @[ @"我的邀请码"];
    _cellDetailTitles = @[[UserSingle sharedUser].userNo ?:@""];
    
    [self NavigationItemTitle:@"个人信息" Color:Color1D];
    [self navgationLeftButtonImage:backUp];
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"id"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = Color1D;
    cell.textLabel.text = self.cellTitles[indexPath.row];
    cell.detailTextLabel.text = self.cellDetailTitles[indexPath.row];
    cell.detailTextLabel.textColor = ColorGrayText;
    UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
    longPressGesture.minimumPressDuration = 1.5f;//设置长按 时间
    [cell addGestureRecognizer:longPressGesture];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self sectionView:@"长按可复制"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)sectionView:(NSString *)title {
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    
    UILabel* label = [UILabel new];
    label.text = title;
    label.textColor = ColorGrayText;
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(view);
        make.right.equalTo(view).offset(-20);
    }];
    
    return view;
}

-(void)cellLongPress:(UILongPressGestureRecognizer *)longRecognizer{
    
    if (longRecognizer.state==UIGestureRecognizerStateBegan) {
        //成为第一响应者，需重写该方法
        [self becomeFirstResponder];
        
        CGPoint location = [longRecognizer locationInView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:location];
        //可以得到此时你点击的哪一行
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.cellDetailTitles[indexPath.row];
        [self showToastHUD:@"复制成功"];
    }
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight - NavHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = ColorBg;
        _tableView.tableHeaderView = [self tableHeaderView];
    }
    return _tableView;
}

- (UIView *)tableHeaderView {
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 95+55)];
    
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 55)];
    contentView.backgroundColor = ColorWhite;
    contentView.userInteractionEnabled = YES;
    [view addSubview:contentView];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 55)];
    title.textColor = Color1D;
    title.font = [UIFont systemFontOfSize:16];
    title.text = @"头像";
    [contentView addSubview:title];
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 27, 21, 7, 13)];
    imageView.image = [UIImage imageNamed:@"icon_accesstype2"];
    [contentView addSubview:imageView];
    
    UIImageView* icon = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 27 - 60, 7.5, 40, 40)];
    icon.backgroundColor = [UIColor whiteColor];
    icon.layer.cornerRadius = 20;
    icon.layer.masksToBounds = YES;
    [contentView addSubview:icon];
    _icon = icon;
    [_icon sd_setImageWithURL:[UserSingle sharedUser].picture.toUrl placeholderImage:[UIImage imageNamed:@"icon_default"]];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeIcon)];
    [contentView addGestureRecognizer:tap];
    
    UIView* contentView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 20+55, ScreenWidth, 55)];
    contentView2.backgroundColor = ColorWhite;
    contentView2.userInteractionEnabled = YES;
    [view addSubview:contentView2];
    
    UILabel* title2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 85, 55)];
    title2.textColor = Color1D;
    title2.font = [UIFont systemFontOfSize:16];
    title2.text = @"修改昵称";
    [contentView2 addSubview:title2];
    
    _nickName = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, ScreenWidth-135, 55)];
    _nickName.textColor = Color1D;
    _nickName.font = [UIFont systemFontOfSize:16];
    _nickName.textAlignment = NSTextAlignmentRight;
    _nickName.text = [UserSingle sharedUser].nickName;
    [contentView2 addSubview:_nickName];
    
    UIImageView* imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 27, 21, 7, 13)];
    imageView2.image = [UIImage imageNamed:@"icon_accesstype2"];
    [contentView2 addSubview:imageView2];
    
    UITapGestureRecognizer* tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeNickName)];
    [contentView2 addGestureRecognizer:tap2];
    
    return view;
}
- (void)changeNickName {
    NickNameChangeVC *vc = [[NickNameChangeVC alloc]init];
    __weak typeof(self)weakSelf = self;
    vc.nickNameBlock = ^(NSString *text) {
        weakSelf.nickName.text = text;
        [UserSingle sharedUser].nickName = text;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)changeIcon {
    
    __weak typeof(self) weakSelf = self;
 
    if (!_photoManager) {
        _photoManager =[[SelectPhotoManager alloc]init];
    }
    _photoManager.superVC = self;
    
    ChangeIconViewController* vc = [ChangeIconViewController new];
    self.delegate = [FMLTransitionDelegate shareInstance];
    self.delegate.height = 165.5;
    self.delegate.style = AnimationStyleBackScale;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self.delegate;

    [self presentViewController:vc animated:YES completion:nil];

    vc.selectPhotoType = ^(int index) {
        [_photoManager selectPhotoWithType:index];
    };
    
//    __weak typeof(self) weakSelf = self;
    //选取照片成功
    _photoManager.successHandle=^(SelectPhotoManager *manager,UIImage *image){
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY/MM/dd"];
        NSString *dateStr = [formatter stringFromDate:date];
        NSString* filePath = [NSString stringWithFormat:@"walletdlp/app/img/%@/photo_%@.png",dateStr, [weakSelf getNowTimeTimestamp2]];
        
        NSData *data = UIImagePNGRepresentation(image);
        
        [weakSelf showProgressHud];
        [AliyunOSSEngine uploadWithFilePath:filePath fileData:data progressBlock:^(long long bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            NSLog(@"%lld", totalBytesExpectedToWrite);
        } callbackBlock:^(NSString *fileUrl) {
            NSLog(@"--------------%@", fileUrl);
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (fileUrl) {
                    weakSelf.icon.image = image;
                    [weakSelf commitIconImage:fileUrl image:image];
                } else {
                    [weakSelf showToastHUD:@"上传失败"];
                    [weakSelf hiddenProgressHud];
                }
                
            }];
        }];
    };
    
    _photoManager.errorHandle = ^(NSString *error) {
 
    };
}


- (void)commitIconImage:(NSString *)fileUrl image:(UIImage *)image {
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"picture"] = fileUrl;
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"user/update_user.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
           [UserSingle sharedUser].picture = [ALIYUN_OSS_IMAGE_DOMAIN stringByAppendingString:String(dict[@"picture"])];
            //提前下载
            [_icon sd_setImageWithURL:[UserSingle sharedUser].picture.toUrl placeholderImage:image];
        }
    }];
}

- (NSString *)getNowTimeTimestamp2{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
    
}
@end

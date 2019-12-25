//
//  baseOneViewController.m
//  ManggeekBaseProject
//
//  Created by 车杰 on 2017/12/20.
//  Copyright © 2017年 Jacky. All rights reserved.
//

#import "baseOneViewController.h"
#import "SelectButtonView.h"
#import "ziChanListCell.h"
#import "ziChanTopView.h"
#import <AVFoundation/AVFoundation.h>
#import "CurrencyViewController.h"
#import "HomeAddCell.h"
#import "MJRefresh.h"
#import "CurrencySwitchModel.h"
#import "WalletListModel.h"
#import "SetPasswordViewController.h"
#import "AnswerViewController.h"

@interface baseOneViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UITableView *tableView2;
@property (nonatomic,strong)ziChanTopView *topView;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) NSMutableArray<CurrencySwitchModel *>* models;
@property (nonatomic, strong) NSMutableArray<WalletListModel *>* walletModels;
@property (nonatomic, strong) dispatch_group_t myGroup;
@property (nonatomic, assign) BOOL isFristGetData;
@property (nonatomic, strong)UIView *adView;
@property (nonatomic, strong)UIImage *adIamge;
@end

@implementation baseOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _models = [NSMutableArray array];
    _walletModels = [NSMutableArray array];
    _isFristGetData = YES;
    
    [self layoutUI];
    
    [self showProgressHud];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_group_t group = dispatch_group_create();
    self.myGroup = group;
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        [self wallet_card];
    });
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        [self userInfo];
    });
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        [self walletCardSys:_pageNum];
    });
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        [self showWallet:_pageNum];
    });
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        [self getBitIconName];
    });
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hiddenProgressHud];
            _isFristGetData = NO;
        });
    });
    [self performSelector:@selector(requestAdView) withObject:nil/*可传任意类型参数*/ afterDelay:0.0];
}
- (void)requestAdView {
    NSString *url = @"http://api.shu-qian.com/23011536559577.jpg";
    [[SDImageCache sharedImageCache] removeImageForKey:url withCompletion:^{
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:url] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if (error) {
                
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _adView = [UIView createViewWithFrame:RECT(0, ScreenHeight, ScreenWidth, ScreenHeight) color:[[UIColor blackColor] colorWithAlphaComponent:.8]];
                    _adView.layer.masksToBounds = YES;
                    UIImageView *imageView = [[UIImageView alloc]initWithFrame:RECT(0, 0, ScreenWidth, ScreenHeight)];
                    imageView.image = image;
                    imageView.userInteractionEnabled = YES;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeAdView)];
                    [imageView addGestureRecognizer:tap];
                    [_adView addSubview:imageView];
                    [MainWindow addSubview:_adView];
                    [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:0.98 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        _adView.frame = RECT(0, 0, ScreenWidth, ScreenHeight);
                    } completion:^(BOOL finished) {
                    }];
                });
            }
        }];
    }];
}
- (void)removeAdView {
    [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:0.98 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _adView.frame = RECT(0, ScreenHeight, ScreenWidth, ScreenHeight);
    } completion:^(BOOL finished) {
        [_adView removeFromSuperview];
        _adView = nil;
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_isFristGetData) {
        _pageNum = 0;
        [self showWallet:_pageNum];
        [self userInfo];
        [self wallet_card];
        if ([UserSingle sharedUser].bitArray == nil) {
            [self getBitIconName];
        }
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)layoutUI {
    [self.view addSubview:[self ziChanTopView]];
    
    SelectButtonView *selectBtn = [[SelectButtonView alloc]initWithFrame:RECT(50, StatusBarHeight, ScreenWidth-100, 44)];
    selectBtn.font = 19;
    selectBtn.title = @"资产";
    [self.customNavView addSubview:selectBtn];
    
    _tableView = [[UITableView alloc]initWithFrame:RECT(0, self.topView.bottom , ScreenWidth, ScreenHeight-TabBarHeight - self.topView.bottom) style:0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = YES;
    _tableView.contentInset = UIEdgeInsetsMake(-5, 0, 0, 0);
    _tableView.backgroundColor = ColorBg;
    [_tableView registerNib:[UINib nibWithNibName:@"ziChanListCell" bundle:nil] forCellReuseIdentifier:@"ziChanListCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _pageNum = 0;
    
    [self.view addSubview:self.tableView2];
    
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        weakSelf.pageNum = 0;
        [weakSelf showWallet:weakSelf.pageNum];
        [weakSelf userInfo];
        [weakSelf wallet_card];
    }];
    [self.view bringSubviewToFront:self.topView];
    [self.view bringSubviewToFront:self.customNavView];
}
- (UITableView *)tableView2 {
    if (!_tableView2) {
        _tableView2 = [[UITableView alloc]initWithFrame:RECT(0, self.tableView.top , ScreenWidth, ScreenHeight-self.topView.bottom-TabBarHeight) style:0];
        _tableView2.top -= _tableView2.height;
        _tableView2.delegate = self;
        _tableView2.dataSource = self;
        _tableView2.tableFooterView = [UIView new];
        _tableView2.backgroundColor =colorWithHexString(@"#f8f8f8");
        [_tableView2 registerNib:[UINib nibWithNibName:@"HomeAddCell" bundle:nil] forCellReuseIdentifier:@"HomeAddCell"];
        [_tableView2 setSeparatorColor:ColorLine];
        [_tableView2 setSeparatorInset:UIEdgeInsetsMake(0, 60, 20, 15)];
        
        __weak typeof(self) weakSelf = self;
        [_tableView2 addHeaderWithCallback:^{
            weakSelf.pageNum = 0;
            [weakSelf walletCardSys:weakSelf.pageNum];
            [weakSelf userInfo];
            [weakSelf wallet_card];
        }];
        [_tableView2 addFooterWithCallback:^{
            if (weakSelf.pageNum == -1) {
                [weakSelf showToastHUD:@"没有更多数据了"];
                [weakSelf.tableView2.footer endRefreshing];
            } else {
                [weakSelf walletCardSys:weakSelf.pageNum];
            }
        }];
    }
    return _tableView2;
}
- (UIView *)ziChanTopView {
    if (!_topView) {
        __weak typeof(self)weakSelf = self;
        _topView = [[ziChanTopView alloc]initWithFrame:RECT(0, NavHeight , ScreenWidth, 165)];
        _topView.exChangeBlock = ^(NSInteger index) {
            weakSelf.pageNum = 0;
            if (index==0) {

                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.tableView2.top -= weakSelf.tableView2.height;
                }];
                NSLog(@"%@",weakSelf.tableView2);
                [weakSelf showWallet:weakSelf.pageNum];
            }else {
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.tableView2.top = weakSelf.tableView.top;
                }];
                [weakSelf walletCardSys:weakSelf.pageNum];
            }
        };
    }
    return _topView;
}
#pragma mark 相关事件处理

- (void)navgationRightButtonClick {
    [self QZCodeButtonClick];
}
- (void)QZCodeButtonClick {
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您已关闭了相机权限，请在设置中打开" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
        [alert show];
        return;
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}
#pragma mark uitableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableView) {
        return _walletModels.count;
    }
    return _models.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==_tableView) {
        return 93;
    }
    return 63.5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==_tableView) {
        ziChanListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ziChanListCell"];
        cell.model = _walletModels[indexPath.row];
        return cell;
    }else {
        HomeAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeAddCell"];
        CurrencySwitchModel *model = _models[indexPath.row];
        cell.model = model;
        cell.operaBlock = ^(BOOL isOn) {
            if (!isOn) {
                model.isShow = @"n";
            }else {
                model.isShow = @"y";
            }
        };
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==_tableView) {
        CurrencyViewController *vc = [[CurrencyViewController alloc]init];
        vc.currencyName = _walletModels[indexPath.row].currenctName;
        vc.currencyId = String(_walletModels[indexPath.row].currencyId);
        vc.currencyIcon = _walletModels[indexPath.row].logo;
        vc.walletModel = _walletModels[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        
    }
}

- (void)wallet_card {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"wallet_card/index.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            self.topView.titleLabel.text = String(responseMessage.bussinessData[@"walletName"]);
            self.topView.priceLabel.text = [NSString stringWithFormat:@"%.2f  usdt", String(responseMessage.bussinessData[@"price"]).floatValue];
        }
        if (_isFristGetData) {
            dispatch_group_leave(self.myGroup);
        }
    }];
}

- (void)userInfo {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"user/user_info.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            [[UserSingle sharedUser] setLoginInfo:responseMessage.bussinessData];
            self.topView.subtitle = [UserSingle sharedUser].walletAddress;
            [self.topView.qianbaoIamgeView sd_setImageWithURL:[UserSingle sharedUser].picture.toUrl placeholderImage:[UIImage imageNamed:@"icon_default"]];
            if (![UserSingle sharedUser].isAnswer && _isFristGetData) {
                AnswerViewController* vc = [AnswerViewController new];
                UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
                [self presentViewController:nav animated:YES completion:nil];
                vc.showPassHandler = ^{
                    if (![UserSingle sharedUser].isPayPwd) {
                        SetPasswordViewController* vc = [SetPasswordViewController new];
                        vc.type = FMLPasswordTYPESetNewBuyNoPush;
                        [self presentViewController:vc animated:YES completion:nil];
                    } 
                };
            } else if (![UserSingle sharedUser].isPayPwd && _isFristGetData) {
                SetPasswordViewController* vc = [SetPasswordViewController new];
                vc.type = FMLPasswordTYPESetNewBuyNoPush;
                [self presentViewController:vc animated:YES completion:nil];
            }
        }
        if (_isFristGetData) {
            dispatch_group_leave(self.myGroup);
        }
    }];
}
- (void)walletCardSys:(NSUInteger)pageNum {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"pageNum"] = @(pageNum);
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"wallet_card/sys_currency.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            if (pageNum == 0) {
                [_models removeAllObjects];
            }
            _pageNum = pageNum + 1;
            NSArray* array = [CurrencySwitchModel arrayToModel:responseMessage.bussinessData];
            if (array.count == 0) {
                _pageNum = -1;
            }
            [_models addObjectsFromArray:[CurrencySwitchModel arrayToModel:responseMessage.bussinessData]];
        }
        
        if (_models.count != 0) {
            if (![_models[0].currenctName isEqualToString:@"FML"]) {
                [_models enumerateObjectsUsingBlock:^(CurrencySwitchModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.currenctName isEqualToString:@"FML"]) {
                        [_models removeObject:obj];
                        [_models insertObject:obj atIndex:0];
                        *stop = YES;
                    }
                }];
            }
        }
        if (_models.count != 0) {
            if (![_models[0].currenctName isEqualToString:@"ETH"]) {
                [_models enumerateObjectsUsingBlock:^(CurrencySwitchModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.currenctName isEqualToString:@"ETH"]) {
                        [_models removeObject:obj];
                        [_models insertObject:obj atIndex:0];
                        *stop = YES;
                    }
                }];
            }
        }
        [self.tableView2 reloadData];
        [self.tableView2.footer endRefreshing];
        [self.tableView2.header endRefreshing];
        if (_isFristGetData) {
            dispatch_group_leave(self.myGroup);
        }
    }];
}

- (void)showWallet:(NSUInteger)pageNum {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"pageNum"] = @(pageNum);
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"wallet_card/list.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            if (pageNum == 0) {
                [_walletModels removeAllObjects];
            }
            _pageNum = pageNum + 1;
            NSArray* array = [WalletListModel arrayToModel:responseMessage.bussinessData];
            if (array.count == 0) {
                _pageNum = -1;
            }
            [_walletModels addObjectsFromArray:[WalletListModel arrayToModel:responseMessage.bussinessData]];
            if (_walletModels.count != 0) {
                if (![_walletModels[0].currenctName isEqualToString:@"ETH"]) {
                    [_walletModels enumerateObjectsUsingBlock:^(WalletListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj.currenctName isEqualToString:@"ETH"]) {
                            [_walletModels removeObject:obj];
                            [_walletModels insertObject:obj atIndex:0];
                            *stop = YES;
                        }
                        
                    }];
                }
            }
        }
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
        if (_isFristGetData) {
            dispatch_group_leave(self.myGroup);
        }
        
    }];
}
- (void)getBitIconName {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"node/load_cur.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            NSLog(@"获取币种名称和icon失败");
            NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"bitInfoArray"];
            if (array!=nil) {
                [[UserSingle sharedUser] setArray:array];
            }
        } else {
            NSArray *array = responseMessage.bussinessData;
            [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"bitInfoArray"];
            [[UserSingle sharedUser] setArray:array];
        }
        if (_isFristGetData) {
            dispatch_group_leave(self.myGroup);
        }
    }];
}
@end

//
//  AppDelegate.m
//  ManggeekBaseProject
//
//  Created by 车杰 on 17/5/2.
//  Copyright © 2017年 Jacky. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "loginViewController.h"
#import "IQKeyboardManager.h"
#import "LeftLableTextField.h"
#import "KSGuaidViewManager.h"
#import "GCDAsyncSocket.h"
@interface AppDelegate ()<GCDAsyncSocketDelegate>
@property(strong,nonatomic)GCDAsyncSocket *clientSocket;
@property(nonatomic,strong)NSTimer *connectTimer;
@property(nonatomic,assign) BOOL connected;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = ColorWhite;
    
    self.clientSocket=[[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
      NSError *error = nil;
    
    self.connected = [self.clientSocket connectToHost:@"" onPort:8080 viaInterface:nil withTimeout:-1 error:&error];
    
    KSGuaidManager.images = @[[UIImage imageNamed:IPhoneX ? @"guid01_x" : @"guid01"],
                              [UIImage imageNamed:IPhoneX ? @"guid02_x" : @"guid02"],
                              [UIImage imageNamed:IPhoneX ? @"guid03_x" : @"guid03"]];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    //    KSGuaidManager.dismissButtonCenter = CGPointMake(size.width / 2, size.height - 80);
    KSGuaidManager.dismissButtonRect = CGRectMake(size.width / 2 - ScreenWidth / 2 + 40, size.height - 140, ScreenWidth - 80, 80);
    KSGuaidManager.dismissButtonImage = [UIImage imageNamed:@"hidden"];
    
    [KSGuaidManager begin];
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 80, 0, 80, 80)];
    [btn addTarget:KSGuaidManager action:@selector(end) forControlEvents:UIControlEventTouchUpInside];
    [KSGuaidManager.managerVC.view addSubview:btn];

    //设定app登录类型 账号被其他设备登录时控制使用
    APPInfoData *APPInfo = [APPInfoData shareData];
    APPInfo.appType = 1;//强制性登录
  
    if (![[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN] || ![[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"]) {
        loginViewController *loginVc = [[loginViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVc];
        self.window.rootViewController = nav;
    }else {
        MainViewController *mainVc = [[MainViewController alloc]init];
        self.window.rootViewController = mainVc;
    }
    if ([APPInfoData shareData].appType==1) {//需要跳到登录页面
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(APPNeedLoginNotification) name:@"APPNeedLoginNotification" object:nil];
    }else {//不需要登录 但是需要回到首页
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(APPLoginOutNotification) name:@"APPLoginOutNotification" object:nil];
    }
    [self registerIQKboardManager];
    
    [self.window makeKeyAndVisible];
    
    [self checkBuild];
    
    return YES;
}
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    //    NSLog(@"连接主机对应端口%@", sock);
    [CommonToastHUD showTips:@"链接成功"];
    [CommonToastHUD showTips:[NSString stringWithFormat:@"服务器IP: %@-------端口: %d", host,port]];
    // 连接成功开启定时器
    [self addTimer];
    // 连接后,可读取服务端的数据
    [self.clientSocket readDataWithTimeout:- 1 tag:0];
    self.connected = YES;
}
// 添加定时器
- (void)addTimer {
    // 长连接定时器
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];
    // 把定时器添加到当前运行循环,并且调为通用模式
    [[NSRunLoop currentRunLoop] addTimer:self.connectTimer forMode:NSRunLoopCommonModes];
}
// 心跳连接
- (void)longConnectToSocket {
    // 发送固定格式的数据,指令@"longConnect"
    float version = [[UIDevice currentDevice] systemVersion].floatValue;
    NSString *longConnect = [NSString stringWithFormat:@"123%f",version];
    NSData  *data = [longConnect dataUsingEncoding:NSUTF8StringEncoding];
    [self.clientSocket writeData:data withTimeout:- 1 tag:0];
}
/**
 读取数据
  @param sock 客户端socket
 @param data 读取到的数据
 @param tag 本次读取的标记
 */
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    [CommonToastHUD showTips:text];
    // 读取到服务端数据值后,能再次读取
    [self.clientSocket readDataWithTimeout:- 1 tag:0];
}
/**
 客户端socket断开
 
 @param sock 客户端socket
 @param err 错误描述
 */
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    [CommonToastHUD showTips:@"断开连接"];
    self.clientSocket.delegate = nil;
    self.clientSocket = nil;
    self.connected = NO;
    [self.connectTimer invalidate];
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
                [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
            }
        }
    }];
}

/**
 *   键盘第三方
 **/
- (void)registerIQKboardManager {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES; // 控制整个功能是否启用。
    manager.shouldResignOnTouchOutside =YES; // 控制点击背景是否收起键盘
    manager.shouldShowTextFieldPlaceholder = YES;
    manager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    manager.toolbarDoneBarButtonItemText = @"完成";
    manager.toolbarTintColor = ColorBlue;
//    manager.toolbarManageBehaviour = IQAutoToolbarByPosition;
//    [manager setPreviousNextDisplayMode:IQPreviousNextDisplayModeAlwaysShow];
    [manager reloadInputViews];
    
}
- (void)APPNeedLoginNotification {
    loginViewController *loginVc = [[loginViewController alloc]init];
    UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:loginVc];
    self.window.rootViewController = loginNav;
} 
- (void)APPLoginOutNotification {
    
}

- (void)applicationWillResignActive:(UIApplication *)application {

}
- (void)applicationDidEnterBackground:(UIApplication *)application {

}
- (void)applicationWillEnterForeground:(UIApplication *)application {

}
- (void)applicationDidBecomeActive:(UIApplication *)application {
   
}
- (void)applicationWillTerminate:(UIApplication *)application {
  
}


@end

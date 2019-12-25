//
//  WebViewController.m
//  FML
//
//  Created by apple on 2018/7/31.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavigationItemTitle:_webTitle Color:Color1D];
    [self navgationLeftButtonImage:backUp];
    if (_type==1) {
        UIScrollView *baseScrollView= [[UIScrollView alloc]initWithFrame:RECT(0, NavHeight, ScreenWidth, ScreenHeight-NavHeight)];
        baseScrollView.backgroundColor = [UIColor whiteColor];
        baseScrollView.alwaysBounceVertical = YES;
        [self.view addSubview:baseScrollView];
        
        UILabel *content = [UILabel new];
        [content rect:RECT(20, 20, ScreenWidth-40, 100) aligment:Left font:13 isBold:NO text:@"星際節點規則\n星際節點是基於區塊鏈技術的量化交易策略的收益共享網絡。任何用戶都可以加入星際節點計劃，並創建自己的星系。隨著星系的不斷成長和節點網絡收益的增加，用戶可以根據自己的節點等級來分享對應的星際節點網絡收益。此外，我們還將不定期的為不同等級的節點提供空投糖果，節點礦池，大咖見面會等專屬福利。\n節點等級 節點共有3個等級，不同等級的節點分享到的收益不同。具體收益分配如下：\n初始節點 任何加入星際節點計劃的人既是初始節點，初始節點暫不享受節點收益。\n普通節點 在鏈接了5個初始節點並獲得100000點節點能量後，即可升級為普通節點。普通節點可以獲得其直接鏈接的節點所獲得收益的20%.同時，普通節點還还將额外獲得以其為核心周圍3层星系收益的10%。\n高級節點 在鏈接了5個普通節點並獲得500000點節點能量後，即可升級為普通節點。高級節點可以獲得其直接鏈接的節點所獲得收益的30%.同時，高級節點還还將额外獲得以其為核心周圍5层星系收益的20%。\n超級節點 在鏈接了5個高級節點並獲得1000000點節點能量後，即可升級為超級節點。超級節點可以獲得其直接鏈接的節點所獲得收益的40%.同時，高級節點還还將额外獲得以其為核心周圍7层星系收益的30%。\n節點能量 節點能量由加入節點收益計劃的數字資產數量轉換而來，節點能量高低將決定您的節點等級以及您可以獲得的節點分成收益。具體的轉換規則如下：\n1 BTC=150000\n1 ETH=5000\n1 USDT=25\n1 FML=1\n起投額度 1USDT或等值其他數字通證起投\n收益計算規則 若申購當日為工作日，則T+1日開始計息。若申購日為節假日，則計息日順延至申購日後最近的工作日。\n收益計價標準 數字通證投資按幣幣本位結算（如期初投入10個BTC，本期收益為20%，則產品到期後可收到12個BTC。UDST、ETH等其他數字通證同理）\n收益結算方式 每月最後壹日24點結算本月收益，到期可提回本金。\n收益到賬時間 在收益到期次日即可申請提取本期收益。本期收益將在用戶發出提取申請後的3個工作日內轉入用戶的資產賬戶。\n量化交易服務方 BITSEN INTERNATIONAL PTE.LTD." textColor:Color4D superView:baseScrollView];
        content.numberOfLines = 0;
        [content sizeToFit];
        baseScrollView.contentSize = CGSizeMake(ScreenWidth, GETY(content.frame)+20);
        
    }else {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight - NavHeight)];
        [self.view addSubview:webView];
        webView.delegate = self;
        NSURL *url = [NSURL URLWithString:_url];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
        [self showProgressHud];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hiddenProgressHud];
}

@end

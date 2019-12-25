//
//  OrderListModel.h
//  FML
//
//  Created by 车杰 on 2018/8/18.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "MJBaseModel.h"

@interface OrderListModel : MJBaseModel
//buyEmail = "1@qq.com";
//createTime = 1534587373000;
//currencyId = 19;
//currencyType = ETH;
//id = 37;
//num = 1;
//price = "2112.03";
//productId = 13;
//ratePrice = "2112.03";
//recordNo = R18081836593986061613;
//saleType = "";
//status = 0;
//type = buy;
//userId = 20;
//userNo = MI58FYMRL;
//walletCurrency = 20;
@property (nonatomic,copy)NSString *buyEmail,*createTime,*currencyType,*price,*ratePrice,*recordNo,*saleType,*type,*userNo,*userName,*systemTime,*sysBankName,*sysBankNumber,*nickName,*targetName,*targetNickName;
@property (nonatomic,assign)NSInteger Id,currencyId,productId,userId,status,walletCurrency;
@property (nonatomic,assign)float num;
@end

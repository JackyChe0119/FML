//
//  ziChanTopView.h
//  FML
//
//  Created by 车杰 on 2018/7/18.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ziChanTopView : UIView

@property (nonatomic,strong)UIImageView *qianbaoIamgeView;

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UILabel *subTitlelabel;

@property (nonatomic,strong)UILabel *priceLabel;

@property (nonatomic,strong)UIButton *seleectButton;

@property (nonatomic,copy)NSString *url,*title,*subtitle,*price;

@property (nonatomic,strong) void (^exChangeBlock)(NSInteger index);

@end

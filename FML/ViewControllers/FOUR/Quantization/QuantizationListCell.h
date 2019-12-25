//
//  QuantizationListCell.h
//  FML
//
//  Created by 车杰 on 2018/9/5.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuantizationListCell : UITableViewCell
@property (nonatomic,strong)UILabel *ContentTitleLabel,*label1,*label2,*label3,*label4,*label5,*label6;
@property (nonatomic,strong)UIView *lineView1;
@property (nonatomic,strong)UIButton *typeButton;
@property (nonatomic,strong)UIImageView *bgView;
@property (nonatomic,strong)UIImageView *bgimageView;
- (void)showCellWithDic:(NSDictionary *)result;
@end

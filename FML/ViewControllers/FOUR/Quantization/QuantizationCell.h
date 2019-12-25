//
//  QuantizationCell.h
//  FML
//
//  Created by 车杰 on 2018/9/4.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuantizationCell : UITableViewCell
@property (nonatomic,strong)UILabel *ContentTitleLabel,*ContentTipLabel,*label1,*label2,*label3,*label4,*label5,*label6,*label7,*label8,*label9,*label10,*label11,*label12;
@property (nonatomic,strong)UIView *lineView1,*lineView2,*lineView3;
@property (nonatomic,strong)UIButton *tixiButton,*redemptionButton;
@property (nonatomic,assign)BOOL isFocus;
@property (nonatomic,strong) void (^operationBlock)(NSInteger type);
- (void)showCellWithDic:(NSDictionary *)result;
@end

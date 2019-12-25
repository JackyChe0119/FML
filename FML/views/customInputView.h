//
//  customInputView.h
//  FML
//
//  Created by 车杰 on 2018/7/17.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customInputView : UIView<UITextFieldDelegate>
//自定义初始化方式
- (instancetype)initWithFrame:(CGRect)frame style:(NSInteger)style;

@property (nonatomic,assign)float right_offset;//右边间距

@property(nonatomic,strong)UIImageView *leftImageView;

@property (nonatomic,copy)NSString *leftImageStr;

@property (nonatomic,strong)UITextField *inputTextField;

@property (nonatomic,strong)UILabel *code_countLabel;

@property (nonatomic,strong)UIButton *rightButton;

@property (nonatomic,strong)UIView *lineView;

@property (nonatomic,strong)UILabel *time_CountLabel;

@property (nonatomic,copy) NSString *rightImageStr;

@property (nonatomic,assign)BOOL leftImageHidden;//左边图片是否隐藏

@property (nonatomic,assign)BOOL needencryption;//需要加密

@property (nonatomic,assign)BOOL isBoard;//验证码是否加边框

@property (nonatomic,assign)BOOL needCount_down;//需要验证码计时
//1 按钮点击  2 验证码获取
@property (nonatomic,strong) void (^inputViewBlcok)(NSInteger type);

@end

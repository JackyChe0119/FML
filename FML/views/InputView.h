//
//  InputView.h
//  FML
//
//  Created by 车杰 on 2018/7/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputView : UIView<UITextFieldDelegate>
@property (nonatomic,strong)UILabel *leftLabel,*rightLabel;

@property (nonatomic,strong)UITextField *rightTf;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,copy) NSString *leftStr,*rightTfPalceHold;
@property (nonatomic,copy) NSString *rightStr;

@property (nonatomic,assign) BOOL lineViewHidden;

@property (nonatomic,assign)CGFloat leftLabelWidth;

@end

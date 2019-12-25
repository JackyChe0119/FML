//
//  UserICOTableViewCell.m
//  FML
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "UserICOTableViewCell.h"

@interface UserICOTableViewCell()

@property (nonatomic, strong) UIImageView*  currencyIcon;
@property (nonatomic, strong) UILabel*      currencyName;
@property (nonatomic, strong) UILabel*      currencyNum;

@end

@implementation UserICOTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = ColorBg;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
        
    }
    return self;
}

- (void)setUI {
    UIImageView* baseView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, ScreenWidth - 30, 72)];
    baseView.backgroundColor = [UIColor clearColor];
    baseView.image = [UIImage imageNamed:@"layer"];
    [self.contentView addSubview:baseView];
    
    _currencyIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 40, 40)];
    _currencyIcon.backgroundColor = [UIColor clearColor];
    _currencyIcon.layer.masksToBounds = YES;
    _currencyIcon.layer.cornerRadius = 20;
    [baseView addSubview:_currencyIcon];
    
    _currencyName = [[UILabel alloc] initWithFrame:CGRectMake(RIGHT(_currencyIcon) + 15, 0, 100, 70)];
    _currencyName.text = @"EOS";
    _currencyName.textColor = Color1D;
    _currencyName.backgroundColor = [UIColor whiteColor];
    _currencyName.font = [UIFont systemFontOfSize:18];
    [baseView addSubview:_currencyName];
    
    _currencyNum = [[UILabel alloc] initWithFrame:CGRectMake(RIGHT(baseView) - 200 , 0, 145, 70)];
    _currencyNum.text = @"11111个";
    _currencyNum.textAlignment = NSTextAlignmentRight;
    _currencyNum.backgroundColor = [UIColor whiteColor];
    _currencyNum.textColor = Color1D;
    _currencyNum.font = [UIFont systemFontOfSize:18];
    [baseView addSubview:_currencyNum];
    
    UIImageView* imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_accesstype1"]];
    imageV.center = CGPointMake(RIGHT(baseView) - 35, 35);
    [baseView addSubview:imageV];
    [imageV sizeToFit];
}

- (void)setModel:(MyBranchListModel *)model {
    _model = model;
    _currencyNum.text = [NSString stringWithFormat:@"%.2f个", model.lockNumber];
    _currencyName.text = model.currencyName;
    [_currencyIcon sd_setImageWithURL:model.logo.toUrl];
}

@end

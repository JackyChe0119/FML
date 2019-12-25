//
//  BranchTableViewCell.m
//  FML
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "BranchTableViewCell.h"

@implementation BranchTableViewCell {
    
    __weak IBOutlet UIImageView *_userIcon;
    __weak IBOutlet UILabel *username;
    __weak IBOutlet UILabel *typename;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _userIcon.layer.cornerRadius = 15;
    _userIcon.layer.masksToBounds = YES;
//    _userIcon.
    _userIcon.backgroundColor = ColorGrayText;
    username.textColor = Color1D;
    typename.textColor = ColorGrayText;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(TeamUserModel *)model {
    _model = model;
    [_userIcon sd_setImageWithURL:model.picture.toUrl placeholderImage:[UIImage imageNamed:@"icon_default"]];
    username.text = model.nickName;
    if ([model.userType isEqualToString:@"one"]) {
        typename.text = @"子节点";
        typename.hidden = NO;
    } else if ([model.userType isEqualToString:@"two"]) {
        typename.text = @"";
        typename.hidden = NO;
    } else {
        typename.hidden = YES;
    }
}

@end

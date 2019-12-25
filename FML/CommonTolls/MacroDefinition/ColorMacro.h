//
//  ColorMaco.h
//  KongGeekSample
//
//  Created by Robin on 16/7/2.
//  Copyright © 2016年 KongGeek. All rights reserved.
//

#ifndef ColorMaco_h
#define ColorMaco_h

#define backUp @"icon_backup"
#define backUp_wihte @"icon_white_back"
// RGB
#define RGB_A(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
// 16进制颜色赋值
#define colorWithHexString(hex) [UIColor colorWithHexString:hex]
#define ColorWhite colorWithHexString(@"#ffffff")
#define ColorLine colorWithHexString(@"#e8e8e8")
#define ColorWith3 colorWithHexString(@"#333333")
#define ColorBlue colorWithHexString(@"#506afa")
#define ColorGray colorWithHexString(@"#ebebeb")
#define Color1D colorWithHexString(@"#1d2659")
#define Color4D colorWithHexString(@"#4d5066")
#define ColorGreen colorWithHexString(@"#00dc9d")
#define ColorGrayText colorWithHexString(@"#828599")
#define ColorBg colorWithHexString(@"#f8f8f8")
#define ColorRed colorWithHexString(@"#fd5353")

#endif /* ColorMaco_h */

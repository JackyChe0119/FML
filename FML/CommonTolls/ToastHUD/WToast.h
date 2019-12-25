//
//  WToast.h
//  MediaQRCode
//
//  Created by xiayp on 12-8-30.
//
//  HUD提示
//

#import <UIKit/UIKit.h>


typedef enum {
	kWTShort = 1,
	kWTLong = 5
} WToastLength;

@interface WToast : UIView

+ (void)showWithText:(NSString *)text;
+ (void)showWithImage:(UIImage *)image;

+ (void)showWithText:(NSString *)text length:(WToastLength)length;
+ (void)showWithImage:(UIImage *)image length:(WToastLength)length;

/**
 时间：20150414-zhaow
 自定义：显示图片和文本提示
 */
+ (void)showWithImage:(UIImage *)image withText:(NSString *)text;


@end

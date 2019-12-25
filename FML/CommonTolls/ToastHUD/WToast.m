//
//  WToast.m
//  MediaQRCode
//
//  Created by xiayp on 12-8-30.
//
//

#import "WToast.h"
#import <QuartzCore/QuartzCore.h>

#define TABBAR_OFFSET 44.0f

/* 快捷颜色设置 */
#define RGB(r, g, b)        [UIColor colorWithRed:(r / 255.0f) green:(g / 255.0f) blue:(b / 255.0f) alpha:1.0f]
#define RGBA(r, g, b, a)    [UIColor colorWithRed:(r / 255.0f) green:(g / 255.0f) blue:(b / 255.0f) alpha:a]

@interface WToast()

@property (nonatomic) NSInteger length;

@end


@implementation WToast

@synthesize length = _length;

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame]) != nil) {
		_length = kWTShort;
	}
	return self;
}

- (void)__show {
	[UIView animateWithDuration:0.2f
					 animations:^{
						 self.alpha = 1.0f;
					 }
					 completion:^(BOOL finished) {
						 [self performSelector:@selector(__hide) withObject:nil afterDelay:_length];
					 }];
}

- (void)__hide {
	[UIView animateWithDuration:0.8f
					 animations:^{
						 self.alpha = 0.0f;
					 }
					 completion:^(BOOL finished) {
						 [self removeFromSuperview];
#if !__has_feature(objc_arc)
						 [self release];
#endif
						 
					 }];
}

+ (WToast *)__createWithText:(NSString *)text {
	float screenWidth, screenHeight;
	CGSize screenSize = [UIScreen mainScreen].bounds.size;
	
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown: {
			screenWidth = MIN(screenSize.width, screenSize.height);
			screenHeight = MAX(screenSize.width, screenSize.height);
            break;
		}
        case UIInterfaceOrientationLandscapeLeft: {
            screenWidth = MAX(screenSize.width, screenSize.height);
			screenHeight = MIN(screenSize.width, screenSize.height);
            break;
		}
        case UIInterfaceOrientationLandscapeRight: {
			screenWidth = MAX(screenSize.width, screenSize.height);
			screenHeight = MIN(screenSize.width, screenSize.height);
            break;
		}
        default: {
            screenWidth = MIN(screenSize.width, screenSize.height);
			screenHeight = MAX(screenSize.width, screenSize.height);
            break;
		}
    }
	
	float x = 10.0f;
	float width = screenWidth - x * 2.0f;
    
	UILabel *textLabel = [[UILabel alloc] init];
	textLabel.backgroundColor = [UIColor clearColor];
	textLabel.textAlignment = NSTextAlignmentCenter;
	textLabel.font = [UIFont systemFontOfSize:18];
	textLabel.textColor = RGB(255, 255, 255);
	textLabel.numberOfLines = 0;
	//textLabel.lineBreakMode = UILineBreakModeWordWrap;
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize sz = [text boundingRectWithSize:CGSizeMake(width - 20.0f, 9999.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:textLabel.font} context:nil].size;
//	CGSize sz = [text sizeWithFont:textLabel.font
//				 constrainedToSize:CGSizeMake(width - 20.0f, 9999.0f)
//					 lineBreakMode:textLabel.lineBreakMode];
	CGRect tmpRect = CGRectZero;
    tmpRect.size.width = MIN(sz.width, width) + 20.0f;
    tmpRect.size.width = MAX(tmpRect.size.width, 180);
    //	tmpRect.size.width = width;
    //	tmpRect.size.height = MAX(sz.height + 20.0f, 38.0f);
    tmpRect.size.height = MAX(sz.height + 10.0f, 28.0f + 52);
    
	WToast *toast = [[WToast alloc] initWithFrame:tmpRect];
	toast.backgroundColor = RGBA(0, 0, 0, 0.60f);
	CALayer *layer = toast.layer;
	layer.masksToBounds = YES;
	layer.cornerRadius = 5.0f;
    
	textLabel.text = text;
	tmpRect.origin.x = floor((toast.frame.size.width - sz.width) / 2.0f);
	tmpRect.origin.y = floor((toast.frame.size.height - sz.height) / 2.0f);
	tmpRect.size = sz;
	textLabel.frame = tmpRect;
	[toast addSubview:textLabel];
#if !__has_feature(objc_arc)
	[textLabel release];
#endif
	
	toast.alpha = 0.0f;
    
	return toast;
}

+ (WToast *)__createWithImage:(UIImage *)image {
	float screenWidth, screenHeight;
	CGSize screenSize = [UIScreen mainScreen].bounds.size;
	
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown: {
			screenWidth = MIN(screenSize.width, screenSize.height);
			screenHeight = MAX(screenSize.width, screenSize.height);
            break;
		}
        case UIInterfaceOrientationLandscapeLeft: {
            screenWidth = MAX(screenSize.width, screenSize.height);
			screenHeight = MIN(screenSize.width, screenSize.height);
            break;
		}
        case UIInterfaceOrientationLandscapeRight: {
			screenWidth = MAX(screenSize.width, screenSize.height);
			screenHeight = MIN(screenSize.width, screenSize.height);
            break;
		}
        default: {
            screenWidth = MIN(screenSize.width, screenSize.height);
			screenHeight = MAX(screenSize.width, screenSize.height);
            break;
		}
    }
	
	float x = 10.0f;
	float width = screenWidth - x * 2.0f;
    
	UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	CGSize sz = imageView.frame.size;
    
	CGRect tmpRect = CGRectZero;
	tmpRect.size.width = width;
	tmpRect.size.height = MAX(sz.height + 20.0f, 38.0f);
    
	WToast *toast = [[WToast alloc] initWithFrame:tmpRect];
	toast.backgroundColor = RGBA(100, 100, 100, 1.0f);
	CALayer *layer = toast.layer;
	layer.masksToBounds = YES;
	layer.cornerRadius = 5.0f;
    
	tmpRect.origin.x = floor((toast.frame.size.width - sz.width) / 2.0f);
	tmpRect.origin.y = floor((toast.frame.size.height - sz.height) / 2.0f);
	tmpRect.size = sz;
	imageView.frame = tmpRect;
	[toast addSubview:imageView];
#if !__has_feature(objc_arc)
	[imageView release];
#endif
	
	toast.alpha = 0.0f;
	
	return toast;
}

+ (WToast *)__createWithImage:(UIImage *)image withText:(NSString *)text {
    float screenWidth, screenHeight;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown: {
            screenWidth = MIN(screenSize.width, screenSize.height);
            screenHeight = MAX(screenSize.width, screenSize.height);
            break;
        }
        case UIInterfaceOrientationLandscapeLeft: {
            screenWidth = MAX(screenSize.width, screenSize.height);
            screenHeight = MIN(screenSize.width, screenSize.height);
            break;
        }
        case UIInterfaceOrientationLandscapeRight: {
            screenWidth = MAX(screenSize.width, screenSize.height);
            screenHeight = MIN(screenSize.width, screenSize.height);
            break;
        }
        default: {
            screenWidth = MIN(screenSize.width, screenSize.height);
            screenHeight = MAX(screenSize.width, screenSize.height);
            break;
        }
    }
    
    CGRect tmpRect = CGRectZero;
    
    float width = 180;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    CGSize sz = imageView.frame.size;
    
    tmpRect.origin.x = floor((width - sz.width) / 2.0f);
    tmpRect.origin.y = image? 26.0f : 16.0f;
    tmpRect.size = sz;
    imageView.frame = tmpRect;
    
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont systemFontOfSize:16];
    textLabel.textColor = RGB(255, 255, 255);
    textLabel.numberOfLines = 0;
    //textLabel.lineBreakMode = UILineBreakModeWordWrap;
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    sz = [text boundingRectWithSize:CGSizeMake(width - 20.0f, 9999.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:textLabel.font} context:nil].size;

//    sz = [text sizeWithFont:textLabel.font
//          constrainedToSize:CGSizeMake(width - 20.0f, 9999.0f)
//              lineBreakMode:textLabel.lineBreakMode];
    sz.height = sz.height > 18 ?sz.height :18;
    
    textLabel.text = text;
    tmpRect.origin.x = floor((width - sz.width) / 2.0f);
    tmpRect.origin.y = CGRectGetMaxY(imageView.frame);
    tmpRect.size = sz;
    textLabel.frame = tmpRect;
    
    
    tmpRect.size.width = width;
    tmpRect.size.height = CGRectGetMaxY(textLabel.frame) + 16.0f;
    
    WToast *toast = [[WToast alloc] initWithFrame:tmpRect];
    toast.backgroundColor = RGBA(0, 0, 0, 0.60f);
    CALayer *layer = toast.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 5.0f;
    
    
    [toast addSubview:imageView];
#if !__has_feature(objc_arc)
    [imageView release];
#endif
    
    [toast addSubview:textLabel];
#if !__has_feature(objc_arc)
    [textLabel release];
#endif
    
    toast.alpha = 0.0f;
    
    return toast;
}


- (void)__flipViewAccordingToStatusBarOrientation {
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGFloat angle = 0.0;
	CGSize screenSize = [UIScreen mainScreen].bounds.size;
	float x, y;
	float screenWidth, screenHeight;
    
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown: {
            angle = M_PI;
			screenWidth = MIN(screenSize.width, screenSize.height);
			screenHeight = MAX(screenSize.width, screenSize.height);
			x = floor((screenWidth - self.bounds.size.width) / 2.0f);
            //			y = 15.0f + TABBAR_OFFSET;
            y = 10.0f + TABBAR_OFFSET;
            break;
		}
        case UIInterfaceOrientationLandscapeLeft: {
            angle = - M_PI / 2.0f;
			screenWidth = MAX(screenSize.width, screenSize.height);
			screenHeight = MIN(screenSize.width, screenSize.height);
            //			x = screenHeight - self.bounds.size.height - 15.0f - TABBAR_OFFSET;
            x = screenHeight - self.bounds.size.height - 10.0f - TABBAR_OFFSET;
			y = floor((screenWidth - self.bounds.size.width) / 2.0f);
            break;
		}
        case UIInterfaceOrientationLandscapeRight: {
            angle = M_PI / 2.0f;
			screenWidth = MAX(screenSize.width, screenSize.height);
			screenHeight = MIN(screenSize.width, screenSize.height);
            //			x = 15.0f + TABBAR_OFFSET;
            x = 10.0f + TABBAR_OFFSET;
			y = floor((screenWidth - self.bounds.size.width) / 2.0f);
            break;
		}
        default: {
            angle = 0.0;
			screenWidth = MIN(screenSize.width, screenSize.height);
			screenHeight = MAX(screenSize.width, screenSize.height);
			x = floor((screenWidth - self.bounds.size.width) / 2.0f);
            //			y = screenHeight - self.bounds.size.height - 15.0f - TABBAR_OFFSET;
            //y = screenHeight - self.bounds.size.height - 10.0f - TABBAR_OFFSET;
            y = floor((screenHeight - self.bounds.size.height) / 2.0f);
            
            break;
		}
    }
    
    self.transform = CGAffineTransformMakeRotation(angle);
    
	CGRect f = self.frame;
	f.origin = CGPointMake(x, y);
	self.frame = f;
}

/**
 * Show toast with text in application window
 * @param text Text to print in toast window
 */
+ (void)showWithText:(NSString *)text {
	[WToast showWithText:text length:kWTShort];
}

/**
 * Show toast with image in application window
 * @param image Image to show in toast window
 */
+ (void)showWithImage:(UIImage *)image {
	[WToast showWithImage:image length:kWTShort];
}

/**
 * Show toast with text in application window
 * @param text Text to print in toast window
 * @param length Toast visibility duration
 */
+ (void)showWithText:(NSString *)text length:(WToastLength)length {
	WToast *toast = [WToast __createWithText:text];
	toast.length = length;
	
	UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
	[mainWindow addSubview:toast];
	
	[toast __flipViewAccordingToStatusBarOrientation];
	[toast __show];
}

/**
 * Show toast with image in application window
 * @param image Image to show in toast window
 * @param length Toast visibility duration
 */
+ (void)showWithImage:(UIImage *)image length:(WToastLength)length {
	WToast *toast = [WToast __createWithImage:image];
	toast.length = length;
	
	UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
	[mainWindow addSubview:toast];
	
	[toast __flipViewAccordingToStatusBarOrientation];
	[toast __show];
}

/**
 时间：20150414-zhaow
 自定义：显示图片和文本提示
 */
+ (void)showWithImage:(UIImage *)image withText:(NSString *)text {
    WToast *toast = [WToast __createWithImage:image withText:text];
    
    UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
    [mainWindow addSubview:toast];
    
    [toast __flipViewAccordingToStatusBarOrientation];
    [toast __show];
}

@end

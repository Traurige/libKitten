#import <UIKit/UIKit.h>

@interface libKitten : NSObject
+ (UIColor *)backgroundColor:(UIImage *)image;
+ (UIColor *)primaryColor:(UIImage *)image;
+ (UIColor *)secondaryColor:(UIImage *)image;
+ (BOOL)isDarkImage:(UIImage *)image;
@end
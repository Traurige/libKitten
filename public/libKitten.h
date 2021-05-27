#import <UIKit/UIKit.h>

@interface libKitten : NSObject
+ (UIColor *)backgroundColor:(UIImage *)image;
+ (UIColor *)primaryColor:(UIImage *)image;
+ (UIColor *)secondaryColor:(UIImage *)image;
+ (UIColor *)getColorFromImage:(UIImage *)image calculation:(int)calculation dimension:(int)dimension flexibility:(int)flexibility range:(int)range;
+ (BOOL)isDarkImage:(UIImage *)image;
+ (BOOL)isDarkColor:(UIColor *)color;
@end
//
//  libKitten.m
//  libKitten
//
//  Created by Alexandra (@schneelittchen)
//

#import <UIKit/UIKit.h>

@interface libKitten : NSObject
+ (UIColor *)backgroundColor:(UIImage *)image;
+ (UIColor *)primaryColor:(UIImage *)image;
+ (UIColor *)secondaryColor:(UIImage *)image;
+ (BOOL)isDarkImage:(UIImage *)image;
+ (BOOL)isDarkColor:(UIColor *)color;
+ (UIColor *)getColorFromImage:(UIImage *)image calculation:(int)calculation dimension:(int)dimension flexibility:(int)flexibility range:(int)range;
@end
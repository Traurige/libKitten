#import "public/libKitten.h"

@implementation libKitten

+ (UIColor *)backgroundColor:(UIImage *)image {

    return [self getColorFromImage:image calculation:0 dimension:0 flexibility:0 range:0];

}

+ (UIColor *)primaryColor:(UIImage *)image {

    return [self getColorFromImage:image calculation:1 dimension:4 flexibility:1 range:100];
    
}

+ (UIColor *)secondaryColor:(UIImage *)image {

    return [self getColorFromImage:image calculation:1 dimension:9 flexibility:3 range:90];
    
}

+ (UIColor *)getColorFromImage:(UIImage *)image calculation:(int)calculation dimension:(int)dimension flexibility:(int)flexibility range:(int)range {

    if (calculation == 0) { // average
        // https://stackoverflow.com/a/13695592
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        unsigned char rgba[4];
        CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), [image CGImage]);
        CGColorSpaceRelease(colorSpace);
        CGContextRelease(context);
        if (rgba[3] > 0) {
            CGFloat alpha = ((CGFloat)rgba[3]) / 255.0;
            CGFloat multiplier = alpha / 255.0;
            return [UIColor colorWithRed:((CGFloat)rgba[0]) * multiplier green:((CGFloat)rgba[1]) * multiplier blue:((CGFloat)rgba[2]) * multiplier alpha:alpha];
        } else {
            return [UIColor colorWithRed:((CGFloat)rgba[0]) / 255.0 green:((CGFloat)rgba[1]) / 255.0 blue:((CGFloat)rgba[2]) / 255.0 alpha:((CGFloat)rgba[3]) / 255.0];
        }
    } else if (calculation == 1) { // primary or secondary
        // https://stackoverflow.com/a/29266983
        NSMutableArray* colors = [NSMutableArray new];
        CGImageRef imageRef = [image CGImage];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        unsigned char* rawData = (unsigned char *) calloc(dimension * dimension * 4, sizeof(unsigned char));
        NSUInteger bytesPerPixel = 4;
        NSUInteger bytesPerRow = bytesPerPixel * dimension;
        NSUInteger bitsPerComponent = 8;
        CGContextRef context = CGBitmapContextCreate(rawData, dimension, dimension, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        CGColorSpaceRelease(colorSpace);
        CGContextDrawImage(context, CGRectMake(0, 0, dimension, dimension), imageRef);
        CGContextRelease(context);

        float x = 0;
        float y = 0;

        for (int n = 0; n < (dimension * dimension); n++) {
            int index = (bytesPerRow * y) + x * bytesPerPixel;
            int red   = rawData[index];
            int green = rawData[index + 1];
            int blue  = rawData[index + 2];
            int alpha = rawData[index + 3];
            NSArray* a = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%i", red], [NSString stringWithFormat:@"%i", green], [NSString stringWithFormat:@"%i", blue], [NSString stringWithFormat:@"%i", alpha], nil];
            [colors addObject:a];
            y++;
            if (y == dimension){
                y = 0;
                x++;
            }
        }
        free(rawData);

        NSArray* copycolors = [NSArray arrayWithArray:colors];
        NSMutableArray* flexiblecolors = [NSMutableArray new];

        float flexFactor = flexibility * 2 + 1;
        float factor = flexFactor * flexFactor * 3;

        for (int n = 0; n < (dimension * dimension); n++){
            NSArray* pixelcolors = copycolors[n];
            NSMutableArray* reds = [NSMutableArray new];
            NSMutableArray* greens = [NSMutableArray new];
            NSMutableArray* blues = [NSMutableArray new];

            for (int p = 0; p < 3; p++){
                NSString* rgbStr = pixelcolors[p];
                int rgb = [rgbStr intValue];
                for (int f = - flexibility; f < flexibility + 1; f++){
                    int newRGB = rgb + f;
                    if (newRGB < 0)
                        newRGB = 0;
                    if (p == 0)
                        [reds addObject:[NSString stringWithFormat:@"%i", newRGB]];
                    else if (p == 1)
                        [greens addObject:[NSString stringWithFormat:@"%i", newRGB]];
                    else if (p == 2)
                        [blues addObject:[NSString stringWithFormat:@"%i", newRGB]];
                }
            }

            int r = 0;
            int g = 0;
            int b = 0;

            for (int k = 0; k < factor; k++) {
                int red = [reds[r] intValue];
                int green = [greens[g] intValue];
                int blue = [blues[b] intValue];

                NSString* rgbString = [NSString stringWithFormat:@"%i, %i, %i", red, green, blue];
                [flexiblecolors addObject:rgbString];

                b++;
                if (b == flexFactor) {
                    b = 0;
                    g++;
                }
                if (g == flexFactor) {
                    g = 0;
                    r++;
                }
            }
        }

        NSMutableDictionary* colorCounter = [NSMutableDictionary new];

        NSCountedSet* countedSet = [[NSCountedSet alloc] initWithArray:flexiblecolors];
        for (NSString* item in countedSet) {
            NSUInteger count = [countedSet countForObject:item];
            [colorCounter setValue:[NSNumber numberWithInteger:count] forKey:item];
        }

        NSArray* orderedKeys = [colorCounter keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2){
            return [obj2 compare:obj1];
        }];

        NSMutableArray* ranges = [NSMutableArray new];
        for (NSString* key in orderedKeys){
            NSArray* rgb = [key componentsSeparatedByString:@","];
            int r = [rgb[0] intValue];
            int g = [rgb[1] intValue];
            int b = [rgb[2] intValue];
            BOOL exclude = NO;
            for (NSString* ranged_key in ranges){
                NSArray* ranged_rgb = [ranged_key componentsSeparatedByString:@","];

                int ranged_r = [ranged_rgb[0] intValue];
                int ranged_g = [ranged_rgb[1] intValue];
                int ranged_b = [ranged_rgb[2] intValue];

                if (r >= ranged_r - range && r <= ranged_r + range)
                    if (g >= ranged_g - range && g <= ranged_g + range)
                        if (b >= ranged_b - range && b <= ranged_b + range)
                            exclude = YES;
            }
            if (!exclude) [ranges addObject:key];
        }

        NSMutableArray* colorArray = [NSMutableArray new];
        UIColor* color;
        for (NSString* key in ranges){
            NSArray* rgb = [key componentsSeparatedByString:@","];
            float r = [rgb[0] floatValue];
            float g = [rgb[1] floatValue];
            float b = [rgb[2] floatValue];
            color = [UIColor colorWithRed:(r / 255.0f) green:(g / 255.0f) blue:(b / 255.0f) alpha:1.0f];
            [colorArray addObject:color];
        }

        return color;
    }

    return [UIColor whiteColor];

}

// https://gist.github.com/justinHowlett/4611988
+ (BOOL)isDarkImage:(UIImage *)image {

    BOOL isDark = NO;

    CFDataRef imageData = CGDataProviderCopyData(CGImageGetDataProvider([image CGImage]));
    const UInt8* pixels = CFDataGetBytePtr(imageData);
    int darkPixels = 0;
    int length = CFDataGetLength(imageData);
    int const darkPixelThreshold = (image.size.width * image.size.height) * 0.45;

    for (int i = 0; i < length; i += 4) {
        int r = pixels[i];
        int g = pixels[i + 1];
        int b = pixels[i + 2];
        float luminance = (0.299 * r + 0.587 * g + 0.114 * b);
        if (luminance < 150) darkPixels++;
    }

    if (darkPixels >= darkPixelThreshold) isDark = YES;

    CFRelease(imageData);

    return isDark;

}

// https://gist.github.com/delputnam/2d80e7b4bd9363fd221d131e4cfdbd8f
+ (BOOL)isDarkColor:(UIColor *)color {
    
    if (!color) return YES;

    const CGFloat* components = CGColorGetComponents([color CGColor]);
    double brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000;
    
    if (brightness < 0.5)
        return YES;
    else
        return NO;
    
}

@end
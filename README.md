# libKitten 🐱
Library to calculate three different colors from an image or determine if an image/color is light or dark

## Installation
1. Add this repository to your package manager: `TBD`
2. Install libKitten

## Compatibility
iPhone, iPad, iPod and AppleTV running iOS/iPadOS/tvOS 12 or later

# Developers

## Installing Into Theos:
**Method 1:**<br>
Depending on your target system put the `.dylib` from either the `iOS` or `tvOS` folder into your `theos/lib` folder and the `Kitten` folder into `theos/include`
***
**Method 2:**<br>
Compile the project yourself and it'll do all that by itself

## Compiling
  - [Theos](https://theos.dev/) is required to compile the project
  - You may want to edit the root `Makefile` to use your Theos SDK and toolchain
  - Additionally to compile for tvOS:
    - Make sure you're using a tvOS SDK
    - Change the target from `iphone:clang` to `appletv:clang` in the root `Makefile`
    - Change the architecture `iphoneos-arm` to `appletvos-arm64` in the control file

## Importing Into Your Project:
1. Import the library in your header or main file `#import <Kitten/libKitten.h>`
2. Add the library to your Makefile `TWEAK_NAME_LIBRARIES = kitten`. If you get a linker issue, try writing`Kitten`, capitalizing the k.
3. Make libKitten a dependency of your tweak in your control file `Depends: love.litten.libkitten`<br>

## Usage:
Available methods are:

```objc
+ (UIColor *)backgroundColor:(UIImage *)image;
+ (UIColor *)primaryColor:(UIImage *)image;
+ (UIColor *)secondaryColor:(UIImage *)image;
+ (BOOL)isDarkImage:(UIImage *)image;
+ (BOOL)isDarkColor:(UIColor *)color;
```

They can all be used the same way: `[libKitten backgroundColor:YOUR_IMAGE];`

## Example

```objc
#import <Kitten/libKitten.h>

%group ExampleTweak

%hook someHook

- (void)someMethod {

 	%orig;

 	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(200, 200, 200, 200)];
	[label setText:@"some text"];
	
	UIImage* image = [UIImage imageWithContentsOfFile:@"pathToImage"];
 	[label setTextColor:[libKitten secondaryColor:image]];
	
	[self addSubview:label];

}

%end

%end

%ctor {

 	%init(ExampleTweak);

}
```

## License
libKitten is licensed under the MIT license

## Credits
  - Links to the original sources are included within the source code

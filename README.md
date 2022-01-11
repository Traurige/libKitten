# libKitten
Library to calculate three different colors from an image or determine if an image/color is light or dark

## Installation
1. Add this repository to your package manager: `TBD`
2. Install libKitten

## Compiling
  - [Theos](https://theos.dev/) is required to compile the project
  - You may want to edit the root `Makefile` to use your Theos SDK and toolchain

## License
Since this library is made from open source code you can freely take whatever you need<br>
You may not redistribute this source code or packages from it<br>
You may not use this project to make profit like money

## Credits
  - Links to the original sources are included within the source code

# Developers

## Theos Installation:
Download this repository and navigate into either iOS or tvOS depending on your target system, then put the .dylib into your theos/lib folder and the Kitten folder into your theos/include folder

## Importing Into Your Project:
Import the library in your header or main file `#import <Kitten/libKitten.h>`<br>
Add the library to your Makefile `TWEAK_NAME_LIBRARIES = kitten`<br>
Make libKitten a dependency of your tweak in your control file `Depends: love.litten.libkitten`<br>

## Usage:
You can create variables to use later on like this:<br>
`UIColor* backgroundColor = [libKitten backgroundColor:theImageYouWantToCalculate];`<br>
`UIColor* primaryColor = [libKitten primaryColor:theImageYouWantToCalculate];`<br>
`UIColor* secondaryColor = [libKitten secondaryColor:theImageYouWantToCalculate];`<br>
The parameter "theImageYouWantToCalculate" is the UIImage you want to get the color from; Now you can just use it wherever you need it
<br><br>
You don't have to create variables of course, `[label setTextColor:[libKitten primaryColor:theImageYouWantToCalculate]];` works as well

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

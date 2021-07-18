# libKitten
Library to get three different colors from an image and detect if one is light or dark from open source code

## How to use

### Installation:
Download this repository and navigate into either iOS or tvOS depending on your target system, then put the .dylib into your theos/lib folder and the Kitten folder into your theos/include folder

### Importing:
Import the library in your header or main file `#import <Kitten/libKitten.h>`<br>
Add the library to your Makefile `$(TWEAK_NAME)_LIBRARIES = kitten`<br>
Make libKitten a dependency of your tweak in your control file `Depends: love.litten.libkitten`<br>
Make sure the user also adds my repo (https://repo.litten.love) to be able to download it

### Usage:
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

## License
Since this library is made from open source code you can freely take whatever you need

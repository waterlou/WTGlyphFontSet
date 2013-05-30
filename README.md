WTGlyphFontSet
==============

- Easily use free webfont icons in your iOS projects
- No setup on the Info.plist
- drawRect or generate an image in arbitary size
- As easy as using [UIImage imageNamed:]
- Cocoapods support
- support normal or retina display
- less images on your app to keep your app size small

![screenshot](https://github.com/waterlou/WTGlyphFontSet/raw/master/screenshot.png)
![screenshot](https://github.com/waterlou/WTGlyphFontSet/raw/master/screenshot2.png)

### How to use (Complicated method)

##### Load font

	[WTGlyphFontSet loadFont:@"general_foundicons" filename:@"general_foundicons.ttf"];

that will load the font into the system, the first parameter is the name of the font that will be used in further operations.

then you can load the fontset anytime using the font set name:

	[WTGlyphFontSet fontSet:@"general_foundicons"];

You are allowed to load multiple fonts.

##### Draw font

You can draw the glyph directly to current context:

	- (void)drawAtRect:(CGRect)rect name:(NSString*)name color:(UIColor*)color;
	- (void)drawAtRect:(CGRect)rect name:(NSString*)name color:(UIColor*)color
	         alignment:(NSTextAlignment) alignment verticalAlignment:(NSVerticalTextAlignment)verticalAlignment;
	- (void)drawAtRect:(CGRect)rect name:(NSString*)name fontSize:(CGFloat)fontSize color:(UIColor*)color
	       strokeColor:(UIColor*)strokeColor strokeWidth:(CGFloat)strokeWidth
	         alignment:(NSTextAlignment) alignment verticalAlignment:(NSVerticalTextAlignment)verticalAlignment;

##### Create image

	- (UIImage*) image:(CGSize)size name:(NSString*)name color:(UIColor*)color;
	- (UIImage*) image:(CGSize)size name:(NSString*)name color:(UIColor*)color
	         alignment:(NSTextAlignment) alignment verticalAlignment:(NSVerticalTextAlignment) verticalAlignment;
	- (UIImage*) image:(CGSize)size name:(NSString*)name fontSize:(CGFloat)fontSize color:(UIColor*)color
	       strokeColor:(UIColor*)strokeColor strokeWidth:(CGFloat)strokeWidth
	         alignment:(NSTextAlignment) alignment verticalAlignment:(NSVerticalTextAlignment) verticalAlignment;

##### Create image with height only

You can also only provide the height of the image and width will be calculate according to the width of glyph:

	- (UIImage*) imageWithHeight:(CGFloat)height name:(NSString*)name color:(UIColor*)color;
	- (UIImage*) imageWithHeight:(CGFloat)height name:(NSString*)name
	                       color:(UIColor*)color verticalAlignment:(NSVerticalTextAlignment) verticalAlignment;
	- (UIImage*) imageWithHeight:(CGFloat)height name:(NSString*)name fontSize:(CGFloat)fontSize color:(UIColor*)color
	                 strokeColor:(UIColor*)strokeColor strokeWidth:(CGFloat)strokeWidth
	           verticalAlignment:(NSVerticalTextAlignment) verticalAlignment;

#### Example

    // load the font first
	[WTGlyphFontSet loadFont:@"general_foundicons" filename:@"general_foundicons.ttf"];
    // generate an image
    UIImage *image = [[WTGlyphFontSet fontSet: @"general_foundicons] image : CGSizeMake(48, 48) name : @"location" color : [UIColor blackColor]];
    // draw directly on screen
    [[WTGlyphFontSet fontSet: @"general_foundicons] drawAtRect : CGRectMake(0, 0, 100, 100) name : @"left-arrow" color : [UIColor whiteColor]];

### Glyph name

Some free fonts is included in this project.  You can also browser all available icons in the demo project.  For each font, a plist name of the same name is included that is the glyph name - character code mapping dictionary. You can get the glyph using the glyph name.  You can check the list of glyph name in the plist or view in the demo project directly.

### How to use (Simple method)

To simpify the procedure to get the glyph, a set of helpers are created.  In the complicated method, you have to get the fontset and then get the glyph using the glyph name.  In simplifed way, the glyph name will become something like:

	"fontawesome##h-sign"
	
where fontawesome is the file name of the true type font (this helper will only support .ttf only, not support .otf) and h-sign is the glyph name.  Helper class will load font set automatically.

If you mainly uses one set of icons, you can set default font set:

	[WTGlyphFontSet setDefaultFontSetName: @"fontawesome"];

and then call function without the fontset name prefix, e.g.:

	[WTGlyphFontSet setDefaultFontSetName: @"icomoon"];
	UIImage image = [UIImage imageGlyphNamed:@"apple" height:64.0f color:[UIColor darkGrayColor]];
	
that is equal to:

	UIImage image = [UIImage imageGlyphNamed:@"icomoon##apple" height:64.0f color:[UIColor darkGrayColor]];

#####Create an image

	UIImage image = [UIImage imageGlyphNamed:@"icomoon##apple" height:64.0f color:[UIColor darkGrayColor]];
	
or

	UIImage image = [UIImage imageGlyphNamed:@"icomoon##apple" size:CGSizeMake(64,64) color:[UIColor darkGrayColor]];
	
Noted that the image will be cached like [UIImage imageNamed:].
	
#####Set button icon

	[self.button2 setGlyphNamed:@"fontawesome##h-sign"];
	
Glyph color will match the font text color in all state.  Glyph size will be the same as the button font size.
	
#####Set left view of a text field

	[self.textField2 setLeftGlyph:@"fontawesome##credit-card" color:[UIColor colorWithWhite:0.5 alpha:1.0]];
	
#####Get attributed text

	NSMutableAttributedString *str = [NSMutableAttributedString attributedStringWithGlyph:@"credit-card" fontSize:self.label1.font.pointSize];
	
Noted that get attributed text will register the font to UIKit as a side effect.

### Register font to UIKit

The class uses CoreText to draw glyph, so it will not register the font to UIKit.  If you want to use the font like all other standard font, you can call:

	UIFont *uiFont = [fontSet uiFontWithSize:12.0f];

that it will register the font to UIKit and you can get the UIFont object for further processing.

### Custom font glyphs

Check [icomoon.io](http://icomoon.io) for creating custom icon fonts

Also check [fontcustom.com](http://fontcustom.com) for building custom font from svg.

Check the folder fontcustom in the demo project, where contains a script in node.js that convert the .css file to .plist automatically.

### Use it on cocoapods

To use the code, the easiest way is using [cocoapods](http://cocoapods.org).  Simply add the line to PodFile:

	pod 'WTGlyphFontSet'
	
If you want to use fonts (wpzoom in this example) in the repo, you can:

	pod 'WTGlyphFontSet'
	pod 'WTGlyphFontSet/wpzoom'

### Contribution

If you found any other good free webfonts, please create the .plist for the font and contribute to this repo.

### License

These codes are available under the [MIT license](http://www.opensource.org/licenses/mit-license.php).
Please read license for individual fonts if you plan to use it. 


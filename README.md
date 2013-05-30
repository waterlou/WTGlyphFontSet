WTGlyphFontSet
==============

- easily use free webfont icons in your iOS projects
- drawRect or generate an image in arbitary size
- support retina display

![screenshot](https://github.com/waterlou/WTGlyphFontSet/raw/master/screenshot.png)
![screenshot](https://github.com/waterlou/WTGlyphFontSet/raw/master/screenshot2.png)

### How to use (Complicated ways)

##### Setup
e
	[WTGlyphFontSet loadFont:@"general_foundicons" filename:@"general_foundicons.ttf"];

that will load the font into the system, the first parameter is the name of the font that will be used in further operations.

then you can load the fontset anytime using the font set name:

	[WTGlyphFontSet fontSet:@"general_foundicons"];

##### Draw font

You can draw the glyph directly to current context:

	- (void)drawAtRect:(CGRect)rect name:(NSString*)name color:(UIColor*)color;
	- (void)drawAtRect:(CGRect)rect name:(NSString*)name color:(UIColor*)color
	         alignment:(NSTextAlignment) alignment verticalAlignment:(NSVerticalTextAlignment)verticalAlignment;
	- (void)drawAtRect:(CGRect)rect name:(NSString*)name fontSize:(CGFloat)fontSize color:(UIColor*)color
	       strokeColor:(UIColor*)strokeColor strokeWidth:(CGFloat)strokeWidth
	         alignment:(NSTextAlignment) alignment verticalAlignment:(NSVerticalTextAlignment)verticalAlignment;

##### Create Image

	- (UIImage*) image:(CGSize)size name:(NSString*)name color:(UIColor*)color;
	- (UIImage*) image:(CGSize)size name:(NSString*)name color:(UIColor*)color
	         alignment:(NSTextAlignment) alignment verticalAlignment:(NSVerticalTextAlignment) verticalAlignment;
	- (UIImage*) image:(CGSize)size name:(NSString*)name fontSize:(CGFloat)fontSize color:(UIColor*)color
	       strokeColor:(UIColor*)strokeColor strokeWidth:(CGFloat)strokeWidth
	         alignment:(NSTextAlignment) alignment verticalAlignment:(NSVerticalTextAlignment) verticalAlignment;

##### Create Image with height only

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

Some free fonts is included in this project.  You can also browser all available icons in the demo project.  For each font, a plist name of the same name is included that is the glyph name - character code mapping dictionary. You can get the glyph using the glyph name.  You can check the list of glyph name in the plist or view  in the demo project directly.

### How to use (Simple ways)

To simpify the procedure to get the glyph, a set of helpers are created.  In the complicated way, you have to get the fontset and then get the glyph using the glyph name.  In simplifed way, the glyph name will become something like:

	"fontawesome##h-sign"
	
where fontawesome is the file name of the true type font (this helper will only support .ttf only) and h-sign is the glyph name.  Helper class will load font set automatically.

If you mainly use one set of icons, you can call:

	[WTGlyphFontSet setDefaultFontSetName: @"fontawesome"];

and then call function without the fontset name prefix, e.g.:

	[WTGlyphFontSet setDefaultFontSetName: @"icomoon"];
	UIImage image = [UIImage imageGlyphNamed:@"apple" height:64.0f color:[UIColor darkGrayColor]];
	
is equal to:

	UIImage image = [UIImage imageGlyphNamed:@"icomoon##apple" height:64.0f color:[UIColor darkGrayColor]];



#####Create an image

	UIImage image = [UIImage imageGlyphNamed:@"icomoon##apple" height:64.0f color:[UIColor darkGrayColor]];
	
Noted that the image if cached like [UIImage imageNamed:].
	
#####Set button icon

	[self.button2 setGlyphNamed:@"fontawesome##h-sign"];
	
#####Set left view of a text field

	[self.textField2 setLeftGlyph:@"fontawesome##credit-card" color:[UIColor colorWithWhite:0.5 alpha:1.0]];
	
#####Get attributed text

	NSMutableAttributedString *str = [NSMutableAttributedString attributedStringWithGlyph:@"credit-card" fontSize:self.label1.font.pointSize];

### Custom Font Glyphs

Check [icomoon.io](http://icomoon.io) for creating custom icon fonts

Also check [fontcustom.com](http://fontcustom.com) for building custom font from svg.

Check the folder fontcustom in the demo project, where contains a script in node.js that convert the .css file to .plist automatically.

### License

These codes are available under the [MIT license](http://www.opensource.org/licenses/mit-license.php).
Please read license for individual fonts if you plan to use it. 


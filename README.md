WTGlyphFontSet
==============

- easily use free webfont icons in your iOS projects
- drawRect or generate an image in arbitary size
- support retina display

### How to use

##### Setup
	[WTGlyphFontSet loadFont:@"general_foundicons" filename:@"general_foundicons.ttf"];

that will load the font into the system, the first parameter is the name of the font that will be used in further operations.

##### Draw font

You can draw the glyph directly to current context:

    - (void)drawAtRect:(CGRect)rect name:(NSString*)name color : (UIColor*)color;
    - (void)drawAtRect : (CGRect)rect name : (NSString*)name color : (UIColor*)color
             alignment : (NSTextAlignment) alignment verticalAlignment : (NSVerticalTextAlignment) verticalAlignment;

Or create an image directly:

    - (UIImage*) image : (CGSize)size name : (NSString*)name color : (UIColor*)color;
    - (UIImage*) image : (CGSize)size name : (NSString*)name color : (UIColor*)color inset : (CGFloat) inset
             alignment : (NSTextAlignment) alignment verticalAlignment : (NSVerticalTextAlignment) verticalAlignment;

#### Example
    // load the font first
	[WTGlyphFontSet loadFont:@"general_foundicons" filename:@"general_foundicons.ttf"];
    // generate an image
    UIImage *image = [[WTGlyphFontSet fontSet: @"general_foundicons] image : CGSizeMake(48, 48) name : @"location" color : [UIColor blackColor]];
    // draw directly on screen
    [[WTGlyphFontSet fontSet: @"general_foundicons] drawAtRect : CGRectMake(0, 0, 100, 100) name : @"left-arrow" color : [UIColor whiteColor] alignment : NSTextAlignmentCenter verticalAlignment : NSVerticalAlignmentDefault];

### Glyph name
Some free fonts is included in this project.  You can also browser all available icons in the demo project.  For each font, a plist name of the same name is included that is the glyph name - character code mapping dictionary. You can get the glyph using the glyph name.  You can check the list of glyph name in the plist or view  in the demo project directly.

### Alignment

Be default, the font will be horizontal center aligned and vertical align to the base line of the font.  So in some case, you will found that the icon is not aligned to the center of the draw rectangle.  If you want to do so, you can set the verticalAlignment to NSVerticalTextAlignmentCenter.  Also you can left, right, top, bottom align the icon if you want to do so.

Sometimes, the font will be drawn outside the bounding box of the font, so you will see some part of the icon will be missing if you generate it to an image.  Then you may have to set the inset when generate the image.

### License

These codes are available under the [MIT license](http://www.opensource.org/licenses/mit-license.php).
Please read license for individual fonts if you plan to use it. 


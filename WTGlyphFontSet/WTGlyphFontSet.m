//
//  WTGlyphFontSet.m
//  WTGlyphFontSetDemo
//
//  Created by Water Lou on 28/11/12.
//  Copyright (c) 2012 First Water Tech Ltd. All rights reserved.
//

#import "WTGlyphFontSet.h"

@interface WTGlyphFontSet()

+ (NSString *) parseFontName:(NSString**)name;

@end

@implementation WTGlyphFontSet {
    NSDictionary *_glyphLookup;
}

static NSMutableDictionary *glyphFonts = nil;

+ (WTGlyphFontSet*) loadFont:(NSString*)fontname filename:(NSString*)filename
{
    WTGlyphFontSet *loadedFont = [[self class] fontSet: fontname];
    if (loadedFont) return loadedFont;  // font already loaded
    
    NSArray *fileComponent = [filename componentsSeparatedByString:@"."];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        glyphFonts = [[NSMutableDictionary alloc] initWithCapacity:4];
    });
    WTGlyphFontSet *newGlyph = [glyphFonts objectForKey: fontname];
    if (newGlyph!=nil) {
        // font is already defined
        return newGlyph;
    }
    newGlyph = [[WTGlyphFontSet alloc] initWithFontName:fileComponent[0] ofType:fileComponent[1]];
    [glyphFonts setObject:newGlyph forKey:fontname];
    return newGlyph;
}

+ (WTGlyphFontSet*) fontSet : (NSString*) fontname
{
    return [glyphFonts objectForKey: fontname];
}

- (id)initWithFontName:(NSString *)aName ofType:(NSString *)aType {
    self = [super init];
    if (self) {
        NSString *fontPath = [[NSBundle mainBundle] pathForResource:aName ofType:aType];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:aName ofType:@"plist"];
        
        //NSURL * url = [[NSBundle mainBundle] URLForResource:aName withExtension:aType];
		//CGDataProviderRef fontProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)url);
        
        NSData *data = [[NSData alloc] initWithContentsOfFile:fontPath];
        CGDataProviderRef fontProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
        
        _glyphLookup = [[NSDictionary alloc] initWithContentsOfFile: plistPath];
        NSAssert(_glyphLookup!=nil, @"plist for glyph font %@ not found", aName);
        
        CGFontRef cgFont = CGFontCreateWithDataProvider(fontProvider);
        CGDataProviderRelease(fontProvider);

        /* register to use as uifont
		CFErrorRef error;
        CTFontManagerRegisterGraphicsFont(cgFont, &error);
         */
        
        CTFontDescriptorRef fontDescriptor = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)@{});
        _font = CTFontCreateWithGraphicsFont(cgFont, 0, NULL, fontDescriptor);
        CFRelease(fontDescriptor);
        CGFontRelease(cgFont);
        
        self.baseline = 0.2;
        
        //self.insets = UIEdgeInsetsMake(8, 8, 8, 8);
        

    }
    return self;
}

- (void) dealloc{
    CFRelease(_font);
}

#pragma mark -


- (CGFloat) fontSizeFromHeight:(CGFloat)height
{
    return height - _insets.top - _insets.bottom;
}

- (UIFont*) uiFontWithSize:(CGFloat)fontSize
{
	@synchronized(self) {
        if (_uiFontName) {
            return [UIFont fontWithName:_uiFontName size:fontSize];
        }
        CTFontDescriptorRef fontDescriptor;
        CGFontRef cgFont = CTFontCopyGraphicsFont (_font, &fontDescriptor);
        
        _uiFontName = CFBridgingRelease(CGFontCopyPostScriptName(cgFont));
        
        CFErrorRef error;
        CTFontManagerRegisterGraphicsFont(cgFont, &error);
        CGFontRelease(cgFont);
        
        return [UIFont fontWithName:_uiFontName size:fontSize];
    }
}

- (NSString*) code : (NSString*) name
{
    return _glyphLookup[name];
}

- (CGFloat) widthForIconWithFontSize:(CGFloat)fontSize name:(NSString*)name
{
    NSString *iconString = _glyphLookup[name];
    if (iconString==nil) return 0;
    CTFontRef sizedFont = CTFontCreateCopyWithAttributes(_font, fontSize, NULL, NULL);
   
    NSDictionary *attributesDict = @{(NSString*)kCTFontAttributeName:(__bridge id)sizedFont};
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]
                                             initWithString:iconString
                                             attributes:attributesDict];
    
    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef) attrString);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGRect imageBounds = CTLineGetImageBounds(line, context);
    UIGraphicsEndImageContext();
    CFRelease(line);
    CFRelease(sizedFont);
    return imageBounds.origin.x * 2 + imageBounds.size.width + _insets.left + _insets.right;
}

#pragma mark -

- (void)drawAtRect:(CGRect)rect name:(NSString*)name color:(UIColor*)color
{
    [self drawAtRect:rect name:name color:color
           alignment:NSTextAlignmentCenter verticalAlignment:NSVerticalTextAlignmentCenter];
}

- (void)drawAtRect:(CGRect)rect name:(NSString*)name color:(UIColor*)color
         alignment:(NSTextAlignment) alignment verticalAlignment:(NSVerticalTextAlignment)verticalAlignment
{
    [self drawAtRect:rect name:name fontSize:0.0 color:color strokeColor:nil strokeWidth:0.0f alignment:alignment verticalAlignment:verticalAlignment];
}

- (void)drawAtRect:(CGRect)rect name:(NSString*)name fontSize:(CGFloat)fontSize color:(UIColor*)color
       strokeColor:(UIColor*)strokeColor strokeWidth:(CGFloat)strokeWidth
         alignment:(NSTextAlignment) alignment verticalAlignment:(NSVerticalTextAlignment)verticalAlignment
{
    NSString *iconString = _glyphLookup[name];
    if (iconString==nil) return;    // glyph not found
  
    if (fontSize==0.0) fontSize = [self fontSizeFromHeight:rect.size.height];

    // inset rect referring to glyphset setting
    rect = UIEdgeInsetsInsetRect(rect, self.insets);

    // create a font with correct size
    CTFontRef sizedFont = CTFontCreateCopyWithAttributes(_font, fontSize, NULL, NULL);
    
    if (color!=nil && strokeWidth>0) strokeWidth = -strokeWidth;
    
    NSMutableDictionary *attributesDict = [NSMutableDictionary dictionaryWithDictionary:
                                           @{(NSString*)kCTFontAttributeName:(__bridge id)sizedFont}];
    if (color) [attributesDict setObject:(__bridge id)color.CGColor forKey:(NSString*)kCTForegroundColorAttributeName];
    if (strokeWidth!=0.0) [attributesDict setObject:[NSNumber numberWithFloat:strokeWidth] forKey:(NSString*)kCTStrokeWidthAttributeName];
    if (strokeColor) [attributesDict setObject:(__bridge id)strokeColor.CGColor forKey:(NSString*)kCTStrokeColorAttributeName];

    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]
                                      initWithString:iconString
                                      attributes:attributesDict];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef) attrString);
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    CGContextTranslateCTM(context, rect.origin.x, rect.size.height+rect.origin.y);
    CGContextScaleCTM(context, 1, -1);
    
    float flush = 0.5; // centered
    if (alignment==NSTextAlignmentLeft) flush = 0.0;
    else if (alignment==NSTextAlignmentRight) flush = 1.0;
    CGFloat yOffset;
    CGRect imageBounds;
    switch (verticalAlignment) {
        case NSVerticalTextAlignmentCenter:
            imageBounds = CTLineGetImageBounds(line, context);
            yOffset = (rect.size.height - imageBounds.size.height)/2.0 - imageBounds.origin.y; break;
        case NSVerticalTextAlignmentTop:
            imageBounds = CTLineGetImageBounds(line, context);
            yOffset = rect.size.height - imageBounds.size.height - imageBounds.origin.y; break;
        case NSVerticalTextAlignmentBottom:
            imageBounds = CTLineGetImageBounds(line, context);
            yOffset = -imageBounds.origin.y; break;
        case NSVerticalTextAlignmentManualBaseline:
            yOffset = rect.size.height * self.baseline;
            break;
        default:
        {
            CGFloat descent, ascent, leading;
            CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            yOffset = leading+descent;
        } break;
    }
    //NSLog(@"yOffset = %f, %@", yOffset, NSStringFromCGRect(imageBounds));
    double penOffset = CTLineGetPenOffsetForFlush(line, flush, rect.size.width);
    CGContextSetTextPosition(context, penOffset, yOffset);
    
    CTLineDraw(line, context);
    CFRelease(line);
    CFRelease(sizedFont);
}

- (UIImage*) image:(CGSize)size name:(NSString*)name color:(UIColor*)color
{
    return [self image:size name:name color:color
             alignment:NSTextAlignmentCenter verticalAlignment:NSVerticalTextAlignmentCenter];
}

- (UIImage*) image:(CGSize)size name:(NSString*)name color:(UIColor*)color
         alignment:(NSTextAlignment) alignment verticalAlignment:(NSVerticalTextAlignment) verticalAlignment
{
    return [self image:size name:name fontSize:0.0 color:color strokeColor:nil strokeWidth:0.0f alignment:alignment verticalAlignment:verticalAlignment];
}

- (UIImage*) image:(CGSize)size name:(NSString*)name fontSize:(CGFloat)fontSize color:(UIColor*)color
       strokeColor:(UIColor*)strokeColor strokeWidth:(CGFloat)strokeWidth
         alignment:(NSTextAlignment) alignment verticalAlignment:(NSVerticalTextAlignment) verticalAlignment
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    [color setFill];
    [self drawAtRect:CGRectMake(0,0,size.width,size.height) name:name fontSize:fontSize color:color strokeColor:strokeColor strokeWidth:strokeWidth alignment:alignment verticalAlignment:verticalAlignment];
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ret;
}

- (UIImage*) imageWithHeight:(CGFloat)height name:(NSString*)name color:(UIColor*)color
{
    return [self imageWithHeight:height name:name color:color
               verticalAlignment:NSVerticalTextAlignmentCenter];
}

- (UIImage*) imageWithHeight:(CGFloat)height name:(NSString*)name
                       color:(UIColor*)color verticalAlignment:(NSVerticalTextAlignment) verticalAlignment
{
    return [self imageWithHeight:height name:name fontSize:0.0 color:color
                     strokeColor:nil strokeWidth:0.0f verticalAlignment:verticalAlignment];
}

- (UIImage*) imageWithHeight:(CGFloat)height name:(NSString*)name fontSize:(CGFloat)fontSize color:(UIColor*)color 
                 strokeColor:(UIColor*)strokeColor strokeWidth:(CGFloat)strokeWidth
                       verticalAlignment:(NSVerticalTextAlignment) verticalAlignment
{
    if (fontSize==0.0) fontSize = [self fontSizeFromHeight:height];
    CGSize size = CGSizeMake([self widthForIconWithFontSize:fontSize name:name], height);
    if (size.width>0)
        return [self image:size name:name fontSize:fontSize color:color strokeColor:strokeColor strokeWidth:strokeWidth alignment:NSTextAlignmentLeft verticalAlignment:verticalAlignment];
    return nil; // glyph not found
}

#pragma mark -

#pragma mark - helpers

- (void) setTextFieldLeftView:(UITextField*)textField name:(NSString*)name color:(UIColor*)color
{
    CGFloat height = textField.font.lineHeight;
    CGFloat fontSize = textField.font.pointSize;
    CGFloat width = ceilf(fmaxf(height, [self widthForIconWithFontSize:fontSize name:name]));
    NSAssert(width>0.0, @"glyph name not found");
    CGSize size = CGSizeMake(width, height);
    UIImage *image = [self image:size name:name fontSize:fontSize color:color strokeColor:nil strokeWidth:0.0f alignment:NSTextAlignmentCenter verticalAlignment:NSVerticalTextAlignmentCenter];
    textField.leftView = [[UIImageView alloc] initWithImage: image];
}

- (void) setTextFieldRightView:(UITextField*)textField name:(NSString*)name color:(UIColor*)color
{
    CGFloat height = textField.font.lineHeight;
    CGFloat fontSize = textField.font.pointSize;
    CGFloat width = ceilf(fmaxf(height, [self widthForIconWithFontSize:fontSize name:name]));
    NSAssert(width>0.0, @"glyph name not found");
    CGSize size = CGSizeMake(width, height);
    UIImage *image = [self image:size name:name fontSize:fontSize color:color strokeColor:nil strokeWidth:0.0f alignment:NSTextAlignmentCenter verticalAlignment:NSVerticalTextAlignmentCenter];
    textField.rightView = [[UIImageView alloc] initWithImage: image];
}

- (void) setButtonImage:(UIButton*)button name:(NSString*)name
{
    CGFloat height = button.titleLabel.font.lineHeight;
    CGFloat fontSize = button.titleLabel.font.pointSize;
    CGFloat width = ceilf(fmaxf(height, [self widthForIconWithFontSize:fontSize name:name]));
    NSAssert(width>0.0, @"glyph name not found");
    CGSize size = CGSizeMake(width, height);
    [button setImage:[self image:size name:name fontSize:fontSize color:[button titleColorForState:UIControlStateNormal] strokeColor:nil strokeWidth:0.0f alignment:NSTextAlignmentCenter verticalAlignment:NSVerticalTextAlignmentManualBaseline] forState:UIControlStateNormal];
    [button setImage:[self image:size name:name fontSize:fontSize  color:[button titleColorForState:UIControlStateHighlighted] strokeColor:nil strokeWidth:0.0f alignment:NSTextAlignmentCenter verticalAlignment:NSVerticalTextAlignmentManualBaseline] forState:UIControlStateHighlighted];
    [button setImage:[self image:size name:name fontSize:fontSize  color:[button titleColorForState:UIControlStateDisabled] strokeColor:nil strokeWidth:0.0f alignment:NSTextAlignmentCenter verticalAlignment:NSVerticalTextAlignmentManualBaseline] forState:UIControlStateDisabled];
}

#pragma mark -

static NSString *__fontSetName = nil;

+ (void) setDefaultFontSetName:(NSString*)fontSetName
{
    __fontSetName = fontSetName;
}
+ (NSString*) defaultFontSetName
{
    return __fontSetName;
}

+ (NSString *) parseFontName:(NSString**)name
{
    NSString *fontSetName;
    NSArray *breakName = [*name componentsSeparatedByString: @"##"];
    if (breakName.count==2) {
        fontSetName = breakName[0];
        *name = breakName[1];
    }
    else {
        fontSetName = [WTGlyphFontSet defaultFontSetName];
        if (fontSetName==nil) {
            NSLog(@"No font set is specified");
            return nil;
        }
    }
    return fontSetName;    
}

@end


@implementation UIImage(WTGlyphFontSet)

static CGFloat gHeight;
static UIColor *gColor;

+ (void) setImageGlyphHeight:(CGFloat)height color:(UIColor*)color
{
    gHeight = height;
    gColor = color;
}

+ (UIImage*) imageGlyphNamed:(NSString *)name
{
    if (gColor==nil) gColor = [UIColor darkGrayColor];
    if (gHeight==0) gHeight = 18.0f;

    return [UIImage imageGlyphNamed:name height:gHeight color:gColor];
}

+ (UIImage*) imageGlyphNamed:(NSString *)name height:(CGFloat)height color:(UIColor*)color
{
    return [UIImage imageGlyphNamed:name height:height fontSize:0.0f color:color strokeColor:nil strokeWidth:0.0f verticalAlignment:NSVerticalTextAlignmentCenter];
}


+ (UIImage*) imageGlyphNamed:(NSString *)name height:(CGFloat)height fontSize:(CGFloat)fontSize
                       color:(UIColor*)color
                 strokeColor:(UIColor*)strokeColor strokeWidth:(CGFloat)strokeWidth
           verticalAlignment:(NSVerticalTextAlignment) verticalAlignment
{
    static NSCache *imageCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageCache = [[NSCache alloc] init];
    });

    NSString *fontSetName = [WTGlyphFontSet parseFontName:&name];
    if (fontSetName==nil) return nil;
    
    // create key from caching
    NSString *key = [NSString stringWithFormat:@"%@:%@:%f:%f:%@:%@:%f:%d", fontSetName, name, height, fontSize, color, strokeColor, strokeWidth, verticalAlignment];
    //NSLog(@"key %@", key);
    
    UIImage *i = [imageCache objectForKey:key];
    if (i) return i;
    
    WTGlyphFontSet *fontSet = [WTGlyphFontSet loadFont:fontSetName filename:[fontSetName stringByAppendingPathExtension:@"ttf"]];
    if (fontSet) {
        if (fontSize==0.0) fontSize = [fontSet fontSizeFromHeight:height];
        i = [fontSet imageWithHeight:height name:name fontSize:fontSize color:color strokeColor:strokeColor strokeWidth:strokeWidth verticalAlignment:verticalAlignment];
        if (i) [imageCache setObject:i forKey:key];
        return i;
    }
    return nil;
}

+ (UIImage*) imageGlyphNamed:(NSString *)name size:(CGSize)size color:(UIColor*)color
{
    return [UIImage imageGlyphNamed:name size:size fontSize:0.0 color:color strokeColor:nil strokeWidth:0.0 alignment:NSTextAlignmentCenter verticalAlignment:NSVerticalTextAlignmentCenter];
}

+ (UIImage*) imageGlyphNamed:(NSString *)name size:(CGSize)size fontSize:(CGFloat)fontSize
                       color:(UIColor*)color
                 strokeColor:(UIColor*)strokeColor strokeWidth:(CGFloat)strokeWidth
                   alignment:(NSTextAlignment) alignment
           verticalAlignment:(NSVerticalTextAlignment) verticalAlignment
{
    static NSCache *imageCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageCache = [[NSCache alloc] init];
    });
    
    NSString *fontSetName = [WTGlyphFontSet parseFontName:&name];
    if (fontSetName==nil) return nil;
    
    // create key from caching
    NSString *key = [NSString stringWithFormat:@"%@:%@:%@:%f:%@:%@:%f:%d:%d", fontSetName, name, NSStringFromCGSize(size), fontSize, color, strokeColor, strokeWidth, alignment, verticalAlignment];
    //NSLog(@"key %@", key);
    
    UIImage *i = [imageCache objectForKey:key];
    if (i) return i;
    
    WTGlyphFontSet *fontSet = [WTGlyphFontSet loadFont:fontSetName filename:[fontSetName stringByAppendingPathExtension:@"ttf"]];
    if (fontSet) {
        if (fontSize==0.0) fontSize = [fontSet fontSizeFromHeight:size.height];
        i = [fontSet image:size name:name fontSize:fontSize color:color strokeColor:strokeColor strokeWidth:strokeWidth alignment:alignment verticalAlignment:verticalAlignment];
        if (i) [imageCache setObject:i forKey:key];
        return i;
    }
    return nil;    
}

@end

@implementation NSAttributedString(WTGlyphFontSet)
+(id)attributedStringWithGlyph:(NSString*)name fontSize:(CGFloat)fontSize
{
    NSString *fontSetName = [WTGlyphFontSet parseFontName:&name];
    if (fontSetName==nil) return nil;
    WTGlyphFontSet *fontSet = [WTGlyphFontSet loadFont:fontSetName filename:[fontSetName stringByAppendingPathExtension:@"ttf"]];
    
    NSString *iconString = [fontSet code:name];
    if (iconString==nil) return nil;    // glyph not found
    NSDictionary *attributesDict = @{(NSString*)kCTFontAttributeName:[fontSet uiFontWithSize:fontSize]};
    return [[[self class] alloc] initWithString:iconString attributes:attributesDict];
}

@end

@implementation UITextField(WTGlyphFontSet)
- (void) setLeftGlyph:(NSString*)name color:(UIColor*)color
{
    NSString *fontSetName = [WTGlyphFontSet parseFontName:&name];
    if (fontSetName==nil) return;
    WTGlyphFontSet *fontSet = [WTGlyphFontSet loadFont:fontSetName filename:[fontSetName stringByAppendingPathExtension:@"ttf"]];
    [fontSet setTextFieldLeftView:self name:name color:color];
}
- (void) setRightGlyph:(NSString*)name color:(UIColor*)color
{
    NSString *fontSetName = [WTGlyphFontSet parseFontName:&name];
    if (fontSetName==nil) return;
    WTGlyphFontSet *fontSet = [WTGlyphFontSet loadFont:fontSetName filename:[fontSetName stringByAppendingPathExtension:@"ttf"]];
    [fontSet setTextFieldRightView:self name:name color:color];
}
@end

@implementation UIButton(WTGlyphFontSet)
- (void) setGlyphNamed:(NSString*)name
{
    NSString *fontSetName = [WTGlyphFontSet parseFontName:&name];
    if (fontSetName==nil) return;
    WTGlyphFontSet *fontSet = [WTGlyphFontSet loadFont:fontSetName filename:[fontSetName stringByAppendingPathExtension:@"ttf"]];
    [fontSet setButtonImage:self name:name];
}

@end

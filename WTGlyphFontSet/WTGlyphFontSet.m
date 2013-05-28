//
//  WTGlyphFontSet.m
//  WTGlyphFontSetDemo
//
//  Created by Water Lou on 28/11/12.
//  Copyright (c) 2012 First Water Tech Ltd. All rights reserved.
//

#import "WTGlyphFontSet.h"

@implementation WTGlyphFontSet {
    NSDictionary *_glyphLookup;
}

static NSMutableDictionary *glyphFonts = nil;

+ (WTGlyphFontSet*) loadFont:(NSString*)fontname filename:(NSString*)filename
{
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
    [self drawAtRect:rect name:name fontSize:[self fontSizeFromHeight:rect.size.height] color:color
           alignment:NSTextAlignmentCenter verticalAlignment:NSVerticalTextAlignmentCenter];
}

- (void)drawAtRect:(CGRect)rect name:(NSString*)name fontSize:(CGFloat)fontSize color:(UIColor*)color
         alignment:(NSTextAlignment) alignment verticalAlignment:(NSVerticalTextAlignment)verticalAlignment
{
    NSString *iconString = _glyphLookup[name];
    if (iconString==nil) return;    // glyph not found
    CGColorRef colorRef = color.CGColor;
    
    // inset rect referring to glyphset setting
    rect = UIEdgeInsetsInsetRect(rect, self.insets);

    // create a font with correct size
    CTFontRef sizedFont = CTFontCreateCopyWithAttributes(_font, fontSize, NULL, NULL);
    
    NSDictionary *attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                    (__bridge id)sizedFont, (NSString *)kCTFontAttributeName,
                                    colorRef, (NSString *)kCTForegroundColorAttributeName,
                                    nil];

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

- (UIImage*) image : (CGSize)size name : (NSString*)name color : (UIColor*)color
{
    return [self image:size name:name fontSize:[self fontSizeFromHeight:size.height] color:color
             alignment:NSTextAlignmentCenter verticalAlignment:NSVerticalTextAlignmentCenter];
}

- (UIImage*) image:(CGSize)size name:(NSString*)name fontSize:(CGFloat)fontSize color:(UIColor*)color
         alignment:(NSTextAlignment) alignment verticalAlignment:(NSVerticalTextAlignment) verticalAlignment
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    //[[UIColor yellowColor] setFill];
    //CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, size.width, size.height));
    [color setFill];
    [self drawAtRect:CGRectMake(0,0,size.width,size.height) name:name fontSize:fontSize color:color alignment:alignment verticalAlignment:verticalAlignment];
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ret;
}

- (UIImage*) imageWithHeight:(CGFloat)height name:(NSString*)name color:(UIColor*)color
{
    return [self imageWithHeight:height name:name fontSize:[self fontSizeFromHeight:height] color:color
               verticalAlignment:NSVerticalTextAlignmentCenter];
}

- (UIImage*) imageWithHeight:(CGFloat)height name:(NSString*)name fontSize:(CGFloat)fontSize
                       color:(UIColor*)color verticalAlignment:(NSVerticalTextAlignment) verticalAlignment
{
    CGSize size = CGSizeMake([self widthForIconWithFontSize:fontSize name:name], height);
    if (size.width>0)
        return [self image:size name:name fontSize:fontSize color:color alignment:NSTextAlignmentLeft verticalAlignment:verticalAlignment];
    return nil; // glyph not found
}

#pragma mark -

- (NSAttributedString*) attributedStringWithName:(NSString*)name fontSize:(CGFloat)fontSize
{
    NSString *iconString = _glyphLookup[name];
    if (iconString==nil) return nil;    // glyph not found
    
    NSDictionary *attributesDict = @{(NSString*)kCTFontAttributeName:[self uiFontWithSize:fontSize]};

    
    return [[NSAttributedString alloc] initWithString:iconString attributes:attributesDict];
}


#pragma mark - helpers

- (void) setTextFieldLeftView:(UITextField*)textField name:(NSString*)name color:(UIColor*)color
{
    CGFloat height = textField.font.lineHeight;
    CGFloat fontSize = textField.font.pointSize;
    CGFloat width = ceilf(fmaxf(height, [self widthForIconWithFontSize:fontSize name:name]));
    NSAssert(width>0.0, @"glyph name not found");
    CGSize size = CGSizeMake(width, height);
    UIImage *image = [self image:size name:name fontSize:fontSize color:color alignment:NSTextAlignmentCenter verticalAlignment:NSVerticalTextAlignmentCenter];
    textField.leftView = [[UIImageView alloc] initWithImage: image];
}

- (void) setTextFieldRightView:(UITextField*)textField name:(NSString*)name color:(UIColor*)color
{
    CGFloat height = textField.font.lineHeight;
    CGFloat fontSize = textField.font.pointSize;
    CGFloat width = ceilf(fmaxf(height, [self widthForIconWithFontSize:fontSize name:name]));
    NSAssert(width>0.0, @"glyph name not found");
    CGSize size = CGSizeMake(width, height);
    UIImage *image = [self image:size name:name fontSize:fontSize color:color alignment:NSTextAlignmentCenter verticalAlignment:NSVerticalTextAlignmentCenter];
    textField.rightView = [[UIImageView alloc] initWithImage: image];
}

- (void) setButtonImage:(UIButton*)button name:(NSString*)name color:(UIColor*)color
{
    CGFloat height = button.titleLabel.font.lineHeight;
    CGFloat fontSize = button.titleLabel.font.pointSize;
    CGFloat width = ceilf(fmaxf(height, [self widthForIconWithFontSize:fontSize name:name]));
    NSAssert(width>0.0, @"glyph name not found");
    CGSize size = CGSizeMake(width, height);
    [button setImage:[self image:size name:name fontSize:fontSize color:[button titleColorForState:UIControlStateNormal] alignment:NSTextAlignmentCenter verticalAlignment:NSVerticalTextAlignmentManualBaseline] forState:UIControlStateNormal];
    [button setImage:[self image:size name:name fontSize:fontSize  color:[button titleColorForState:UIControlStateHighlighted] alignment:NSTextAlignmentCenter verticalAlignment:NSVerticalTextAlignmentManualBaseline] forState:UIControlStateHighlighted];
    [button setImage:[self image:size name:name fontSize:fontSize  color:[button titleColorForState:UIControlStateDisabled] alignment:NSTextAlignmentCenter verticalAlignment:NSVerticalTextAlignmentManualBaseline] forState:UIControlStateDisabled];
}

@end


@implementation UIImage(WTGlyphFontSet)

static CGFloat g_Height;
static UIColor *g_Color;

+ (void) setImageGlyphHeight:(CGFloat)height color:(UIColor*)color
{
    g_Height = height;
    g_Color = color;
}

+ (UIImage*) imageGlyphNamed:(NSString *)name
{
    if (g_Color==nil) g_Color = [UIColor darkGrayColor];
    if (g_Height==0) g_Height = 18.0f;

    return [UIImage imageGlyphNamed:name height:g_Height color:g_Color];
}

+ (UIImage*) imageGlyphNamed:(NSString *)name height:(CGFloat)height color:(UIColor*)color
{
    static NSCache *imageCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageCache = [[NSCache alloc] init];
    });

    NSString *fontSetName;
    NSArray *breakName = [name componentsSeparatedByString: @"##"];
    if (breakName.count==2) {
        fontSetName = breakName[0];
        name = breakName[1];
    }
    else {
        return nil;
    }
    NSString *key = [NSString stringWithFormat:@"%@##%@##%f##%@", fontSetName, name, height, color];
    NSLog(@"key %@", key);
    
    UIImage *i = [imageCache objectForKey:key];
    if (i) return i;
    
    WTGlyphFontSet *fontSet = [WTGlyphFontSet loadFont:fontSetName filename:[fontSetName stringByAppendingPathExtension:@"ttf"]];
    if (fontSet) {
        i = [fontSet imageWithHeight:height name:name color:color];
        if (i) [imageCache setObject:i forKey:key];
        return i;
    }
    return nil;
}

@end

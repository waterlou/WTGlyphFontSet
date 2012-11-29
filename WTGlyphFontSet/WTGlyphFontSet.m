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

+ (void) loadFont : (NSString*)fontname filename : (NSString*) filename
{
    NSArray *fileComponent = [filename componentsSeparatedByString:@"."];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        glyphFonts = [[NSMutableDictionary alloc] initWithCapacity:4];
    });
    
    if ([glyphFonts objectForKey: fontname]!=nil)
    {
        // font is already defined
        return;
    }
    WTGlyphFontSet *newGlyph = [[WTGlyphFontSet alloc] initWithFontName:fileComponent[0] ofType:fileComponent[1]];
    [glyphFonts setObject:newGlyph forKey:fontname];
}

+ (WTGlyphFontSet*) fontSet : (NSString*) fontname
{
    return [glyphFonts objectForKey: fontname];
}


- (id)initWithFontName:(NSString *)aName ofType:(NSString *)aType {
    self = [super init];
    if (self) {
        NSString *fontPath = [[NSBundle mainBundle] pathForResource:aName
                                                             ofType:aType];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:aName
                                                             ofType:@"plist"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:fontPath];
        CGDataProviderRef fontProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
        
        _glyphLookup = [[NSDictionary alloc] initWithContentsOfFile: plistPath];
        NSAssert(_glyphLookup!=nil, @"plist for glyph font %@ not found", aName);
        
        CGFontRef cgFont = CGFontCreateWithDataProvider(fontProvider);
        CGDataProviderRelease(fontProvider);
        
        CTFontDescriptorRef fontDescriptor = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)@{});
        _font = CTFontCreateWithGraphicsFont(cgFont, 0, NULL, fontDescriptor);
        CFRelease(fontDescriptor);
        CGFontRelease(cgFont);
    }
    return self;
}

- (void) dealloc{
    CFRelease(_font);
}

#pragma mark -

- (void)drawAtRect : (CGRect)rect name : (NSString*)name color : (UIColor*)color
{
    [self drawAtRect:rect name:name color:color alignment : NSTextAlignmentCenter verticalAlignment : NSVerticalTextAlignmentDefault];
}

- (void)drawAtRect : (CGRect)rect name : (NSString*)name color : (UIColor*)color
         alignment : (NSTextAlignment) alignment verticalAlignment : (NSVerticalTextAlignment) verticalAlignment
{
    NSString *iconString = _glyphLookup[name];
    if (iconString==nil) return;    // glyph not found
    CGColorRef colorRef = color.CGColor;
    
    // create a font with correct size
    CTFontRef sizedFont = CTFontCreateCopyWithAttributes(_font, rect.size.height, NULL, NULL);
    
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
            yOffset = (rect.size.height-imageBounds.size.height)/2.0; break;
        case NSVerticalTextAlignmentTop:
            imageBounds = CTLineGetImageBounds(line, context);
            yOffset = rect.size.height - imageBounds.size.height - imageBounds.origin.y; break;
        case NSVerticalTextAlignmentBottom:
            imageBounds = CTLineGetImageBounds(line, context);
            yOffset = -imageBounds.origin.y; break;
        default:
            yOffset = 0.0; break;
    }
    double penOffset = CTLineGetPenOffsetForFlush(line, flush, rect.size.width);
    CGContextSetTextPosition(context, penOffset, yOffset);
    
    CTLineDraw(line, context);
    CFRelease(line);
    CFRelease(sizedFont);
}

- (UIImage*) image : (CGSize)size name : (NSString*)name color : (UIColor*)color
{
    return [self image:size name:name color:color inset:0.0f alignment:NSTextAlignmentCenter verticalAlignment:NSVerticalTextAlignmentDefault];
}

- (UIImage*) image : (CGSize)size name : (NSString*)name color : (UIColor*)color inset : (CGFloat) inset
         alignment : (NSTextAlignment) alignment verticalAlignment : (NSVerticalTextAlignment) verticalAlignment
{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [color setFill];
    CGFloat i = MAX(inset, 1.0f);   // at least 1.0f inset for better anti-aliasing
    CGRect rr = CGRectInset(CGRectMake(0,0,size.width,size.height), i, i);
    [self drawAtRect:rr name:name color:color alignment:alignment verticalAlignment:verticalAlignment];
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ret;
}

@end


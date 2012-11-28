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
        if (glyphFonts==nil)
        {
            glyphFonts = [[NSMutableDictionary alloc] initWithCapacity:4];
        }
        if ([glyphFonts objectForKey: fontname]!=nil)
        {
            // font is already defined
            return;
        }
        WTGlyphFontSet *newGlyph = [[WTGlyphFontSet alloc] initWithFontName:fileComponent[0] ofType:fileComponent[1]];
        [glyphFonts setObject:newGlyph forKey:fontname];
    });
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
    NSString *iconString = _glyphLookup[name];
    if (iconString==nil) return;    // glyph not found
    CGColorRef colorRef = color.CGColor;
    NSDictionary *attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                    (__bridge id)_font, (NSString *)kCTFontAttributeName,
                                    colorRef, (NSString *)kCTForegroundColorAttributeName,
                                    nil];
    
    NSAttributedString *attrString = [[NSMutableAttributedString alloc]
                                      initWithString:iconString
                                      attributes:attributesDict];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attrString,
                                   CFRangeMake(0, iconString.length),
                                   kCTForegroundColorAttributeName,
                                   colorRef);
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef) attrString);
    CGRect imageBounds = CTLineGetImageBounds(line, context);
    CGFloat width = imageBounds.size.width;
    CGFloat height = imageBounds.size.height;
    CGFloat scale = MAX(width, height);
    
    float sx = rect.size.width / scale;
    float sy = rect.size.height / scale;
    float xoffset = (rect.size.width - 1.0 - width * sx) / 2.0;
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    CGContextTranslateCTM(context, rect.origin.x+0.5+xoffset, rect.size.height+rect.origin.y-0.5);
    CGContextScaleCTM(context, sx, -sy);
    
    //CGContextSetTextPosition(context, -imageBounds.origin.x*400, 0);
    //CGContextSetTextPosition(context, -imageBounds.origin.x, -imageBounds.origin.y);
    
    CTLineDraw(line, context);
    CFRelease(line);
}

- (UIImage*) image : (CGSize)size name : (NSString*)name color : (UIColor*)color inset : (CGFloat) inset
{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [color setFill];
    CGFloat i = MAX(0.5, inset);
    CGRect rr = CGRectInset(CGRectMake(0,0,size.width,size.height), i, i);
    [self drawAtRect:rr name:name color:color];
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ret;
}

@end


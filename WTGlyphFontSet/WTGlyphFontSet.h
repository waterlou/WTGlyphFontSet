//
//  WTGlyphFontSet.h
//  WTGlyphFontSetDemo
//
//  Created by Water Lou on 28/11/12.
//  Copyright (c) 2012 First Water Tech Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

typedef NS_ENUM(NSInteger, NSVerticalTextAlignment) {
    NSVerticalTextAlignmentTop      = 0,    // Visually top aligned
    NSVerticalTextAlignmentCenter    = 1,    // Visually centered
    NSVerticalTextAlignmentBottom     = 2,    // Visually bottom aligned
    NSVerticalTextAlignmentDefault     = 3,    // Not calculate the text bounds, use default baseline
};

@interface WTGlyphFontSet : NSObject

@property (nonatomic, readonly) CTFontRef font;

+ (void) loadFont : (NSString*)fontname filename : (NSString*) filename;
+ (WTGlyphFontSet*) fontSet : (NSString*) fontname;

- (void)drawAtRect:(CGRect)rect name:(NSString*)name color : (UIColor*)color;
- (void)drawAtRect : (CGRect)rect name : (NSString*)name color : (UIColor*)color
         alignment : (NSTextAlignment) alignment verticalAlignment : (NSVerticalTextAlignment) verticalAlignment;


- (UIImage*) image : (CGSize)size name : (NSString*)name color : (UIColor*)color;
- (UIImage*) image : (CGSize)size name : (NSString*)name color : (UIColor*)color inset : (CGFloat) inset
         alignment : (NSTextAlignment) alignment verticalAlignment : (NSVerticalTextAlignment) verticalAlignment;

@end

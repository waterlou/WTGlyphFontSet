//
//  WTGlyphFontSet.h
//  WTGlyphFontSetDemo
//
//  Created by Water Lou on 28/11/12.
//  Copyright (c) 2012 First Water Tech Ltd. All rights reserved.
//

/*
 
 Size / Height X
 Alignment
 Vertical Alignment
 inset
 color X
 fontSize (optional)
 
 */

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

typedef NS_ENUM(NSInteger, NSVerticalTextAlignment) {
    NSVerticalTextAlignmentTop              = 0,    // Visually top aligned
    NSVerticalTextAlignmentCenter           = 1,    // Visually centered
    NSVerticalTextAlignmentBottom           = 2,    // Visually bottom aligned
    NSVerticalTextAlignmentManualBaseline   = 3,    // Use manual baseline variable
    NSVerticalTextAlignmentDefault          = 4,    // Use font info to caulcuate the baseline, and align with baseline
};

@interface WTGlyphFontSet : NSObject

@property (nonatomic, readonly) CTFontRef font;
// font name for UIFont, only avaiable after calling uiFontWithSize
@property (nonatomic, readonly) NSString *uiFontName;

// parameter for fine tuning the whole font set
@property (nonatomic) CGFloat baseline; // default baseline set to 0.15 the match system font
@property (nonatomic) UIEdgeInsets insets;    // inset to draw the font, default zero

// load the file
+ (WTGlyphFontSet*)loadFont:(NSString*)fontname filename:(NSString*)filename;
// retreive font set by name
+ (WTGlyphFontSet*)fontSet:(NSString*)fontname;

// register font to UIFont so that you can use the font in UIKit
- (UIFont*) uiFontWithSize:(CGFloat)fontSize;

// calculate the width by the height of the icon
- (CGFloat) widthForIconWithFontSize:(CGFloat)fontSize name:(NSString*)name;

- (NSString*) code : (NSString*) name;  // get the key code from icon name

// draw glyph on current context
- (void)drawAtRect:(CGRect)rect name:(NSString*)name color:(UIColor*)color;
- (void)drawAtRect:(CGRect)rect name:(NSString*)name color:(UIColor*)color
         alignment:(NSTextAlignment) alignment verticalAlignment:(NSVerticalTextAlignment)verticalAlignment;
- (void)drawAtRect:(CGRect)rect name:(NSString*)name fontSize:(CGFloat)fontSize color:(UIColor*)color
       strokeColor:(UIColor*)strokeColor strokeWidth:(CGFloat)strokeWidth
         alignment:(NSTextAlignment) alignment verticalAlignment:(NSVerticalTextAlignment)verticalAlignment;

// create image from the icon glyph
- (UIImage*) image:(CGSize)size name:(NSString*)name color:(UIColor*)color;
- (UIImage*) image:(CGSize)size name:(NSString*)name color:(UIColor*)color
         alignment:(NSTextAlignment) alignment verticalAlignment:(NSVerticalTextAlignment) verticalAlignment;
- (UIImage*) image:(CGSize)size name:(NSString*)name fontSize:(CGFloat)fontSize color:(UIColor*)color
       strokeColor:(UIColor*)strokeColor strokeWidth:(CGFloat)strokeWidth
         alignment:(NSTextAlignment) alignment verticalAlignment:(NSVerticalTextAlignment) verticalAlignment;

// create image, using height only. Width will be calculated automatically
- (UIImage*) imageWithHeight:(CGFloat)height name:(NSString*)name color:(UIColor*)color;
- (UIImage*) imageWithHeight:(CGFloat)height name:(NSString*)name
                       color:(UIColor*)color verticalAlignment:(NSVerticalTextAlignment) verticalAlignment;
- (UIImage*) imageWithHeight:(CGFloat)height name:(NSString*)name fontSize:(CGFloat)fontSize color:(UIColor*)color
                 strokeColor:(UIColor*)strokeColor strokeWidth:(CGFloat)strokeWidth
           verticalAlignment:(NSVerticalTextAlignment) verticalAlignment;

// helpers to set glyph to a control
- (void) setTextFieldLeftView:(UITextField*)textField name:(NSString*)name color:(UIColor*)color;
- (void) setTextFieldRightView:(UITextField*)textField name:(NSString*)name color:(UIColor*)color;
- (void) setButtonImage:(UIButton*)button name:(NSString*)name;

+ (void) setDefaultFontSetName:(NSString*)fontSetName;
+ (NSString*) defaultFontSetName;

@end

/*
 Helper to get image from glyph easily:
 1. Auto load font, with name "fontawesome##keyboard" if will load fontawesome.ttf automatically and use the glyph "keyboard"
 2. Image is cached
 */
@interface UIImage(WTGlyphFontSet)

+ (void) setImageGlyphHeight:(CGFloat)height color:(UIColor*)color;

// easiest method to create image from font set, you have to set default fontset, height and color first
+ (UIImage*) imageGlyphNamed:(NSString *)name;

+ (UIImage*) imageGlyphNamed:(NSString *)name height:(CGFloat)height color:(UIColor*)color;
+ (UIImage*) imageGlyphNamed:(NSString *)name height:(CGFloat)height fontSize:(CGFloat)fontSize
                       color:(UIColor*)color
                 strokeColor:(UIColor*)strokeColor strokeWidth:(CGFloat)strokeWidth
           verticalAlignment:(NSVerticalTextAlignment) verticalAlignment;

+ (UIImage*) imageGlyphNamed:(NSString *)name size:(CGSize)size color:(UIColor*)color;
+ (UIImage*) imageGlyphNamed:(NSString *)name size:(CGSize)size fontSize:(CGFloat)fontSize
                       color:(UIColor*)color
                 strokeColor:(UIColor*)strokeColor strokeWidth:(CGFloat)strokeWidth
                   alignment:(NSTextAlignment) alignment
           verticalAlignment:(NSVerticalTextAlignment) verticalAlignment;

@end

@interface NSAttributedString(WTGlyphFontSet)
+(id)attributedStringWithGlyph:(NSString*)name fontSize:(CGFloat)fontSize;
@end

@interface UITextField(WTGlyphFontSet)
- (void) setLeftGlyph:(NSString*)name color:(UIColor*)color;
- (void) setRightGlyph:(NSString*)name color:(UIColor*)color;
@end

@interface UIButton(WTGlyphFontSet)
- (void) setGlyphNamed:(NSString*)name;
@end
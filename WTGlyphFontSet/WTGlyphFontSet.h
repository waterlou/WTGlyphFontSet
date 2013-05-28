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
    NSVerticalTextAlignmentTop              = 0,    // Visually top aligned
    NSVerticalTextAlignmentCenter           = 1,    // Visually centered
    NSVerticalTextAlignmentBottom           = 2,    // Visually bottom aligned
    NSVerticalTextAlignmentManualBaseline   = 3,    // Use manual baseline variable
    NSVerticalTextAlignmentDefault          = 4,    // Use font info to caulcuate the baseline, and align with baseline
};

@interface WTGlyphFontSet : NSObject

@property (nonatomic, readonly) CTFontRef font;
@property (nonatomic, readonly) NSString *uiFontName;
@property (nonatomic) CGFloat baseline; // default baseline set to 0.15 the match system font
@property (nonatomic) UIEdgeInsets insets;    // inset to draw the font, default zero


+ (WTGlyphFontSet*)loadFont:(NSString*)fontname filename:(NSString*)filename;
+ (WTGlyphFontSet*)fontSet:(NSString*)fontname;

- (UIFont*) uiFontWithSize:(CGFloat)fontSize;

// calculate the width by the height of the icon
- (CGFloat) widthForIconWithFontSize:(CGFloat)fontSize name:(NSString*)name;

- (NSString*) code : (NSString*) name;  // get the key code from icon name

- (void)drawAtRect:(CGRect)rect name:(NSString*)name color:(UIColor*)color;
- (void)drawAtRect:(CGRect)rect name:(NSString*)name fontSize:(CGFloat)fontSize color:(UIColor*)color
         alignment:(NSTextAlignment) alignment verticalAlignment:(NSVerticalTextAlignment)verticalAlignment;

// create image from the icon glyph
- (UIImage*) image:(CGSize)size name:(NSString*)name color:(UIColor*)color;
- (UIImage*) image:(CGSize)size name:(NSString*)name fontSize:(CGFloat)fontSize color:(UIColor*)color
         alignment:(NSTextAlignment) alignment verticalAlignment:(NSVerticalTextAlignment) verticalAlignment;

// create image, using height only. Width will be calculated automatically
- (UIImage*) imageWithHeight:(CGFloat)height name:(NSString*)name color:(UIColor*)color;
- (UIImage*) imageWithHeight:(CGFloat)height name:(NSString*)name fontSize:(CGFloat)fontSize
                       color:(UIColor*)color verticalAlignment:(NSVerticalTextAlignment) verticalAlignment;

- (NSAttributedString*) attributedStringWithName:(NSString*)name fontSize:(CGFloat)fontSize;

- (void) setTextFieldLeftView:(UITextField*)textField name:(NSString*)name color:(UIColor*)color;
- (void) setTextFieldRightView:(UITextField*)textField name:(NSString*)name color:(UIColor*)color;
- (void) setButtonImage:(UIButton*)button name:(NSString*)name color:(UIColor*)color;


@end

@interface UIImage(WTGlyphFontSet)

+ (void) setImageGlyphHeight:(CGFloat)height color:(UIColor*)color;
+ (UIImage*) imageGlyphNamed:(NSString *)name;

+ (UIImage*) imageGlyphNamed:(NSString *)name height:(CGFloat)height color:(UIColor*)color;

@end

//
//  WTGlyphFontSet.h
//  WTGlyphFontSetDemo
//
//  Created by Water Lou on 28/11/12.
//  Copyright (c) 2012 First Water Tech Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface WTGlyphFontSet : NSObject

@property (nonatomic, readonly) CTFontRef font;

+ (void) loadFont : (NSString*)fontname filename : (NSString*) filename;
+ (WTGlyphFontSet*) fontSet : (NSString*) fontname;

- (void)drawAtRect:(CGRect)rect name:(NSString*)name color : (UIColor*)color;
- (UIImage*) image : (CGSize)size name : (NSString*)name color : (UIColor*)color inset : (CGFloat) inset;

@end

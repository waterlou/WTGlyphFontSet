//
//  WTViewController.m
//  WTGlyphFontSetDemo
//
//  Created by Water Lou on 28/11/12.
//  Copyright (c) 2012 First Water Tech Ltd. All rights reserved.
//

#import "WTViewController.h"
#import "WTGlyphFontSet.h"
@interface WTViewController ()

@end

@implementation WTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"fontawesome"
                                                          ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile: plistPath];
    CGFloat x = 16, y = 16;
    for (NSString *key in dict.allKeys)
    {
        NSLog(@"creating icon %@", key);
        UIImageView *iv = [[UIImageView alloc] initWithImage:
                           [[WTGlyphFontSet fontSet: @"fontawesome"] image : CGSizeMake(32, 32) name : key color : [UIColor blackColor] inset: 0.0f]];
        iv.center = CGPointMake(x, y);
        x+=32.0f;
        if (x>=320.0) {
            x = 16;
            y+=32.0f;
        }
        [self.view addSubview: iv];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  WTTestViewController.m
//  WTGlyphFontSetDemo
//
//  Created by Water Lou on 27/5/13.
//  Copyright (c) 2013 First Water Tech Ltd. All rights reserved.
//

#import "WTTestViewController.h"
#import "WTGlyphFontSet.h"

@interface WTTestViewController ()

@end

@implementation WTTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // demo to set text field aux view
    WTGlyphFontSet *fontSet = [WTGlyphFontSet loadFont:@"fontawesome_test" filename:@"fontawesome.ttf"];
    [fontSet setTextFieldLeftView:self.textField1 name:@"user" color:[UIColor colorWithWhite:0.5 alpha:1.0]];
    self.textField1.leftViewMode = UITextFieldViewModeAlways;
    self.textField2.bounds = CGRectMake(0, 0, 140, 48);
    //[fontSet setTextFieldLeftView:self.textField2 name:@"credit-card" color:[UIColor colorWithWhite:0.5 alpha:1.0]];
    [self.textField2 setLeftGlyph:@"fontawesome##credit-card" color:[UIColor colorWithWhite:0.5 alpha:1.0]];
    self.textField2.leftViewMode = UITextFieldViewModeAlways;

    [WTGlyphFontSet setDefaultFontSetName:@"fontawesome"];
    // demo to set button
    [self.button1 setGlyphNamed:@"download"];
    [self.button2 setGlyphNamed:@"fontawesome##h-sign"];
    
    // demo to set label using attributed text
    NSMutableAttributedString *str = [NSMutableAttributedString attributedStringWithGlyph:@"credit-card" fontSize:self.label1.font.pointSize];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString: @" Label with attributed text"]];
    [self.label1 setAttributedText:str];
    
    // demo to set navigation bar icon
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[fontSet imageWithHeight:18.0f name:@"star" color:[UIColor whiteColor]] style:UIBarButtonItemStyleBordered target:self action:@selector(doRightBarButtonClicked:)];

    // demo to set toolbar icon using imageGlyphNamed
    [UIImage setImageGlyphHeight:28.0f color:[UIColor whiteColor]];
    [WTGlyphFontSet setDefaultFontSetName:@"fontawesome"];
    NSArray *icons = @[@"comment", @"heart-empty", @"keyboard", @"twitter", @"facebook", @"smile", @"caret-left", @"caret-right", @"ellipsis-horizontal"];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    for (NSString *icon in icons) {
        UIBarButtonItem *i = [[UIBarButtonItem alloc] initWithImage:[UIImage imageGlyphNamed:icon] style:UIBarButtonItemStylePlain target:self action:nil];
        [barItems addObject: i];
    }
    [self.toolBar setItems:barItems animated:NO];
    
    // various effect
    self.imageView1.image = [UIImage imageGlyphNamed:@"icomoon##apple" height:64.0f color:[UIColor darkGrayColor]];

    // set fontSize to 0.0 will use the fontsize according to the height of the image
    self.imageView2.image = [UIImage imageGlyphNamed:@"icomoon##apple" height:64.0f fontSize:0.0 color:nil strokeColor:[UIColor darkGrayColor] strokeWidth:1.0f verticalAlignment:NSVerticalTextAlignmentCenter];

    self.imageView3.image = [UIImage imageGlyphNamed:@"icomoon##apple" height:64.0f fontSize:0.0 color:[UIColor colorWithRed:0.800 green:1.000 blue:0.400 alpha:1.000] strokeColor:[UIColor blackColor] strokeWidth:1.0f verticalAlignment:NSVerticalTextAlignmentCenter];

    // set fontSize
    self.imageView4.image = [UIImage imageGlyphNamed:@"icomoon##apple" height:64.0f fontSize:48.0 color:[UIColor darkGrayColor] strokeColor:[UIColor darkGrayColor] strokeWidth:1.0f verticalAlignment:NSVerticalTextAlignmentCenter];
    self.imageView4.backgroundColor = [UIColor colorWithRed:1.000 green:1.000 blue:0.400 alpha:1.000];

    self.imageView5.image = [UIImage imageGlyphNamed:@"icomoon##apple" height:64.0f fontSize:48.0 color:[UIColor darkGrayColor] strokeColor:[UIColor darkGrayColor] strokeWidth:1.0f verticalAlignment:NSVerticalTextAlignmentTop];
    self.imageView5.backgroundColor = [UIColor colorWithRed:1.000 green:1.000 blue:0.400 alpha:1.000];

    self.imageView6.image = [UIImage imageGlyphNamed:@"icomoon##apple" height:64.0f fontSize:48.0 color:[UIColor darkGrayColor] strokeColor:[UIColor darkGrayColor] strokeWidth:1.0f verticalAlignment:NSVerticalTextAlignmentBottom];
    self.imageView6.backgroundColor = [UIColor colorWithRed:1.000 green:1.000 blue:0.400 alpha:1.000];

    self.imageView7.image = [UIImage imageGlyphNamed:@"icomoon##apple" height:64.0f fontSize:48.0 color:[UIColor darkGrayColor] strokeColor:[UIColor darkGrayColor] strokeWidth:1.0f verticalAlignment:NSVerticalTextAlignmentManualBaseline];
    self.imageView7.backgroundColor = [UIColor colorWithRed:1.000 green:1.000 blue:0.400 alpha:1.000];

    self.imageView8.image = [UIImage imageGlyphNamed:@"icomoon##apple" height:64.0f fontSize:48.0 color:[UIColor darkGrayColor] strokeColor:[UIColor darkGrayColor] strokeWidth:1.0f verticalAlignment:NSVerticalTextAlignmentDefault];
    self.imageView8.backgroundColor = [UIColor colorWithRed:1.000 green:1.000 blue:0.400 alpha:1.000];

    self.imageView9.image = [UIImage imageGlyphNamed:@"icomoon##android" height:64.0f color:[UIColor colorWithRed:0.000 green:0.502 blue:0.251 alpha:1.000]];
    self.imageView9.backgroundColor = [UIColor colorWithRed:1.000 green:1.000 blue:0.400 alpha:1.000];

}

- (IBAction)doRightBarButtonClicked:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

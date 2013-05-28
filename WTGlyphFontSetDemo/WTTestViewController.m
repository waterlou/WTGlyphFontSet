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
    WTGlyphFontSet *fontSet = [WTGlyphFontSet loadFont:@"fontawesome_test" filename:@"fontawesome.ttf"];
    //WTGlyphFontSet *fontSet = [WTGlyphFontSet loadFont:@"fontawesome_test" filename:@"mainicon.ttf"];
    [fontSet setTextFieldLeftView:self.textField1 name:@"user" color:[UIColor colorWithWhite:0.5 alpha:1.0]];
    self.textField1.leftViewMode = UITextFieldViewModeAlways;
    self.textField2.bounds = CGRectMake(0, 0, 140, 48);
    [fontSet setTextFieldLeftView:self.textField2 name:@"credit-card" color:[UIColor colorWithWhite:0.5 alpha:1.0]];
    self.textField2.leftViewMode = UITextFieldViewModeAlways;
    
    [fontSet setButtonImage:self.button1 name:@"download" color:[UIColor darkGrayColor]];
    [fontSet setButtonImage:self.button2 name:@"credit-card" color:[UIColor darkGrayColor]];
    //[fontSet setButtonImage:self.button1 name:@"coin" color:[UIColor darkGrayColor]];
    //[fontSet setButtonImage:self.button2 name:@"coin" color:[UIColor darkGrayColor]];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithAttributedString:[fontSet attributedStringWithName:@"credit-card" fontSize:self.label1.font.pointSize]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString: @"BKACK"]];
    [self.label1 setAttributedText:str];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[fontSet imageWithHeight:18.0f name:@"star" color:[UIColor whiteColor]] style:UIBarButtonItemStyleBordered target:self action:@selector(doRightBarButtonClicked:)];
    
    [UIImage setImageGlyphHeight:48.0f color:[UIColor darkGrayColor]];
    self.imageView.image = [UIImage imageGlyphNamed:@"icomoon##yahoo-2"];
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

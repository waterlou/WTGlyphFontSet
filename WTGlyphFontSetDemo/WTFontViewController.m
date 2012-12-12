//
//  WTFontViewController.m
//  WTGlyphFontSetDemo
//
//  Created by Water Lou on 29/11/12.
//  Copyright (c) 2012 First Water Tech Ltd. All rights reserved.
//

#import "WTFontViewController.h"
#import "WTGlyphFontSet.h"

@interface WTFontViewCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView* imageView;
@property (strong, nonatomic) UILabel* label;
@end

@implementation WTFontViewCell

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 48, 48)];
        //self.imageView.backgroundColor = [UIColor yellowColor];
        [self addSubview: self.imageView];
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 48, 64, 16)];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [UIFont systemFontOfSize:10.0f];
        self.label.minimumScaleFactor = 0.5;
        self.label.adjustsFontSizeToFitWidth = YES;
        [self addSubview: self.label];
    }
    return self;
}

@end


@interface WTFontViewController ()
@end

@implementation WTFontViewController {
    NSArray *_meta;
}

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
    
    self.title = self.fontname;
        
    // load font
    [WTGlyphFontSet loadFont:self.fontname filename:self.filename];
        
    // Do any additional setup after loading the view from its nib.
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:self.fontname
                                                          ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile: plistPath];
    _meta = [dict.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [self.collectionView registerClass:[WTFontViewCell class] forCellWithReuseIdentifier:@"WTFontViewCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _meta.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WTFontViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WTFontViewCell" forIndexPath:indexPath];
    UIImage *image = [[WTGlyphFontSet fontSet: self.fontname] image : CGSizeMake(48, 48) name : _meta[indexPath.row] color : [UIColor colorWithWhite:0.2f alpha:1.0f] inset:4.0f alignment:NSTextAlignmentCenter verticalAlignment:NSVerticalTextAlignmentDefault];
    cell.imageView.image = image;
    cell.label.text = _meta[indexPath.row];
    return cell;
}

@end

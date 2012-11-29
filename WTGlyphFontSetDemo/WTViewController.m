//
//  WTViewController.m
//  WTGlyphFontSetDemo
//
//  Created by Water Lou on 28/11/12.
//  Copyright (c) 2012 First Water Tech Ltd. All rights reserved.
//

#import "WTViewController.h"
#import "WTGlyphFontSet.h"
#import "WTFontViewController.h"

@interface WTViewController ()

@end

@implementation WTViewController {
    NSArray *_fontlist;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _fontlist = @[
    @{@"name": @"fontawesome", @"file": @"fontawesome.ttf", @"url": @"http://fortawesome.github.com/Font-Awesome/"},
    @{@"name": @"iconic_fill", @"file": @"iconic_fill.ttf", @"url": @"http://somerandomdude.com/work/iconic/"},
    @{@"name": @"iconic_stroke", @"file": @"iconic_stroke.ttf", @"url": @"http://somerandomdude.com/work/iconic/"},
    @{@"name": @"entypo", @"file": @"entypo.ttf", @"url": @"http://www.entypo.com/"},
    @{@"name": @"entypo-social", @"file": @"entypo-social.ttf", @"url": @"http://www.entypo.com/"},
    @{@"name": @"general_foundicons", @"file": @"general_foundicons.ttf", @"url": @"http://www.zurb.com/playground/foundation-icons"},
    @{@"name": @"general_enclosed_foundicons", @"file": @"general_enclosed_foundicons.ttf", @"url": @"http://www.zurb.com/playground/foundation-icons"},
    @{@"name": @"social_foundicons", @"file": @"social_foundicons.ttf", @"url": @"http://www.zurb.com/playground/foundation-icons"},
    @{@"name": @"accessibility_foundicons", @"file": @"accessibility_foundicons.ttf", @"url": @"http://www.zurb.com/playground/foundation-icons"},
    @{@"name": @"heydings_icons", @"file": @"heydings_icons.ttf", @"url": @"http://www.heydonworks.com/article/a-free-icon-web-font"},
    @{@"name": @"modernpics", @"file": @"modernpics.otf", @"url": @"http://thedesignoffice.org/project/modern-pictograms/"},
    ];
    
    // use icon as back button
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.image = [[WTGlyphFontSet fontSet: @"general_foundicons"] image:CGSizeMake(36, 20) name:@"left-arrow" color:[UIColor whiteColor]];
    self.navigationItem.backBarButtonItem = backButtonItem;


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_fontlist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	NSUInteger row = [indexPath row];
	
	cell.textLabel.text = _fontlist[row][@"name"];
	return cell;
}

#pragma mark Table View Delegate Methods

// The user selected a peer from the list to connect to.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    WTFontViewController *vc = [[WTFontViewController alloc] initWithNibName:@"WTFontViewController" bundle:nil];
    vc.fontname = _fontlist[indexPath.row][@"name"];
    vc.filename = _fontlist[indexPath.row][@"file"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: _fontlist[indexPath.row][@"url"]]];
}

@end

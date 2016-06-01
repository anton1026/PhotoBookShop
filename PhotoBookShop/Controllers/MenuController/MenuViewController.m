//
//  MenuViewController.m
//  PhotoBookShop
//  Copyright © 2016 Peter. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuCell.h"
#import "SWRevealViewController.h"
@interface MenuViewController ()
{
    NSArray* arrMenuTitle;
}
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrMenuTitle = @[@"Home", @"Products",@"Current Offers",@"My Account"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableView Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return arrMenuTitle.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableIdentifier =@"MenuCell";
    MenuCell *cell =(MenuCell*) [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(cell ==nil){
        NSArray *nib =[[NSBundle mainBundle] loadNibNamed:@"MenuCell" owner:self options:nil];
        cell =[nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
        
    }
    cell.selectedBackgroundView.backgroundColor =[UIColor colorWithRed:15.0/255.0 green:39.0/255.0 blue:64.0/255.0 alpha:1.0];
    NSArray *images = @[@"icon_sign_in",@"icon_documents",@"icon_reviews",@"icon_userpic"];
    cell.lblMenuTitle.text = arrMenuTitle[indexPath.row];
    cell.menuImage.image = [UIImage imageNamed:images[indexPath.row]];
    return cell;
}

@end

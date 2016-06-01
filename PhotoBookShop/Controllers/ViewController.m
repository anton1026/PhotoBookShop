//
//  ViewController.m
//  PhotoBookShop
//  Copyright © 2016 Peter. All rights reserved.
//

#import "ViewController.h"
#import "ProductCategoryCell.h"
#import "CanvasViewController.h"
#import "WebClient.h"
#import "SWRevealViewController.h"
#import "PhotoEditController.h"
#import "SelectPhotoController.h"
@interface ViewController ()
{
    Profile* profileInfo;
    NSArray *arrProductCategory;
    MBProgressHUD *HUD;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /** init left drawer menu */
    [_btnMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.cachedImages =[[NSMutableDictionary alloc] init];
    [self requestProductCategories];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void) requestProductCategories
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.dimBackground = YES;
    [HUD show:true];
    [[WebClient sharedInstance] requestProductCategories:^(NSArray *response) {
        if(response !=nil){
            arrProductCategory =response;
            [self.tblProductCategory reloadData];
        }
    }];
}

#pragma mark TableView Delegate method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrProductCategory.count;
}
-(UITableViewCell *) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableIdentifier =@"ProductCategoryCell";
    ProductCategoryCell *cell =(ProductCategoryCell*) [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(cell ==nil){
        NSArray *nib =[[NSBundle mainBundle] loadNibNamed:@"ProductCategoryCell" owner:self options:nil];
        cell =[nib objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    ProductCategory *aProduct = (ProductCategory *)arrProductCategory[indexPath.row];
    [cell.lblProductName setText:aProduct.category_name];
    
    NSString *fromPrice =[NSString stringWithFormat:@"from %@%@",aProduct.symbol,aProduct.fromprice];
    cell.lblFromPrice.text = fromPrice;
    NSString *strURL =[NSString stringWithFormat:@"%@%@",SiteURL,aProduct.bannerurl];
    NSURL* imageURL = [NSURL URLWithString:strURL];
    
    NSString *identifier =[NSString stringWithFormat:@"Cell%d",(int)indexPath.row];
    if([self.cachedImages objectForKey:identifier] !=nil){
        cell.backgroundImage.image=[self.cachedImages valueForKey:identifier];
    }else{
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(0, 0);
        //this will start the image loading in bg
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:imageURL];
            //this will set the image when loading is finished
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUD removeFromSuperview];
                HUD = nil;
                UIImage *img =[UIImage imageWithData:image];
                cell.backgroundImage.image =img;
                [self.cachedImages setValue:img forKey:identifier];
            });
        });
    }
    return cell;
}
-(void) tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//        PhotoEditController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoEditController"];
//        [self presentViewController:viewController animated:YES completion:nil];

//    [WebClient sharedInstance].webClientRequestIndex = indexPath.row;
//    SelectPhotoController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectPhotoController"];
//    [self presentViewController:viewController animated:YES completion:nil];
    
    [WebClient sharedInstance].webClientRequestIndex = indexPath.row;
    CanvasViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CanvasViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
}
@end

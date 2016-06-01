//
//  ProductInfoViewController.m
//  PhotoBookShop
//  Copyright © 2016 Peter. All rights reserved.
//

#import "ProductInfoViewController.h"
#import "HMSegmentedControl.h"
#import "ProductInfoCell.h"
#import "CanvasEditController.h"
#import "WebClient.h"
#import "SelectPhotoController.h"
@interface ProductInfoViewController ()
{
    
    Profile* profileInfo;
    MBProgressHUD *HUD;
    int format_index;
    int selected_format;
    NSMutableDictionary *ProductInfoData;
    NSArray *arrProductInfo;
    NSString *price_symbol;
}
@end

@implementation ProductInfoViewController

@synthesize arrFormat,category_ID;

- (void)viewDidLoad {
    [super viewDidLoad];
    profileInfo =[Profile instance];
    self.imageProduct.image =profileInfo.product_image;
    switch ([WebClient sharedInstance].webClientRequestIndex) {
        case CANVAS:
            self.lblTitle.text = @"Canvas Prints";
            break;
        case PHOTOBOOKS:
            self.lblTitle.text = @"Photo Prints";                
            break;
        default:
            break;
    }
    
    ProductInfoData =[NSMutableDictionary dictionary];
    
    NSMutableArray *arrName =[[NSMutableArray alloc] init];
    for(CategoryFormats *aFormat in arrFormat){
        [arrName addObject:aFormat.format_name];
    }
    NSArray *arrName0 =[[NSArray alloc] initWithArray:arrName];
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:arrName0];
    
    segmentedControl.frame =CGRectMake(0, 64, self.view.frame.size.width, 40);
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];

    segmentedControl.selectionIndicatorHeight = 4.0f;
    segmentedControl.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:70.0/255.0 blue:30.0/255.0 alpha:1];
    
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:14.0],UITextAttributeFont,[UIColor whiteColor], NSForegroundColorAttributeName,
                          nil];
    
    segmentedControl.titleTextAttributes =size; //@{NSForegroundColorAttributeName : [UIColor whiteColor]};
    segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:0.5 green:0.8 blue:1 alpha:1];
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.shouldAnimateUserSelection = NO;
    
    UIFont *font =[UIFont fontWithName:@"Helvetica-Regular" size:14.0];
    [self.view addSubview:segmentedControl];
    
    self.btnNext.layer.cornerRadius =5;
    self.btnNext.layer.borderWidth =3;
    self.btnNext.layer.borderColor=[UIColor brownColor].CGColor;
    format_index =0;
    selected_format =0;
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.dimBackground = YES;
    [HUD show:true];
    
    [self requestProductInfo];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void) requestProductInfo
{
    if(format_index >=arrFormat.count){
        [HUD removeFromSuperview];
        HUD = nil;
        [self onDisplayWithFormat:0];
        return;
    }

    [[WebClient sharedInstance] requestProductInfoWithID:((CategoryFormats*)arrFormat[format_index]).format_id withCategoryID:self.category_ID withcallback:^(NSArray *response,NSString *symbol) {
        if(response !=nil) {
            [ProductInfoData setObject:response forKey:((CategoryFormats*)arrFormat[format_index]).format_id];
            price_symbol =symbol;
            format_index++;
            [self requestProductInfo];
        }
    }];
}
-(void) onDisplayWithFormat:(int) index
{
    arrProductInfo =ProductInfoData[((CategoryFormats*)arrFormat[index]).format_id];
    [self.tblProductInfo reloadData];
    self.tblProductInfo.contentOffset = CGPointMake(0, 0 - self.tblProductInfo.contentInset.top);
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    selected_format =(int)segmentedControl.selectedSegmentIndex;
    [self onDisplayWithFormat:(int)segmentedControl.selectedSegmentIndex];
}
- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onNext:(id)sender {
    if(!profileInfo.selectedProduct){
        ShowAlert(@"Alert", @"Please select any product.");
        return;
    }
    profileInfo.currencySymbol =price_symbol;
    if ([WebClient sharedInstance].webClientRequestIndex == CANVAS) {
        CanvasEditController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CanvasEditController"];
        [self presentViewController:viewController animated:YES completion:nil];
    }else if([WebClient sharedInstance].webClientRequestIndex == PHOTOBOOKS)
    {
        SelectPhotoController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectPhotoController"];
        [self presentViewController:viewController animated:YES completion:nil];
    }
}
/*
 UIImage *image =[[UIImage imageNamed:@"car_ico.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
 [cell.imgCarIcon setImage:image];
 
 if([tempCar.Status isEqualToString:@"M"])
 {
 [cell.statusLabel setTextColor:[UIColor greenColor]];
 cell.statusLabel.text =@"(Movement)";
 [cell.imgCarIcon setTintColor:[UIColor greenColor]];
 }else if([tempCar.Status isEqualToString:@"P"])
 {
 [cell.statusLabel setTextColor:[UIColor redColor]];
 */
#pragma mark TableView Delegate method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrProductInfo.count;
}
-(UITableViewCell *) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableIdentifier =@"ProductInfoCell";
    ProductInfoCell *cell =(ProductInfoCell*) [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(cell ==nil){
        NSArray *nib =[[NSBundle mainBundle] loadNibNamed:@"ProductInfoCell" owner:self options:nil];
        cell =[nib objectAtIndex:0];
    }
   // [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    Products *aProduct =arrProductInfo[indexPath.row];
    cell.lblSize.text =aProduct.name;
    if (aProduct.rrp == NULL) {
      cell.lblPrice.text =[NSString stringWithFormat:@"%@%@",price_symbol,@"0.0"];
    }else{
      cell.lblPrice.text =[NSString stringWithFormat:@"%@%@",price_symbol,aProduct.rrp];
    }
    if (aProduct.sellprice  == NULL) {
        cell.lblSellPrice.text =[NSString stringWithFormat:@"%@%@",price_symbol,@"0.0"];
    }else{
    cell.lblSellPrice.text =[NSString stringWithFormat:@"%@%@",price_symbol,aProduct.sellprice];
    }
    return cell;
}
-(void) tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    profileInfo.selectedProduct = arrProductInfo[indexPath.row];
}
@end

//
//  CanvasPreviewController.m
//  PhotoBookShop
//
//  Created by Anton Borev on 2/26/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import "CanvasPreviewController.h"
#import "WebClient.h"
@interface CanvasPreviewController ()
{
    int nCount;
    Profile *profileInfo;
    Products *selectedProduct;
    float nPrice;
    NSString *price_symbol;
}
@end

@implementation CanvasPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    profileInfo =[Profile instance];
    selectedProduct =profileInfo.selectedProduct;
    price_symbol =profileInfo.currencySymbol;
    nPrice = [selectedProduct.sellprice floatValue];
    
    self.quantityView.layer.cornerRadius =5;
    self.quantityView.layer.borderColor =[UIColor blackColor].CGColor;
    self.quantityView.layer.borderWidth =1;
    
    self.countView.layer.cornerRadius =5;
    self.countView.layer.borderColor =[UIColor grayColor].CGColor;
    self.countView.layer.borderWidth =1;
    
    self.btnAddtoCart.layer.cornerRadius =3;
    self.btnAddtoCart.layer.borderColor =[UIColor grayColor].CGColor;
    self.btnAddtoCart.layer.borderWidth =2;
    
    nCount =1;
    self.lblTotalNumber.text =[NSString stringWithFormat:@"%d",nCount];
    self.lblSize.text =[NSString stringWithFormat:@"%d x %@",nCount,selectedProduct.name];
    self.lblPrice.text =[NSString stringWithFormat:@"%@%.2f",price_symbol,nPrice*nCount];
    
    self.previewImage.image = profileInfo.editedPhotoImage;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)onPlusClick:(id)sender {
    nCount++;
    self.lblTotalNumber.text =[NSString stringWithFormat:@"%d",nCount];
    self.lblSize.text =[NSString stringWithFormat:@"%d x %@",nCount,selectedProduct.name];
    self.lblPrice.text =[NSString stringWithFormat:@"%@%.2f",price_symbol,nPrice*nCount];


}
- (IBAction)onMinusClick:(id)sender {
    if(nCount >1)
        nCount--;
    self.lblTotalNumber.text =[NSString stringWithFormat:@"%d",nCount];
    self.lblSize.text =[NSString stringWithFormat:@"%d x %@",nCount,selectedProduct.name];
    self.lblPrice.text =[NSString stringWithFormat:@"%@%.2f",price_symbol,nPrice*nCount];


}
- (IBAction)onAddCartClick:(id)sender {
}
- (IBAction)onBackClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark UitextField Delegate Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

@end

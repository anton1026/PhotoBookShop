//
//  CanvasViewController.m
//  PhotoBookShop
//  Copyright © 2016 Peter. All rights reserved.
//

#import "CanvasViewController.h"
#import "WebClient.h"
#import "ProductInfoViewController.h"

@interface CanvasViewController ()
{
    ProductCategorySpecification *selectedProduct;
    MBProgressHUD *HUD;
}
@end

@implementation CanvasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnCanvasSize.layer.cornerRadius =5;
    self.btnCanvasSize.layer.borderWidth =3;
    self.btnCanvasSize.layer.borderColor=[UIColor whiteColor].CGColor;
    [self requestProductCategorySpecification];
    switch ([WebClient sharedInstance].webClientRequestIndex) {
        case CANVAS:
            self.lblTitle.text = @"Canvas Prints";
            [self.btnCanvasSize setTitle:@"Select Canvas Size" forState:UIControlStateNormal];
            break;
        case PHOTOBOOKS:
            self.lblTitle.text = @"Photo Books";
            [self.btnCanvasSize setTitle: @"Select Book Size" forState:UIControlStateNormal];
            
            break;
        default:
            break;
    }
}
-(void) requestProductCategorySpecification
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.dimBackground = YES;
    [HUD show:true];
    
    [[WebClient sharedInstance] requestProductCategorySpecifics:[NSString stringWithFormat:@"%d",(int)([WebClient sharedInstance].webClientRequestIndex + 1)] withcallback:^(ProductCategorySpecification *response) {
        if(response !=nil){
            selectedProduct =response;
            [self onDisplay];
        }else{
            [HUD removeFromSuperview];
            HUD = nil;
            ShowAlert(@"", @"Sever Error");
        }
    }];
}
-(void) onDisplay
{
    NSString *strURL =[NSString stringWithFormat:@"%@%@",SiteURL,selectedProduct.bannerurl];
    NSURL* imageURL = [NSURL URLWithString:strURL];
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *image = [[NSData alloc] initWithContentsOfURL:imageURL];
        //this will set the image when loading is finished
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD removeFromSuperview];
            HUD = nil;
            UIImage *img =[UIImage imageWithData:image];
            self.imageCanvasView.image =img;
            [Profile instance].product_image =img;
            
            //******
            self.lblPriceTitle.text =[NSString stringWithFormat:@"From %@%@",selectedProduct.symbol,selectedProduct.fromprice];
            self.lblDescriptionTitle.text =selectedProduct.title;
            
            NSMutableAttributedString *attrString =[[NSMutableAttributedString alloc] initWithData:[selectedProduct.canvas_description dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//            UIFont *font =[UIFont fontWithName:@"Helvetica-Regular" size:16.0];
//            NSInteger _length =[selectedProduct.canvas_description length];
//            NSRange range =NSMakeRange(0,_length);
//            [attrString addAttribute:NSFontAttributeName value:font range:range];
            self.lblDescription.attributedText = attrString;
            [self.descriptionTextView setText:selectedProduct.canvas_description];

        });
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onSelectCanvasSize:(id)sender {
   
    ProductInfoViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductInfoViewController"];
    viewController.arrFormat =selectedProduct.formats;
    viewController.category_ID =[NSString stringWithFormat:@"%d",(int)[WebClient sharedInstance].webClientRequestIndex + 1];
    [self presentViewController:viewController animated:YES completion:nil];
}
@end

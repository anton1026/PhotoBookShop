//
//  CanvasEditController.m
//  PhotoBookShop
//  Copyright © 2016 Peter. All rights reserved.
//

#import "CanvasEditController.h"
#import "SelectPhotoController.h"
#import "PhotoEditController.h"
#import "CanvasPreviewController.h"
#import "WebClient.h"
@interface CanvasEditController ()
{
    Profile *profileInfo;
    Products *selectedProduct;
    NSString *price_symbol;
    UIImage *editImage;
    BOOL WrapMode;
    double canvas_width;
    double canvas_height;
}
@end

@implementation CanvasEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    profileInfo =[Profile instance];
    selectedProduct =profileInfo.selectedProduct;
    price_symbol =profileInfo.currencySymbol;
    [self.canvasImage setBackgroundColor:[UIColor lightGrayColor]];
    switch ([WebClient sharedInstance].webClientRequestIndex) {
        case CANVAS:
            self.lblTitle.text = @"Canvas Prints";
            break;
        case PHOTOBOOKS:
            self.lblTitle.text = @"Photo Prints";
        default:
            break;
    }
    self.btnSelectPhotos.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.btnSelectPhotos.titleLabel.numberOfLines =2;
    
    self.btnEditPhotos.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.btnEditPhotos.titleLabel.numberOfLines =2;
    
    UITapGestureRecognizer *singleFingerTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.canvas_view addGestureRecognizer:singleFingerTap];

    self.lblProductSize.text =selectedProduct.name;
    if (selectedProduct.rrp == NULL) {
     self.lblOldPrice.text =[NSString stringWithFormat:@"%@%@",price_symbol,@"0.0"];
    }else{
        self.lblOldPrice.text =[NSString stringWithFormat:@"%@%@",price_symbol,selectedProduct.rrp];
    }
    if (selectedProduct.sellprice == NULL) {
            self.lblCurPrice.text =[NSString stringWithFormat:@"%@%@",price_symbol,@"0.0"];
    }else{
    self.lblCurPrice.text =[NSString stringWithFormat:@"%@%@",price_symbol,selectedProduct.sellprice];
    }
    WrapMode =true;
    profileInfo.warpMode =WrapMode;
    [self setCanvasSize];
    
}
-(void) handleSingleTap:(UITapGestureRecognizer *) recognizer
{
    if(!profileInfo.editedPhotoImage)
    {
        SelectPhotoController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectPhotoController"];
        [self presentViewController:viewController animated:YES completion:nil];
    }else{
        PhotoEditController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoEditController"];
        viewController.canvas_width =self.canvas_width.constant;
        viewController.canvas_height =self.canvas_height.constant;
        [self presentViewController:viewController animated:YES completion:nil];
    }
}
-(void) setCanvasSize
{
    int product_width  = [selectedProduct.width intValue];
    int product_height = [selectedProduct.height intValue];
    double ratio=1.0;
    double border_ratio = 1.0;
    border_ratio = product_width / 200.0f;
    
    profileInfo.border_delta = 50 / border_ratio;
    if(product_height >product_width)
    {
        ratio =(product_width*1.0) /(product_height*1.0);

        self.canvas_height.constant =350;
        self.canvas_width.constant =(int) (350 *ratio);
    }else{
        ratio =(product_height*1.0) /(product_width*1.0);
        self.canvas_width.constant =300;
        self.canvas_height.constant =(int) (300*ratio);
    }
    
    self.CanvasImageConstrianWidth.constant = self.canvas_width.constant - 2 * profileInfo.border_delta;
    self.CanvasImageConstrainHeight.constant = self.canvas_height.constant - 2 * profileInfo.border_delta;
    
    [self.canvas_view layoutIfNeeded];

}
-(void) viewDidAppear:(BOOL)animated
{
    self.dashBorderView.borderType =BorderTypeDashed;
    self.dashBorderView.dashPattern =4;
    self.dashBorderView.spacePattern =4;
    self.dashBorderView.borderWidth =2;
    self.dashBorderView.borderColor =[UIColor whiteColor];
    self.dashBorderView.cornerRadius =0;
    [self.dashBorderView layoutIfNeeded];
    [self.view setNeedsDisplay];
    
    CGFloat imageWidth = profileInfo.editedPhotoImage.size.width;
    CGFloat imageHeight = profileInfo.editedPhotoImage.size.height;
    
    CGFloat imageViewWidth = self.canvasImage.bounds.size.width;
    CGFloat imageViewHeight = self.canvasImage.bounds.size.height;
    
    
    self.canvasWrapImage.image =profileInfo.editedPhotoImage;
    if(WrapMode){
        [self.canvasImage setBackgroundColor:[UIColor lightGrayColor]];
        self.canvasWrapImage.hidden = YES;
        self.canvasImage.image = profileInfo.editedPhotoImage;
    }
    else{
        [self.canvasImage setBackgroundColor:[UIColor darkGrayColor]];
        self.canvasWrapImage.hidden = NO;
        self.canvasImage.image = nil;
    }
    [self maskImageView:self.canvasImage];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)onPreviewClick:(id)sender {
    CanvasPreviewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CanvasPreviewController"];
    viewController.canvas_width =self.canvas_width.constant;
    viewController.canvas_height =self.canvas_height.constant;
    [self presentViewController:viewController animated:YES completion:nil];
}
- (IBAction)onBackClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onHelpClick:(id)sender {
}
- (IBAction)onSelectPhotos:(id)sender {
   SelectPhotoController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectPhotoController"];
   [self presentViewController:viewController animated:YES completion:nil];
}
- (IBAction)onStylesClick:(id)sender {
}
- (IBAction)onBorderClick:(id)sender {
    if(profileInfo.editedPhotoImage ==nil)
        return;
    PhotoEditController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoEditController"];
    viewController.canvas_width =self.canvas_width.constant;
    viewController.canvas_height =self.canvas_height.constant;
    [self presentViewController:viewController animated:YES completion:nil];
}
- (IBAction)onRotationClick:(id)sender {
}
- (IBAction)onShareClick:(id)sender {
}

- (void)maskImageView:(UIImageView *)image
{
    UIBezierPath *path = [self getPath];
    
    CGRect rect = CGRectZero;
    rect.size = image.image.size;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(0, 0, image.frame.size.width, image.frame.size.height);
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
    shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
    [image.layer setMask:shapeLayer];
}

-(UIBezierPath *)getPath{
    NSMutableArray *arrPoint =[[NSMutableArray alloc] init];
    CGFloat x1,y1;
    CGFloat borderWidth;
    borderWidth =profileInfo.border_delta;
    
    x1 =self.canvasImage.bounds.origin.x + borderWidth;
    y1 =self.canvasImage.bounds.origin.y;
    [arrPoint addObject:[NSValue valueWithCGPoint:CGPointMake(x1, y1)]];

    x1 =self.canvasImage.bounds.origin.x +self.canvasImage.bounds.size.width- borderWidth;
    y1 =self.canvasImage.bounds.origin.y;
    [arrPoint addObject:[NSValue valueWithCGPoint:CGPointMake(x1, y1)]];

    x1 =self.canvasImage.bounds.origin.x +self.canvasImage.bounds.size.width- borderWidth;
    y1 =self.canvasImage.bounds.origin.y + borderWidth;
    [arrPoint addObject:[NSValue valueWithCGPoint:CGPointMake(x1, y1)]];

    x1 =self.canvasImage.bounds.origin.x +self.canvasImage.bounds.size.width;
    y1 =self.canvasImage.bounds.origin.y + borderWidth;
    [arrPoint addObject:[NSValue valueWithCGPoint:CGPointMake(x1, y1)]];

    
    x1 =self.canvasImage.bounds.origin.x +self.canvasImage.bounds.size.width;
    y1 =self.canvasImage.bounds.origin.y + borderWidth;
    [arrPoint addObject:[NSValue valueWithCGPoint:CGPointMake(x1, y1)]];


    x1 =self.canvasImage.bounds.origin.x +self.canvasImage.bounds.size.width;
    y1 =self.canvasImage.bounds.origin.y +self.canvasImage.bounds.size.height- borderWidth;
    [arrPoint addObject:[NSValue valueWithCGPoint:CGPointMake(x1, y1)]];

    x1 =self.canvasImage.bounds.origin.x +self.canvasImage.bounds.size.width -borderWidth;
    y1 =self.canvasImage.bounds.origin.y +self.canvasImage.bounds.size.height- borderWidth;
    [arrPoint addObject:[NSValue valueWithCGPoint:CGPointMake(x1, y1)]];

    x1 =self.canvasImage.bounds.origin.x +self.canvasImage.bounds.size.width-borderWidth;
    y1 =self.canvasImage.bounds.origin.y +self.canvasImage.bounds.size.height;
    [arrPoint addObject:[NSValue valueWithCGPoint:CGPointMake(x1, y1)]];


    
    x1 =self.canvasImage.bounds.origin.x +borderWidth;
    y1 =self.canvasImage.bounds.origin.y +self.canvasImage.bounds.size.height;
    [arrPoint addObject:[NSValue valueWithCGPoint:CGPointMake(x1, y1)]];

    x1 =self.canvasImage.bounds.origin.x +borderWidth;
    y1 =self.canvasImage.bounds.origin.y +self.canvasImage.bounds.size.height-borderWidth;
    [arrPoint addObject:[NSValue valueWithCGPoint:CGPointMake(x1, y1)]];

    x1 =self.canvasImage.bounds.origin.x;
    y1 =self.canvasImage.bounds.origin.y +self.canvasImage.bounds.size.height-borderWidth;
    [arrPoint addObject:[NSValue valueWithCGPoint:CGPointMake(x1, y1)]];

    
    x1 =self.canvasImage.bounds.origin.x;
    y1 =self.canvasImage.bounds.origin.y +borderWidth;
    [arrPoint addObject:[NSValue valueWithCGPoint:CGPointMake(x1, y1)]];

    x1 =self.canvasImage.bounds.origin.x+borderWidth;
    y1 =self.canvasImage.bounds.origin.y +borderWidth;
    [arrPoint addObject:[NSValue valueWithCGPoint:CGPointMake(x1, y1)]];

    
    NSArray *points =[NSArray arrayWithArray:arrPoint];
    
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    
    // Set the starting point of the shape.
    CGPoint p1 = [[points objectAtIndex:0] CGPointValue];
    [aPath moveToPoint:CGPointMake(p1.x, p1.y)];
    
    for (uint i=1; i<points.count; i++)
    {
        CGPoint p = [[points objectAtIndex:i] CGPointValue];
        [aPath addLineToPoint:CGPointMake(p.x, p.y)];
    }
    [aPath closePath];
    return aPath;
}
- (void)maskImageViewNone:(UIImageView *)image
{
    UIBezierPath *path = [self getPathNone];
    
    CGRect rect = CGRectZero;
    rect.size = image.image.size;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(0, 0, image.frame.size.width, image.frame.size.height);
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
    shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
    [image.layer setMask:shapeLayer];
}

-(UIBezierPath *)getPathNone{
    NSMutableArray *arrPoint =[[NSMutableArray alloc] init];
    CGFloat x1,y1;
    CGFloat borderWidth;
    borderWidth =profileInfo.border_delta;
    
    x1 =self.canvasImage.bounds.origin.x + borderWidth;
    y1 =self.canvasImage.bounds.origin.y+ borderWidth;
    [arrPoint addObject:[NSValue valueWithCGPoint:CGPointMake(x1, y1)]];
    
    x1 =self.canvasImage.bounds.origin.x +self.canvasImage.bounds.size.width- borderWidth;
    y1 =self.canvasImage.bounds.origin.y + borderWidth;
    [arrPoint addObject:[NSValue valueWithCGPoint:CGPointMake(x1, y1)]];
    
    x1 =self.canvasImage.bounds.origin.x +self.canvasImage.bounds.size.width- borderWidth;
    y1 =self.canvasImage.bounds.origin.y +self.canvasImage.bounds.size.height- borderWidth;
    [arrPoint addObject:[NSValue valueWithCGPoint:CGPointMake(x1, y1)]];
    
    
    
    x1 =self.canvasImage.bounds.origin.x +borderWidth;
    y1 =self.canvasImage.bounds.origin.y +self.canvasImage.bounds.size.height-borderWidth;
    [arrPoint addObject:[NSValue valueWithCGPoint:CGPointMake(x1, y1)]];
    NSArray *points =[NSArray arrayWithArray:arrPoint];
    
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    
    // Set the starting point of the shape.
    CGPoint p1 = [[points objectAtIndex:0] CGPointValue];
    [aPath moveToPoint:CGPointMake(p1.x, p1.y)];
    
    for (uint i=1; i<points.count; i++)
    {
        CGPoint p = [[points objectAtIndex:i] CGPointValue];
        [aPath addLineToPoint:CGPointMake(p.x, p.y)];
    }
    [aPath closePath];
    return aPath;
}

- (IBAction)onChangeWrapMode:(id)sender {
    UISwitch *switchMode =(UISwitch*)sender;
    if(switchMode.isOn){
        WrapMode =YES;
        profileInfo.warpMode =WrapMode;
        self.canvasWrapImage.hidden = YES;
        [self.canvasImage setBackgroundColor:[UIColor lightGrayColor]];
        self.canvasImage.image =profileInfo.editedPhotoImage;
    }else{
        WrapMode = NO;
        profileInfo.warpMode =WrapMode;
        [self.canvasImage setBackgroundColor:[UIColor darkGrayColor]];
        self.canvasWrapImage.hidden = NO;
        self.canvasImage.image =nil;
    }
    [self maskImageView:self.canvasImage];

}
@end

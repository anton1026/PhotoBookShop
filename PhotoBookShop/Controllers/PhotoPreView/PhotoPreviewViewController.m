//
//  PhotoPreviewViewController.m
//  PhotoBookShop
//  Copyright © 2016 Peter. All rights reserved.
//

#import "PhotoPreviewViewController.h"
#import "WebClient.h"
#import "AnimationDelegate.h"
#import "FlipView.h"



@interface PhotoPreviewViewController ()
{
    int nCount;
    Profile *profileInfo;
    Products *selectedProduct;
    float nPrice;
    NSString *price_symbol;
    int count;

}

@end

@implementation PhotoPreviewViewController

- (void)viewDidLoad {
    count = 0;
    [super viewDidLoad];
    [self preViewFliper];
    
    // Do any additional setup after loading the view.
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
    
    self.btnAddCart.layer.cornerRadius =3;
    self.btnAddCart.layer.borderColor =[UIColor grayColor].CGColor;
    self.btnAddCart.layer.borderWidth =2;
    
    nCount =1;
    self.lblTotalNumber.text =[NSString stringWithFormat:@"%d",nCount];
    NSArray* foo = [selectedProduct.name componentsSeparatedByString: @" "];
    NSString* firstBit = [foo objectAtIndex: 0];
    self.lblSize.text =[NSString stringWithFormat:@"%d x %@",nCount,firstBit];
    self.lblPrice.text =[NSString stringWithFormat:@"%@%.2f",price_symbol,nPrice*nCount];

    
}
#pragma mark ImageMerge
-(UIImage *)onCoverImageMerge:(UIImage *)image1 withImage2:(UIImage *)image2{
    CGFloat total_width = 500;
    CGFloat total_heigt = 250;
    CGFloat diff  = 10;
    CGFloat x = 0;
    CGFloat y = 0;
    UIView *mergeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 500, 250)];
    UIImageView *imgView1, *imgView2;
    imgView1 = [[UIImageView alloc] initWithImage:image1];
    imgView2 = [[UIImageView alloc] initWithImage:image2];
    imgView1.frame = CGRectMake(x + 10, y + 10, total_width/2 - diff - 2, total_heigt - diff * 2);
    imgView2.frame = CGRectMake(total_width/2 + 2, y + 10, total_width/2 - diff - 2, total_heigt - diff * 2);
    [mergeView addSubview:imgView1];
    [mergeView addSubview:imgView2];
    UIGraphicsBeginImageContext(mergeView.bounds.size);
    [mergeView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImage;
}
- (void)preViewFliper{
    animationDelegate2 = [[AnimationDelegate alloc] initWithSequenceType:kSequenceControlled
                                                           directionType:kDirectionForward];
    animationDelegate2.controller = self;
    animationDelegate2.perspectiveDepth = 2000;
    float diff = 80;
    CGRect rectSize = CGRectMake(self.view.frame.size.width/2 -(_panRegionView.frame.size.height+diff)/2
                                 , _panRegionView.frame.origin.y,_panRegionView.frame.size.height + diff, _panRegionView.frame.size.height - 30);
    CGSize reSize = CGSizeMake(_panRegionView.frame.size.height + 100 ,_panRegionView.frame.size.height - diff);
    self.flipView2 = [[FlipView alloc] initWithAnimationType:kAnimationFlipHorizontal
                                                       frame:rectSize];
    animationDelegate2.transformView = _flipView2;
    
    [self.view addSubview:_flipView2];
    int i = 0;
    for (i = 0; i < _preViewImageArray.count; i ++) {
        [_flipView2 printText:@"" usingImage:[self imageWithImage:_preViewImageArray[i] convertToSize:reSize] backgroundColor:[self colorWithHexString:@"E8EAF6"] textColor:[UIColor whiteColor]];
    }
    self.panRegion = [[UIView alloc] initWithFrame:rectSize];
    [self.view addSubview:_panRegion];
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    _panRecognizer.delegate = self;
    _panRecognizer.maximumNumberOfTouches = 1;
    _panRecognizer.minimumNumberOfTouches = 1;
    [self.view addGestureRecognizer:_panRecognizer];
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (animationDelegate2.repeat) {
        [animationDelegate2 startAnimation:kDirectionNone];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [animationDelegate2 resetTransformValues];
    [NSObject cancelPreviousPerformRequestsWithTarget:animationDelegate2];
}

#pragma mark imageResize
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}
- (void)toggleRepeat:(UIButton *)sender
{

}

- (void)toggleReverse:(UIButton *)sender
{

}

- (void)toggleShadow:(UIButton *)sender
{

}

- (void)panned:(UIPanGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStatePossible:
            break;
            //        case UIGestureRecognizerStateRecognized: // for discrete recognizers
            //            break;
        case UIGestureRecognizerStateFailed: // cannot recognize for multi touch sequence
            break;
        case UIGestureRecognizerStateBegan: {
            // allow controlled flip only when touch begins within the pan region
            if (CGRectContainsPoint(_panRegion.frame, [recognizer locationInView:self.view])) {
                if (animationDelegate2.animationState == 0) {
                    [NSObject cancelPreviousPerformRequestsWithTarget:self];
                    animationDelegate2.sequenceType = kSequenceControlled;
                    animationDelegate2.animationLock = YES;
                }
            }
        }
            break;
        case UIGestureRecognizerStateChanged: {
            if (animationDelegate2.animationLock) {
                switch (_flipView2.animationType) {
                    case kAnimationFlipVertical: {
                        float value = [recognizer translationInView:self.view].y;
                        [animationDelegate2 setTransformValue:value delegating:YES];
                    }
                        break;
                    case kAnimationFlipHorizontal: {
                        float value = [recognizer translationInView:self.view].x;
                        [animationDelegate2 setTransformValue:value delegating:YES];
                    }
                        break;
                    default:break;
                }
            }
        }
            break;
        case UIGestureRecognizerStateCancelled: // cancellation touch
            break;
        case UIGestureRecognizerStateEnded: {
            if (animationDelegate2.animationLock) {
                count ++;
                self.lblPageNumber.text = [NSString stringWithFormat:@"%d",count];
                
                if (count == [Profile instance].arrayCoverImages.count - 1) {
                    count = -1;
//                    [self preViewFliper];
                }
                NSLog(@"%d",count);
                // provide inertia to panning gesture
                float value = sqrtf(fabsf([recognizer velocityInView:self.view].x))/10.0f;
                [animationDelegate2 endStateWithSpeed:value];
            }
        }
            break;
        default:
            break;
    }
}

// use this to trigger events after specific interactions
- (void)animationDidFinish:(int)direction
{
//    switch (step) {
//        case 0:
//            break;
//        case 1:
//            break;
//        default:break;
//    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onPlusQuantity:(id)sender {
    nCount++;
    NSLog(@"Ncount %d",nCount);
    self.lblTotalNumber.text =[NSString stringWithFormat:@"%d",nCount];
    NSArray* foo = [selectedProduct.name componentsSeparatedByString: @" "];
    NSString* firstBit = [foo objectAtIndex: 0];
    self.lblSize.text =[NSString stringWithFormat:@"%d x %@",nCount,firstBit];
    self.lblPrice.text =[NSString stringWithFormat:@"%@%.2f",price_symbol,nPrice*nCount];
}
- (IBAction)onMinusQuantity:(id)sender {
    NSLog(@"Ncount %d",nCount);
    if(nCount >1)
        nCount--;
    self.lblTotalNumber.text =[NSString stringWithFormat:@"%d",nCount];
    NSArray* foo = [selectedProduct.name componentsSeparatedByString: @" "];
    NSString* firstBit = [foo objectAtIndex: 0];
    self.lblSize.text =[NSString stringWithFormat:@"%d x %@",nCount,firstBit];
    self.lblPrice.text =[NSString stringWithFormat:@"%@%.2f",price_symbol,nPrice*nCount];
}

- (IBAction)onAddCart:(id)sender {
}
#pragma mark color to hex
-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end

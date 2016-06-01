//
//  PhotoEditController.m
//  PhotoBookShop
//  Copyright © 2016 Peter. All rights reserved.
//

#import "PhotoEditController.h"
#import "FilterCell.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "WebClient.h"
#import "PhotoCustomViewController.h"
#import "PhotoBookCoverViewController.h"


@interface PhotoEditController ()
{
    float cellWidth;
    float cellHeight;
    NSArray *arrFilterTitle;
    int selectedFilter;
    UIImage *filterCellImage;
    NSArray *arrFilteName;
    NSMutableArray *arrFilterImage;
    Profile *profile;
}
@end


@implementation PhotoEditController

@synthesize selectedImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    profile =[Profile instance];
    if ([WebClient sharedInstance].webClientRequestIndex == CANVAS) {
        
        selectedImage =profile.selectedPhotoImage;
    }else if([WebClient sharedInstance].webClientRequestIndex == PHOTOBOOKS)
    {
        selectedImage = [Profile instance].arrExpandPhotos[self.selectedIndex + 2];
    }else if ([WebClient sharedInstance].webClientRequestIndex  == PHOTOCOVER)
    {
        selectedImage = [Profile instance].arrFrontCoverPhotos[self.selectedIndex];
    }
    cellWidth = 80;
    cellHeight =120;
    selectedFilter =0;
    arrFilterTitle = @[@"Normal", @"Curve",@"Chrome",@"Fade",@"Instant",@"Mono",@"Noir",@"Process",@"Tonal",@"Transfer",@"Vignette",@"Tone"];
    arrFilteName =@[@"Original",@"CILinearToSRGBToneCurve",@"CIPhotoEffectChrome",@"CIPhotoEffectFade",
                    @"CIPhotoEffectInstant",@"CIPhotoEffectMono",@"CIPhotoEffectNoir",@"CIPhotoEffectProcess",@"CIPhotoEffectTonal",@"CIPhotoEffectTransfer",@"CIVignette",@"CISepiaTone"];

    filterCellImage =[UIImage imageNamed:@"filterImage"];
   // selectedImage = [UIImage imageNamed:@"filterImage"];

    arrFilterImage =[[NSMutableArray alloc] init];
    for(int i=0; i<arrFilteName.count; i++)
    {
        if(i==0){
           [arrFilterImage addObject: filterCellImage];
        }else{
           [arrFilterImage addObject:[self addImageEffect:filterCellImage Filter:arrFilteName[i]]];
        }
    }
    [self.filterCollectionView reloadData];
    self.cropView.cropsImageToCircle = NO;
    self.cropview_height.constant = self.canvas_height*1.5;
    self.cropview_width.constant = self.canvas_width*1.5;
    if (profile.editedPhotoImage){
        self.cropView.image = profile.editedPhotoImage;
    }
    else
    {
        self.cropView.image =selectedImage;
    }
    self.cropView.cropSize =CGSizeMake(self.canvas_width, self.canvas_height);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onCancel:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)onDone:(id)sender {
    
    [self.cropView renderCroppedImage:^(UIImage *croppedImage, CGRect cropRect){
        profile.cropPhotoImage =croppedImage;
        if ([WebClient sharedInstance].webClientRequestIndex  == CANVAS) {
            
            profile.editedPhotoImage = profile.cropPhotoImage;
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else if ([WebClient sharedInstance].webClientRequestIndex == PHOTOBOOKS)
        {
            
            [[Profile instance].arrayCoverImages removeObjectAtIndex:self.selectedIndex];
            [[Profile instance].arrayCoverImages insertObject:croppedImage atIndex:self.selectedIndex];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else if ([WebClient sharedInstance].webClientRequestIndex == PHOTOCOVER)
        {
            [[Profile instance].arrFrontCoverPhotos removeObjectAtIndex:self.selectedIndex];
            [[Profile instance].arrFrontCoverPhotos insertObject:croppedImage atIndex:self.selectedIndex];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}
- (IBAction)onFlipX:(id)sender {
    
    UIImage *flippedImage =[UIImage imageWithCGImage:selectedImage.CGImage scale:selectedImage.scale orientation:UIImageOrientationLeftMirrored];
    selectedImage =[self rotationImage:flippedImage];
    self.cropView.image =selectedImage;
    return;
}
- (IBAction)onFlipY:(id)sender {
    
    UIImage *flippedImage =[UIImage imageWithCGImage:selectedImage.CGImage scale:selectedImage.scale orientation:UIImageOrientationUpMirrored];
    selectedImage =flippedImage;
    self.cropView.image =selectedImage;
    return;
}
- (IBAction)onRotation:(id)sender {
    
    UIImage *flippedImage = [self imageRotatedByDegrees:90.0 withImage:selectedImage];
    //[UIImage imageWithCGImage:selectedImage.CGImage scale:selectedImage.scale orientation:UIImageOrientationLeft];
    selectedImage =flippedImage;
    self.cropView.image =selectedImage;
    return;
    
}
#pragma mark - Collection View Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrFilterTitle.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FilterCell * cell =(FilterCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"FilterCell" forIndexPath:indexPath];
    cell.layer.borderColor =[UIColor darkGrayColor].CGColor;
    cell.layer.borderWidth =1;
    cell.filterImage.layer.cornerRadius =3;
    cell.filterImage.layer.borderWidth =1.5;
    if(selectedFilter == indexPath.row){
        cell.filterImage.layer.borderColor =[UIColor whiteColor].CGColor;
        cell.maskView.hidden =YES;
    }else{
        cell.filterImage.layer.borderColor =[UIColor grayColor].CGColor;
        cell.maskView.hidden =NO;
    }
    cell.lblFilterName.text =arrFilterTitle[indexPath.row];
    cell.filterImage.image =arrFilterImage[indexPath.row];
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectedFilter =(int)indexPath.row;
    [self.filterCollectionView reloadData];
    if(selectedFilter ==0){
        self.cropView.image =selectedImage;
    }else{
      self.cropView.image = [self addImageEffect:selectedImage Filter:arrFilteName[selectedFilter]];
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
#pragma mark - UICollectionViewFlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(cellWidth, cellHeight);
}
#pragma mark apply effect
-(UIImage *) addImageEffect:(UIImage *) image Filter:(NSString *) imageFilter{
    CIImage *ciimage =[[CIImage alloc] initWithImage:image];
    CIFilter *_filter =[CIFilter filterWithName:imageFilter keysAndValues:kCIInputImageKey,ciimage, nil];
    [_filter setDefaults];
    CIContext *context =[CIContext contextWithOptions:nil];
    CIImage *output =[_filter outputImage];
    CGImageRef *cgImage =[context createCGImage:output fromRect:[output extent]];
    UIImage *resultImage =[UIImage imageWithCGImage:cgImage scale:1.0 orientation:[image imageOrientation]];
    return resultImage;
}
-(UIImage*) rotationImage:(UIImage*) sourceImage
{
    UIImageOrientation imageOrientation;
    
    switch (sourceImage.imageOrientation) {
        case UIImageOrientationDown:
            imageOrientation = UIImageOrientationDownMirrored;
            break;
            
        case UIImageOrientationDownMirrored:
            imageOrientation = UIImageOrientationDown;
            break;
            
        case UIImageOrientationLeft:
            imageOrientation = UIImageOrientationLeftMirrored;
            break;
            
        case UIImageOrientationLeftMirrored:
            imageOrientation = UIImageOrientationLeft;
            
            break;
            
        case UIImageOrientationRight:
            imageOrientation = UIImageOrientationRightMirrored;
            
            break;
            
        case UIImageOrientationRightMirrored:
            imageOrientation = UIImageOrientationRight;
            
            break;
            
        case UIImageOrientationUp:
            imageOrientation = UIImageOrientationUpMirrored;
            break;
            
        case UIImageOrientationUpMirrored:
            imageOrientation = UIImageOrientationUp;
            break;
        default:
            break;
    }
    
    UIImage* resultImage = [UIImage imageWithCGImage:sourceImage.CGImage scale:sourceImage.scale orientation:imageOrientation];
    return resultImage;
}
-(UIImage *) imageRotatedByDegrees:(CGFloat) degress withImage:(UIImage*) oldImage
{
    UIView *rotatedViewBox =[[UIView alloc] initWithFrame:CGRectMake(self.cropView.frame.origin.x, self.cropView.frame.origin.y, self.cropView.frame.size.width, self.cropView.frame.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degress * M_PI / 180);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, (degress * M_PI / 180));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.cropView.frame.size.width, self.cropView.frame.size.height / 2, self.cropView.frame.size.width,self.cropView.frame.size.height), oldImage.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end

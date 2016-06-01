//
//  PhotoCustomViewController.m
//  PhotoBookShop
//  Copyright © 2016 Peter. All rights reserved.
//

#import "PhotoCustomViewController.h"
#import "PhotoCustomCell.h"
#import "PhotoCoverCell.h"
#import "LXReorderableCollectionViewFlowLayout.h"
#import "PhotoEditController.h"
#import "ProfileInfo.h"
#import "ProductCategory.h"
#import "PhotoPreviewViewController.h"
#import "PhotoBookCoverViewController.h"
#import "PhotoCustomFristCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIView.h>
#import <Photos/Photos.h>
#import "MBProgressHUD.h"
@interface PhotoCustomViewController ()<LXReorderableCollectionViewDelegateFlowLayout,LXReorderableCollectionViewDataSource>
{
    NSInteger countArray;
    UIImage *coverMergeImage;
    UIImage *imageBackground;
    UIImage *imageFrontCover;
    Products *selectedProduct;
    MBProgressHUD *HUD;
    UIImage *imageEndCover;
    NSMutableArray *arrMergeConstrant;
    NSArray *imgPointArr;
    UIImage *imgMerge;
    int countAsset;
    int totalAssetCount ;
}
@property UIImage *editedImage;
@property (nonatomic, strong) PHCachingImageManager *imageManager;
@end

@implementation PhotoCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageManager = [[PHCachingImageManager alloc]  init];
    selectedProduct = [Profile instance].selectedProduct;
    self.photoCustomCollectionView.delegate = self;
    self.photoCustomCollectionView.dataSource =  self;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.dimBackground = YES;
    [HUD show:true];
    
    countArray = [Profile instance].arrayCoverAssets.count + 2;
    NSLog(@"CountArray = %d",(int)countArray);
    int product_width  = [selectedProduct.width intValue];
    int product_height = [selectedProduct.height intValue];
    double ratio=1.0;
    ratio =(product_height*1.0) /(product_width*1.0);
    self.coverCollectionHeight.constant = (self.view.frame.size.width/2 - 5) *ratio;
    NSLog(@"CellHeight = %f",self.coverCollectionHeight.constant);
    [self.photoCoverCollectionView layoutIfNeeded];


    
}
- (void)viewWillAppear:(BOOL)animated
{
    PHImageRequestOptions *options =[[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.resizeMode =PHImageRequestOptionsResizeModeFast;
    options.deliveryMode =PHImageRequestOptionsDeliveryModeHighQualityFormat;
    countAsset = 0;
    
    totalAssetCount = (int)[Profile instance].arrayCoverAssets.count;
    for (int index = 0; index < totalAssetCount; index ++) {
        PHAsset *asset = [Profile instance].arrayCoverAssets[index];
        
        [self.imageManager requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation UIImageOrientationUp, NSDictionary * _Nullable info) {
            
            
            [[Profile instance].arrayCoverImages addObject:[UIImage imageWithData:imageData]];
            countAsset ++;
            if (countAsset == totalAssetCount) {
                ///disappear loading screen
                [HUD removeFromSuperview];
                HUD = nil;
            }
        }];
    }
    NSLog(@"Loaded Images = %@",[Profile instance].arrayCoverImages);

    [self makeCoverImage];
    [self makeExpandArray];
}
- (void)makeCoverImage{
    imageEndCover = [UIImage imageNamed:@"black"];
    imageFrontCover = [UIImage imageNamed:@"white"];
    int index = 0;
    if ([Profile instance].arrFrontCoverPhotos.count  == 0) {
            for (index  = 0; index < 4 ; index ++) {
                [[Profile instance].arrFrontCoverPhotos addObject:[Profile instance].arrayCoverImages[index]];
            }
        [self.photoCoverCollectionView reloadData];
        [self.photoCustomCollectionView reloadData];
    }else{
        if ([Profile instance].isCoverEdited == true) {
            [Profile instance].isCoverEdited = false;
        }else{
            for (int indexFrontCover = 0; indexFrontCover < 4; indexFrontCover ++) {
                [[Profile instance].arrFrontCoverPhotos addObject:[Profile instance].arrayCoverImages[index]];
            }
        }     
        [self.photoCoverCollectionView reloadData];
        [self.photoCustomCollectionView reloadData];
    }
}
- (void)makeExpandArray{
    if ([Profile instance].arrExpandPhotos.count == 0) {
        for (int index = 0; index < countArray; index ++) {
            if (index == 0)
            {
                 [[Profile instance].arrExpandPhotos addObject:imageFrontCover];
            }
            else if(index == 1)
            {
               [[Profile instance].arrExpandPhotos addObject:[Profile instance].arrFrontCoverPhotos];
            }
            else{
                [[Profile instance].arrExpandPhotos addObject:[Profile instance].arrayCoverImages[index - 2]];
            }
        }
    }else{
        [Profile instance].arrExpandPhotos  = [NSMutableArray array];
        for (int index = 0; index < countArray; index ++) {
            if (index == 0)
            {
                [[Profile instance].arrExpandPhotos insertObject:imageFrontCover atIndex:index];
            }
            else if(index == 1)
            {
                [[Profile instance].arrExpandPhotos insertObject:[Profile instance].arrFrontCoverPhotos atIndex:index];
            }
            else{
                [[Profile instance].arrExpandPhotos insertObject:[Profile instance].arrayCoverImages[index - 2] atIndex:index];
            }
        }
    }
    [self.photoCoverCollectionView reloadData];
    [self.photoCustomCollectionView reloadData];
    arrMergeConstrant = [Profile instance].arrExpandPhotos;
    NSLog(@"ARRAT =  %@",arrMergeConstrant);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Collection View Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([Profile instance].arrExpandPhotos.count > 0) {
        if (collectionView.tag == 0) {
            return  2;
        }else{
            NSLog(@"Cell Count %d",(int)[Profile instance].arrExpandPhotos.count);
            return [Profile instance].arrExpandPhotos.count- 2;
            
        }
    }else{
        return 0;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 0) {
        if (indexPath.row == 0) {
            PhotoCustomFristCell * cellFrist =(PhotoCustomFristCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCustomFristCell" forIndexPath:indexPath];
            cellFrist.imageCustomFirst.image = imageFrontCover;
            return cellFrist;
        }
        else if(indexPath.row == 1){
            PhotoCoverCell *cellCover = (PhotoCoverCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCoverCell" forIndexPath:indexPath];
            NSMutableArray *tempArray = [NSMutableArray array];
            tempArray = [Profile instance].arrExpandPhotos[indexPath.row];
            cellCover.imageSubCover1.image = tempArray[0];
            cellCover.imageSubCover2.image = tempArray[1];
            cellCover.imageSubCover3.image = tempArray[2];
            cellCover.imageSubCover4.image = tempArray[3];
            coverMergeImage = [self onFrontCoverImageMerge:cellCover];
            [cellCover.btnFrontCover  setTitle:[Profile instance].coverTitle forState:UIControlStateNormal];
            return cellCover;
        }else{
            return nil;
        }
        
    }else {
        PhotoCustomCell * cell =(PhotoCustomCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCustomCell" forIndexPath:indexPath];
        cell.imagePhotoCustom.image = [Profile instance].arrExpandPhotos[indexPath.row + 2];
        cell.lblSelectedImageTitle.text = [NSString stringWithFormat:@"%d",(int)indexPath.row];
        return cell;
    }
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 0) {
        if (indexPath.row == 0) {
            [self.photoCustomCollectionView reloadData];
            return;
        }
        else if (indexPath.row == 1)
        {
            [self.photoCustomCollectionView reloadData];
            PhotoBookCoverViewController *photoBookViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoBookCoverViewController"];
            [self presentViewController:photoBookViewController animated:YES completion:nil];
        }
    }
    else
    {
     
        PhotoEditController *photoEditViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoEditController"];
        photoEditViewController.selectedIndex = indexPath.row;
        photoEditViewController.canvas_height = self.view.frame.size.width *0.7;
        photoEditViewController.canvas_width  = self.view.frame.size.width - 50;
        [self presentViewController:photoEditViewController animated:YES completion:nil];
    }

}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
#pragma mark - UICollectionViewFlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
        NSLog(@"%d  %d",(int)collectionView.frame.size.width/2 - 5, (int)collectionView.frame.size.width/2 - 10);
        CGFloat width = 0;
        CGFloat height = 0;
        int product_width  = [selectedProduct.width intValue];
        int product_height = [selectedProduct.height intValue];
        double ratio=1.0;
        ratio =(product_height*1.0) /(product_width*1.0);
        height = (collectionView.frame.size.width/2 - 5) *ratio;
        NSLog(@"%d ",(int)height);
        return CGSizeMake(collectionView.frame.size.width/2 - 5, height);
    
    
//    }
    
}

#pragma mark - LXReorderableCollectionViewDataSource methods

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
    if (collectionView.tag == 1) {
        
        UIImage *tempImage = [Profile instance].arrExpandPhotos[fromIndexPath.item + 2];
        [[Profile instance].arrExpandPhotos removeObjectAtIndex:fromIndexPath.item + 2];
        [[Profile instance].arrExpandPhotos insertObject:tempImage atIndex:toIndexPath.item + 2];
        NSLog(@"FromIndex = %d || ToIndex = %d",(int)fromIndexPath.item,(int)toIndexPath.item);
         UIImage *tempImage1 = [Profile instance].arrayCoverImages[fromIndexPath.item ];
        [[Profile instance].arrayCoverImages removeObjectAtIndex:fromIndexPath.item];
        [[Profile instance].arrayCoverImages insertObject:tempImage1 atIndex:toIndexPath.item ];
    }
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 1) {
        return YES;
    }
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath {
    if (collectionView.tag == 1) {
        return YES;
    }
    return NO;
}

#pragma mark - LXReorderableCollectionViewDelegateFlowLayout methods

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 1) {
        NSLog(@"will begin drag");
    }
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did begin drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
        if (collectionView.tag == 1) {
    NSLog(@"will end drag");
        }
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 1) {
        NSLog(@"did end drag");
        [self onUpdateFrontCoverImage];
        [self.photoCoverCollectionView reloadData];
        [self.photoCustomCollectionView reloadData];
    }

}

#pragma mark- UpdateFrontCover
- (void)onUpdateFrontCoverImage{
    if ([Profile instance].arrExpandPhotos[2]) {
        [[Profile instance].arrFrontCoverPhotos insertObject:[Profile instance].arrExpandPhotos[2] atIndex:0];
    }else{
        [[Profile instance].arrFrontCoverPhotos insertObject:imageFrontCover atIndex:0];
    }
    if ([Profile instance].arrExpandPhotos[3]) {
        [[Profile instance].arrFrontCoverPhotos insertObject:[Profile instance].arrExpandPhotos[3] atIndex:1];
    }else{
        [[Profile instance].arrFrontCoverPhotos insertObject:imageFrontCover atIndex:1];
    }
    if ([Profile instance].arrExpandPhotos[4]) {
        [[Profile instance].arrFrontCoverPhotos insertObject:[Profile instance].arrExpandPhotos[4] atIndex:2];
    }else{
        [[Profile instance].arrFrontCoverPhotos insertObject:imageFrontCover atIndex:2];
    }
    if ([Profile instance].arrExpandPhotos[5]) {
        [[Profile instance].arrFrontCoverPhotos insertObject:[Profile instance].arrExpandPhotos[5] atIndex:3];
    }else{
        [[Profile instance].arrFrontCoverPhotos insertObject:imageFrontCover atIndex:3];
    }
    [self.photoCoverCollectionView reloadData];
    [self.photoCustomCollectionView reloadData];
//    BOOL suc = [self mergedImageOnMainImage:[UIImage imageNamed:@"facebook.png"] WithImageArray:[Profile instance].arrFrontCoverPhotos AndImagePointArray:nil];
    
//    if (suc == YES) {
//        NSLog(@"Images Successfully Mearged & Saved to Album");
//    }
//    else {
//        NSLog(@"Images not Mearged & not Saved to Album");
//    }
}

#pragma mark- ImageMerge
- (BOOL) mergedImageOnMainImage:(UIImage *)mainImg WithImageArray:(NSArray *)imgArray AndImagePointArray:(NSArray *)imgPointArray
{
    
    UIGraphicsBeginImageContext(mainImg.size);
    
    [mainImg drawInRect:CGRectMake(0, 0, mainImg.size.width, mainImg.size.height)];
    int i = 0;
    for (UIImage *img in imgArray) {
        [img drawInRect:CGRectMake([[imgPointArray objectAtIndex:i] floatValue],
                                   [[imgPointArray objectAtIndex:i+1] floatValue],
                                   img.size.width,
                                   img.size.height)];
        
        i+=2;
    }
    
    CGImageRef NewMergeImg = CGImageCreateWithImageInRect(UIGraphicsGetImageFromCurrentImageContext().CGImage,
                                                          CGRectMake(0, 0, mainImg.size.width, mainImg.size.height));
    
    UIGraphicsEndImageContext();
    
    
    if (NewMergeImg == nil) {
        return NO;
    }
    else {
        UIImageWriteToSavedPhotosAlbum([UIImage imageWithCGImage:NewMergeImg], self, nil, nil);
        imgMerge = [UIImage imageWithCGImage:NewMergeImg];
        return YES;
    }
}

#pragma mark-  onBack
- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- onPreview
- (IBAction)onPreView:(id)sender {
    PhotoPreviewViewController *previewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoPreviewViewController"];
    previewController.preViewImageArray = [NSMutableArray arrayWithArray:[self onMergeComplete]];
    [self presentViewController:previewController animated:YES completion:nil];
}



#pragma DoubleImageMerge
- (NSArray *)onMergeComplete{
    int mergeImageCount  = 0;
    NSMutableArray *tmpMergeArray = [NSMutableArray array];
    NSMutableArray *tmpExpandMergeArray = [NSMutableArray array];
    if (([Profile instance].arrayCoverImages.count % 2) == 0) {
        mergeImageCount =(int)[Profile instance].arrayCoverImages.count/2;
        for (int mergeIndex = 0; mergeIndex < mergeImageCount; mergeIndex ++) {
            NSLog(@"MergeIndex = %d",mergeIndex);
            [tmpMergeArray addObject:[self onCoverImageMergeWithRatio:[Profile instance].arrayCoverImages[mergeIndex * 2] withImage2:[Profile instance].arrayCoverImages[mergeIndex *2 + 1]]];
        }
        [tmpMergeArray addObject:[self onCoverImageMergeWithRatio:[UIImage imageNamed:@"black"] withImage2:[UIImage imageNamed:@"white"]]];
        if ([Profile instance].editedCoverImage) {
            [tmpMergeArray addObject:[self onCoverImageMergeWithRatio:[UIImage imageNamed:@"white"] withImage2:[Profile instance].editedCoverImage]];
        }else{
            [tmpMergeArray addObject:[self onCoverImageMergeWithRatio:[UIImage imageNamed:@"white"] withImage2:coverMergeImage]];
        }
        return tmpMergeArray;
    }else{
        tmpMergeArray = [NSMutableArray arrayWithArray:[Profile instance].arrayCoverImages];
        [tmpMergeArray insertObject:imageFrontCover atIndex:[Profile instance].arrayCoverImages.count];
        mergeImageCount =(int)[Profile instance].arrayCoverImages.count/2 + 1;
        for (int mergeIndex = 0; mergeIndex < mergeImageCount; mergeIndex ++) {
            NSLog(@"MergeIndex = %d",mergeIndex);
            [tmpExpandMergeArray insertObject:[self onCoverImageMergeWithRatio:tmpMergeArray[mergeIndex * 2] withImage2:tmpMergeArray[mergeIndex * 2 + 1]] atIndex:mergeIndex];
        }
        [tmpExpandMergeArray insertObject:[self onCoverImageMergeWithRatio:[UIImage imageNamed:@"black"] withImage2:[UIImage imageNamed:@"white"]] atIndex:mergeImageCount];
        if ([Profile instance].editedCoverImage) {
            [tmpExpandMergeArray addObject:[self onCoverImageMergeWithRatio:[UIImage imageNamed:@"white"] withImage2:[Profile instance].editedCoverImage]];
        }else{
            [tmpExpandMergeArray addObject:[self onCoverImageMergeWithRatio:[UIImage imageNamed:@"white"] withImage2:coverMergeImage]];
        }
        return tmpExpandMergeArray;
    }
    
}
#pragma mark ImageMerge
-(UIImage *)onCoverImageMerge:(UIImage *)image1 withImage2:(UIImage *)image2{
    CGFloat total_width = 500;
    CGFloat total_heigt = 250;
    CGFloat diff  = 20;
    CGFloat x = 0;
    CGFloat y = 0;
    UIView *mergeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 500, 250)];
    UIImageView *imgView1, *imgView2;
    imgView1 = [[UIImageView alloc] initWithImage:image1];
    imgView2 = [[UIImageView alloc] initWithImage:image2];
    imgView1.frame = CGRectMake(x + diff, y + diff, total_width/2 - diff * 2, total_heigt - diff * 2);
    imgView2.frame = CGRectMake(total_width/2 + diff, y + diff, total_width/2 - diff * 2, total_heigt - diff * 2);
    [mergeView addSubview:imgView1];
    [mergeView addSubview:imgView2];
    UIGraphicsBeginImageContext(mergeView.bounds.size);
    [mergeView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImage;
}

#pragma mark ImageMerge
-(UIImage *)onCoverImageMergeWithRatio:(UIImage *)image1 withImage2:(UIImage *)image2{
    CGFloat total_width = 500;
    CGFloat total_heigt = 250;
    CGFloat imageWith1 = 0;
    CGFloat imageHeight1 = 0;
    CGFloat imageWith2 = 0;
    CGFloat imageHeight2 = 0;
    CGFloat diff  = 15;
    
    int product_width  = [selectedProduct.width intValue];
    int product_height = [selectedProduct.height intValue];
    double ratio=1.0;
    if(product_height >product_width)
    {
        ratio =(product_width*1.0) /(product_height*1.0);
        
        imageWith1  = (230 * ratio);
        imageWith2  = (230 * ratio);
        imageHeight1 = 230;
        imageHeight2 = 230;
        diff = (230 - imageWith1)/2;
        
        
    }else{
        ratio =(product_height*1.0) /(product_width*1.0);
        imageWith1  = (230);
        imageWith2  = (230);
        imageHeight1 = 230 *ratio;
        imageHeight2 = 230 *ratio;
        diff = diff * ratio;
    }
    CGFloat x1 = total_width/2 - diff - imageWith1;
    CGFloat y1 = (total_heigt - imageHeight1)/2;
    
    CGFloat x2 = total_width/2 + diff;
    CGFloat y2 = (total_heigt - imageHeight2)/2;
    
    UIView *mergeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 500, 250)];
    UIImageView *imgView1, *imgView2;
    imgView1 = [[UIImageView alloc] initWithImage:image1];
    imgView2 = [[UIImageView alloc] initWithImage:image2];
    imgView1.frame = CGRectMake(x1, y1, imageWith1, imageHeight1);
    imgView2.frame = CGRectMake(x2, y2, imageWith2, imageHeight2);
    [mergeView addSubview:imgView1];
    [mergeView addSubview:imgView2];
    UIGraphicsBeginImageContext(mergeView.bounds.size);
    [mergeView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImage;
}

#pragma mark FrontCoverCellImageMerge
-(UIImage *)onFrontCoverImageMerge:(PhotoCoverCell *)cell
{
//    UIView *frontCoverMergeImage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//    UIImageView *imageView1,*imageView2,*imageView3,*imageView4,*imageTitle,*imageViewBackGround,*imageViewCoverGround;
//    imageViewBackGround  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//    imageViewCoverGround = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 180,180)];
//    imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(17, 17, 80, 85)];
//    imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(17+ 80 + 6, 17, 80, 50)];
//    imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(17, 17+85+5, 80, 50)];
//    imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(17+ 80 +6 , 17+50+5, 80, 85)];
//    imageTitle = [[UIImageView alloc] initWithFrame:CGRectMake(17, 17+85+5+50+5, 166, 20)];
//    
//    imageView1.image = cell.imageSubCover1.image;
//    imageView2.image = cell.imageSubCover2.image;
//    imageView3.image = cell.imageSubCover3.image;
//    imageView4.image = cell.imageSubCover4.image;
////    imageTitle = cell.imageTitle;
//    imageViewBackGround.image = [UIImage imageNamed:@"black"];
//    imageViewCoverGround.image = [UIImage imageNamed:@"white"];
//    
//    [frontCoverMergeImage addSubview:imageViewBackGround];
//    [frontCoverMergeImage addSubview:imageViewCoverGround];
//    [frontCoverMergeImage addSubview:imageView1];
//    [frontCoverMergeImage addSubview:imageView2];
//    [frontCoverMergeImage addSubview:imageView3];
//    [frontCoverMergeImage addSubview:imageView4];
////    [frontCoverMergeImage addSubview:imageTitle];
    
    UIGraphicsBeginImageContext(cell.bounds.size);
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  finalImage;
}
@end

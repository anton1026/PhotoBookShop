//
//  PhotoGalleryView.m
//  PhotoBookShop
//
//  Created by My Star on 5/1/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import "PhotoGalleryView.h"
#import "PhotoGallaryCell.h"

@implementation PhotoGalleryView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super initWithCoder:aDecoder])){
        [self addSubview:
         [[[NSBundle mainBundle] loadNibNamed:@"PhotoGalleryView"
                                        owner:self
                                      options:nil] objectAtIndex:0]];
    }
    return self;
}
#pragma mark - Collection View Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  5;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        PhotoGallaryCell * cellGallary =(PhotoGallaryCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoGallaryCell" forIndexPath:indexPath];
        PHImageManager *manager1 =[PHImageManager defaultManager];
        if(cellGallary.tag){
            [manager1 cancelImageRequest:(PHImageRequestID)cellGallary.tag];
        }
//        if (arrAssets.count > 0) {
//            PHAsset *assetGallary =arrAssets[indexPath.row];
//            cellGallary.tag = [manager1 requestImageForAsset:assetGallary targetSize:CGSizeMake(cellWidth,cellHeight) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//                cellGallary.imagePhotoGallary.image = result;
//                
//            }];
//        }else{
            cellGallary.imagePhotoGallary.image = [UIImage imageNamed:@"icon_plus"];
//        }

        return cellGallary;

    
    
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//        profile.selectedPhotoIndex =(int) indexPath.row;
//        int i = profile.selectedPhotoIndex;
//        PHAsset *asset = profile.arrAssets[i];
//        PHImageRequestOptions *options =[[PHImageRequestOptions alloc] init];
//        options.synchronous = YES;
//        options.resizeMode =PHImageRequestOptionsResizeModeFast;
//        options.deliveryMode =PHImageRequestOptionsDeliveryModeHighQualityFormat;
//        //                [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(600 ,600) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//        //                    selectedImage =result;
//        //            self.cropView.image = selectedImage;
//        //        }];
//        
//        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData * imageData, NSString *dataUTI, UIImageOrientation UIImageOrientationUp, NSDictionary *info) {
//            
//            profile.selectedPhotoImage = [UIImage imageWithData:imageData];
//            profile.editedPhotoImage =profile.selectedPhotoImage;
//            [self dismissViewControllerAnimated:YES completion:nil];
//            //        PhotoEditController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoEditController"];
//            //        [self presentViewController:viewController animated:YES completion:nil];
//            
//        }];
    
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
#pragma mark - UICollectionViewFlowLayoutDelegate
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(cellWidth, cellHeight);
//}

@end

//
//  SelectPhotoController.h
//  PhotoBookShop
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Photos;
@interface SelectPhotoController : UIViewController<UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIView *photoGalleryView;
@property (weak, nonatomic) IBOutlet UICollectionView *photoGalleryCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentPhotoNumeber;
@property (weak, nonatomic) IBOutlet UILabel *lblRequirePhotos;
@property (weak, nonatomic) IBOutlet UIButton *btnAddPhotos;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (strong, nonatomic) PHAssetCollection *assetCollection;
@property (strong, nonatomic) PHFetchResult *assetsFetchResult;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *galleryViewConstraintHeight;
@property (weak, nonatomic) IBOutlet UITableView *tblAlbumList;
@end

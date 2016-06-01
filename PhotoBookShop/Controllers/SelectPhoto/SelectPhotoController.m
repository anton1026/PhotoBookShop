//
//  SelectPhotoController.m
//  PhotoBookShop
//  Copyright © 2016 Peter. All rights reserved.
//

#import "SelectPhotoController.h"
#import "HMSegmentedControl.h"
#import "PhotoCell.h"
#import "PhotoGallaryCell.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "WebClient.h"
#import "PhotoEditController.h"
#import "PhotoCustomViewController.h"
#import "ProductCategory.h"
#import <UIKit/UIView.h>

@import PhotosUI;

@interface SelectPhotoController ()
{
    int selected_format;
    NSMutableArray *arrPhotos;
    Products *selectedProduct;
    NSMutableArray *arrThumbs;
    NSMutableArray *arrAssets;
    NSMutableArray *arrayGallaryAssests;
    ALAssetsLibrary *assetLibrary;
    Profile *profile;
    MBProgressHUD *HUD;
    float cellWidth;
    float cellHeight;
    float imageRealWidth;
    float imageRealHeight;
    BOOL  isDisplayedGallery;
}
@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property CGRect previousPreheatRect;
@property (nonatomic, strong) NSArray *sectionFetchResults;
@end

@implementation SelectPhotoController

static NSString * const AllPhotosReuseIdentifier = @"AllPhotosCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    profile =[Profile instance];
    cellWidth = ([[UIScreen mainScreen] bounds].size.width-50)/4;
    cellHeight =cellWidth;
    selectedProduct = profile.selectedProduct;
    [self setImageSize];
    arrayGallaryAssests = [[NSMutableArray alloc] init];
    if (([WebClient sharedInstance].webClientRequestIndex) == CANVAS ) {
        [self.photoGalleryView setHidden:YES];
        self.galleryViewConstraintHeight.constant =0.0f;
        NSLog(@"%d",(int)self.photoCollectionView.tag);
    }else if(([WebClient sharedInstance].webClientRequestIndex ) == PHOTOBOOKS)
    {
        [self.photoGalleryView setHidden:NO];
        self.galleryViewConstraintHeight.constant =160.0f;
        self.photoGalleryCollectionView.allowsMultipleSelection = YES;
        self.photoGalleryCollectionView.allowsSelection = YES;
        NSLog(@"%d",(int)self.photoGalleryCollectionView.tag);
        
    }
    self.lblRequirePhotos.text = @"20~72 reqired";
    self.lblCurrentPhotoNumeber.text = @"photos selected";
    
    NSArray *arrTitle = @[@"iPhone", @"SocialPrints",@"FaceBook",@"Instagram"];
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:arrTitle];
    segmentedControl.frame =CGRectMake(0, 64, self.view.frame.size.width, 40);
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.selectionIndicatorHeight = 4.0f;
    segmentedControl.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:70.0/255.0 blue:30.0/255.0 alpha:1];
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:13.0],UITextAttributeFont,[UIColor whiteColor], NSForegroundColorAttributeName,
                          nil];
    segmentedControl.titleTextAttributes =size; //@{NSForegroundColorAttributeName : [UIColor whiteColor]};
    segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:0.5 green:0.8 blue:1 alpha:1];
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.shouldAnimateUserSelection = NO;
    UIFont *font =[UIFont fontWithName:@"Helvetica-Regular" size:14.0];
    [self.view addSubview:segmentedControl];

    // Check library permissions
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self fetchAlbums];
            }
        }];
    } else if (status == PHAuthorizationStatusAuthorized) {
        [self fetchAlbums];
    }
    
    isDisplayedGallery = NO;
    [self.tblAlbumList registerClass:[UITableViewCell class] forCellReuseIdentifier:AllPhotosReuseIdentifier];
    [self.tblAlbumList reloadData];
    
    self.imageManager = [[PHCachingImageManager alloc] init];
    [self resetCachedAssets];
    [self.photoGalleryCollectionView reloadData];
    // [self loadAssets];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateCachedAssets];
}

#pragma mark - Asset Caching
- (void) resetCachedAssets
{
    [self.imageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}
-(void) updateCachedAssets
{
    
}
-(void) setImageSize
{
    int product_width  = [selectedProduct.width intValue];
    int product_height = [selectedProduct.height intValue];
    double ratio=1.0;
    if(product_height >product_width)    {
        ratio =(product_width*1.0) /(product_height*1.0);
        imageRealHeight =100;
        imageRealWidth = (int) (imageRealHeight *ratio);
    }else{
        ratio =(product_height*1.0) /(product_width*1.0);
        imageRealWidth =100;
        imageRealHeight=(int) (imageRealWidth *ratio);
    }
}
- (IBAction)onBack:(id)sender {
    if(selected_format ==0){
        if(self.tblAlbumList.isHidden){
            self.tblAlbumList.hidden =NO;
            isDisplayedGallery =NO;
        }
        else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void) getPhotosFromLibrary
{
    [self performLoadAssets];
    //[self loadAssets];
    //   ShowAlert(@"Permission Denied", @"Please allow the application to access your photo in settings panel of your device");
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    selected_format =(int)segmentedControl.selectedSegmentIndex;
    if(selected_format ==0){
        if(!isDisplayedGallery)
          self.tblAlbumList.hidden =NO;
    }
    else
        self.tblAlbumList.hidden =YES;
}
#pragma mark - Collection View Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([WebClient sharedInstance].webClientRequestIndex == CANVAS) {
        return self.assetsFetchResult.count;
    }else{
        if (collectionView.tag == 0)
        {
            return self.assetsFetchResult.count;
        }else{
            return  arrayGallaryAssests.count;
        }
        
    }
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([WebClient sharedInstance].webClientRequestIndex == CANVAS) {
        
        PhotoCell * cell_canvas =(PhotoCell*)[self.photoCollectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
        [cell_canvas.imageSelectedShow setHidden:YES];
        
        PHAsset *asset = self.assetsFetchResult[indexPath.row];
        // Request an image for the asset from the PHCachingImageManager.
        [self.imageManager requestImageForAsset:asset
                           targetSize:CGSizeMake(cellWidth,cellHeight)
                           contentMode:PHImageContentModeAspectFill
                           options:nil
                           resultHandler:^(UIImage *result, NSDictionary *info) {
              // Set the cell's thumbnail image if it's still showing the  asset.
              cell_canvas.photoImage.image = result;
          }];
         return cell_canvas;
    }else {
        if (collectionView.tag == 0) {
            PhotoCell * cell =(PhotoCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
            if(cell.tag){
                [self.imageManager cancelImageRequest:(PHImageRequestID)cell.tag];
            }
            PHAsset *asset = self.assetsFetchResult[indexPath.row];
            cell.tag = [self.imageManager requestImageForAsset:asset targetSize:CGSizeMake(imageRealWidth,imageRealHeight) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                cell.photoImage.image = result;
            }];
            if ([arrayGallaryAssests indexOfObject:[NSNumber numberWithInteger:indexPath.row]] == NSNotFound) {
                [cell.imageSelectedShow setHidden:YES];
            }
            else{
                [cell.imageSelectedShow setHidden:NO];
            }
            return cell;
        }else{
            PhotoGallaryCell * cellGallary =(PhotoGallaryCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoGallaryCell" forIndexPath:indexPath];
            if(cellGallary.tag){
                [self.imageManager cancelImageRequest:(PHImageRequestID)cellGallary.tag];
            }
            if (arrayGallaryAssests.count > 0) {
                NSInteger diffNum = arrayGallaryAssests.count - indexPath.row - 1;
                PHAsset *assetGallery =self.assetsFetchResult[[arrayGallaryAssests[diffNum] integerValue]];
                cellGallary.tag = [self.imageManager requestImageForAsset:assetGallery targetSize:CGSizeMake(cellGallary.imagePhotoGallary.frame.size.width,cellGallary.imagePhotoGallary.frame.size.height) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    cellGallary.imagePhotoGallary.image = result;
                    
                }];
                return cellGallary;
            }else{
                return 0;
            }
            
        }
        
    }
    
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([WebClient sharedInstance].webClientRequestIndex == CANVAS) {
        profile.selectedPhotoIndex =(int) indexPath.row;
        PHAsset *asset = self.assetsFetchResult[indexPath.row];
        PHImageRequestOptions *options =[[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        options.resizeMode =PHImageRequestOptionsResizeModeFast;
        options.deliveryMode =PHImageRequestOptionsDeliveryModeHighQualityFormat;
        [self.imageManager requestImageDataForAsset:asset options:options resultHandler:^(NSData * imageData, NSString *dataUTI, UIImageOrientation UIImageOrientationUp, NSDictionary *info) {
            profile.selectedPhotoImage = [UIImage imageWithData:imageData];
            profile.editedPhotoImage =profile.selectedPhotoImage;
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }else{
        if (collectionView.tag == 0) {
            PhotoCell *selectedCell =(PhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
            
            if ([arrayGallaryAssests indexOfObject:[NSNumber numberWithInteger:indexPath.row]] == NSNotFound) {
                [selectedCell.imageSelectedShow setHidden: NO];
                [arrayGallaryAssests addObject:[NSNumber numberWithInteger:indexPath.row]];
            } else {
                [selectedCell.imageSelectedShow setHidden: YES];
                [arrayGallaryAssests removeObject:[NSNumber numberWithInteger:indexPath.row]];
            }
            [self.photoGalleryCollectionView reloadData];
            [self.btnAddPhotos setTitle:[NSString stringWithFormat:@"Add %d Photos",(int)arrayGallaryAssests.count] forState:UIControlStateNormal];
            self.lblCurrentPhotoNumeber.text = [NSString stringWithFormat:@"%d photos selected",(int)arrayGallaryAssests.count];
        }else{
            
        }
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
#pragma mark - UICollectionViewFlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 0) {
        return CGSizeMake(cellWidth, cellHeight);
    }else{
        return CGSizeMake(80.0f, 80.0f);
    }
    
}
#pragma mark - Selected Photo Size Calculator

#pragma mark - Add Selected Photos

- (IBAction)onAddPhotos:(id)sender {
    PhotoCustomViewController *photoCustomViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoCustomViewController"];
    if (arrayGallaryAssests.count < 4) {
        [[[UIAlertView alloc] initWithTitle:@"Warning!" message:@"Please choose images more than 4." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }
    PHImageRequestOptions *options =[[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.resizeMode =PHImageRequestOptionsResizeModeFast;
    options.deliveryMode =PHImageRequestOptionsDeliveryModeHighQualityFormat;
    [Profile instance].arrayCoverAssets = [NSMutableArray array];
    [Profile instance].arrayCoverImages = [NSMutableArray array];
    [Profile instance].arrFrontCoverPhotos = [NSMutableArray array];
    NSLog(@"Count = %d",(int)arrayGallaryAssests.count);
    for (int index = (int)arrayGallaryAssests.count - 1; index >= 0; index --) {
        int i =[arrayGallaryAssests[index] intValue];
        PHAsset *asset = self.assetsFetchResult[i];
        [[Profile instance].arrayCoverAssets addObject:asset];
    }
    [self presentViewController:photoCustomViewController animated:YES completion:nil];
}

#pragma mark - Load Assets
- (void)loadAssets {
    if (NSClassFromString(@"PHAsset")) {
        // Check library permissions
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    [self performLoadAssets];
                }
            }];
        } else if (status == PHAuthorizationStatusAuthorized) {
            [self performLoadAssets];
        }
    } else {
        // Assets library
        [self performLoadAssets];
        
    }
}

#pragma mark - fetchAlbums
-(void) fetchAlbums
{
    PHFetchResult *smartAlbumsUserLib = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:  PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    PHFetchResult *smartAlbumsFav = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:  PHAssetCollectionSubtypeSmartAlbumFavorites   options:nil];
    PHFetchResult *smartAlbumsRecentAdd = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:  PHAssetCollectionSubtypeSmartAlbumRecentlyAdded options:nil];
    PHFetchResult *momentAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeMoment  subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
//    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    // Store the PHFetchResult objects and localized titles for each section.
    self.sectionFetchResults = @[smartAlbumsUserLib,smartAlbumsFav,smartAlbumsRecentAdd,momentAlbums];//,topLevelUserCollections];
}

#pragma mark - photoResize

- (void)performLoadAssets {
    
    // Initialise
    arrAssets = [[NSMutableArray alloc] init];
    arrPhotos =[[NSMutableArray alloc] init];
    arrThumbs =[[NSMutableArray alloc] init];
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.dimBackground = YES;
    [HUD show:true];
    // Load
    if(profile.arrAssets !=nil){
        //arrPhotos =profile.arrPhotos;
        arrAssets =profile.arrAssets;
        [self.photoCollectionView reloadData];
        [HUD removeFromSuperview];
        HUD = nil;
        
    }else{
        
        PHCachingImageManager *cachingImageManager = [[PHCachingImageManager alloc] init];
        PHFetchOptions *options =[[PHFetchOptions alloc] init];
        //options.predicate =[NSPredicate predicateWithFormat:@"favorite ==YES"];
        options.sortDescriptors =@[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        PHFetchResult *result =[PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
        [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj isKindOfClass:[PHAsset class]]){
                [arrAssets addObject:obj];
                profile.arrPhotos =arrPhotos;
                profile.arrAssets =arrAssets;
                [self.photoCollectionView reloadData];
                [HUD removeFromSuperview];
                HUD = nil;
            }
        }];
        [cachingImageManager startCachingImagesForAssets:arrAssets targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:nil];
        
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    return self.sectionFetchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:AllPhotosReuseIdentifier forIndexPath:indexPath];
    PHFetchResult *fetchResult = self.sectionFetchResults[indexPath.row];
    PHCollection *collection = fetchResult[0];
    if ([collection isKindOfClass:[PHAssetCollection class]]) {
        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
        fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@(%ld)",@"Moment",fetchResult.count];
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@(%ld)",collection.localizedTitle,fetchResult.count];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PHFetchResult *fetchResult = self.sectionFetchResults[indexPath.row];
    PHCollection *collection = fetchResult[0];
    if ([collection isKindOfClass:[PHAssetCollection class]]) {
        // Configure the AAPLAssetGridViewController with the asset collection.
        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        self.assetCollection =assetCollection;
        self.assetsFetchResult =assetsFetchResult;
        self.tblAlbumList.hidden =YES;
        [self resetCachedAssets];
        isDisplayedGallery = YES;
        if (([WebClient sharedInstance].webClientRequestIndex) == CANVAS ) {
               [self.photoCollectionView reloadData];
        }else if(([WebClient sharedInstance].webClientRequestIndex) == PHOTOBOOKS ) {
               [self.photoCollectionView reloadData];
               [self.photoGalleryCollectionView reloadData];
        }
    }
}

@end

//
//  AlbumsListViewController.m
//  PhotoBookShop
//  Copyright © 2016 Peter. All rights reserved.
//

#import "AlbumsListViewController.h"
#import "SelectPhotoController.h"

@interface AlbumsListViewController ()<PHPhotoLibraryChangeObserver>
@property (nonatomic, strong) NSArray *sectionFetchResults;
@property (nonatomic, strong) NSArray *sectionLocalizedTitles;
@end

@implementation AlbumsListViewController

static NSString * const AllPhotosReuseIdentifier = @"AllPhotosCell";
static NSString * const CollectionCellReuseIdentifier = @"CollectionCell";

static NSString * const AllPhotosSegue = @"showAllPhotos";
static NSString * const CollectionSegue = @"showCollection";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Create a PHFetchResult object for each section in the table view.
//    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
//    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
//    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    
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

    
    [self.tblAlbumList registerClass:[UITableViewCell class] forCellReuseIdentifier:AllPhotosReuseIdentifier];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    [self.tblAlbumList reloadData];

}
-(void) viewDidDisappear:(BOOL)animated
{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void) fetchAlbums
{
    PHFetchResult *smartAlbumsUserLib = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:  PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    PHFetchResult *smartAlbumsFav = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:  PHAssetCollectionSubtypeSmartAlbumFavorites   options:nil];
    PHFetchResult *smartAlbumsRecentAdd = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:  PHAssetCollectionSubtypeSmartAlbumRecentlyAdded options:nil];
    PHFetchResult *momentAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeMoment  subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    // Store the PHFetchResult objects and localized titles for each section.
    self.sectionFetchResults = @[smartAlbumsUserLib,smartAlbumsFav,smartAlbumsRecentAdd,momentAlbums,topLevelUserCollections];
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
        SelectPhotoController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectPhotoController"];
        viewController.assetCollection =assetCollection;
        viewController.assetsFetchResult =assetsFetchResult;
        [self presentViewController:viewController animated:YES completion:nil];
    }
    
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return self.sectionLocalizedTitles[section];
//}

-(BOOL)hasPhoto:(PHFetchResult *)fetchResult {
    BOOL flag = NO;
    PHCollection *collection = fetchResult[0];
    if ([collection isKindOfClass:[PHAssetCollection class]]) {
        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
        fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    }
    if (fetchResult && fetchResult.count > 0) {
        flag = YES;
    }
    
    return flag;
}
#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    /*
     Change notifications may be made on a background queue. Re-dispatch to the
     main queue before acting on the change as we'll be updating the UI.
     */
//    dispatch_async(dispatch_get_main_queue(), ^{
//        // Loop through the section fetch results, replacing any fetch results that have been updated.
//        NSMutableArray *updatedSectionFetchResults = [self.sectionFetchResults mutableCopy];
//        __block BOOL reloadRequired = NO;
//        
//        [self.sectionFetchResults enumerateObjectsUsingBlock:^(PHFetchResult *collectionsFetchResult, NSUInteger index, BOOL *stop) {
//            PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:collectionsFetchResult];
//            
//            if (changeDetails != nil) {
//                [updatedSectionFetchResults replaceObjectAtIndex:index withObject:[changeDetails fetchResultAfterChanges]];
//                reloadRequired = YES;
//            }
//        }];
//        
//        if (reloadRequired) {
//            self.sectionFetchResults = updatedSectionFetchResults;
//            [self.tblAlbumList reloadData];
//        }
//        
//    });
}
@end

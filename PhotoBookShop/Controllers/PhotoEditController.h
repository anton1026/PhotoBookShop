//
//  PhotoEditController.h
//  PhotoBookShop
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BABCropperView.h"

@interface PhotoEditController : UIViewController<UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *filterCollectionView;
@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet BABCropperView *cropView;
@property UIImage *selectedPhotoImage;
@property NSInteger selectedIndex;
@property double canvas_width;
@property double canvas_height;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cropview_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cropview_width;
@property (nonatomic, strong) UIImage *selectedImage;
@end

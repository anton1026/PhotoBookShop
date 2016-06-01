//
//  PhotoCustomViewController.h
//  PhotoBookShop
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCustomViewController : UIViewController
@property NSMutableArray *arrayImageAssets;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCustomCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCoverCollectionView;



@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverCollectionHeight;



@end

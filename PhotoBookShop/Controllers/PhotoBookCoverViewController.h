//
//  PhotoBookCoverViewController.h
//  PhotoBookShop
//  Copyright © 2016 Peter. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface PhotoBookCoverViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *photoCoverCollectionview;
@property (weak, nonatomic) IBOutlet UIImageView *coverSubImage2;
@property (weak, nonatomic) IBOutlet UIImageView *coverSubImage4;
@property (weak, nonatomic) IBOutlet UIImageView *coverSubImage1;
@property (weak, nonatomic) IBOutlet UIButton *coverTitle;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;

@property (weak, nonatomic) IBOutlet UIView *photoCoverSuperView;
@property (weak, nonatomic) IBOutlet UIImageView *coverSubImage3;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnFrontCover;
@property UIImageView *touchImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *superViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *superViewHeight;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *titleView;

@end

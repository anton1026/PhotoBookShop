//
//  PhotoCoverCell.h
//  PhotoBookShop
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCoverCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageCoverBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imageSubCover2;
@property (weak, nonatomic) IBOutlet UIImageView *imageSubCover3;
@property (weak, nonatomic) IBOutlet UIImageView *imageSubCover4;
@property (weak, nonatomic) IBOutlet UIImageView *imageSubCover1;
@property (weak, nonatomic) IBOutlet UIImageView *imageTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnFrontCover;

@end

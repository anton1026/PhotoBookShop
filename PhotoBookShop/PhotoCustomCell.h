//
//  PhotoCustomCell.h
//  PhotoBookShop
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCustomCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imagePhotoCustom;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectedImageTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellHeight;
@property (weak, nonatomic) IBOutlet UIView *superView;
@end

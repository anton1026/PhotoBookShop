//
//  FilterCell.h
//  PhotoBookShop
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *filterImage;
@property (weak, nonatomic) IBOutlet UILabel *lblFilterName;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property BOOL isFiltered;
@end

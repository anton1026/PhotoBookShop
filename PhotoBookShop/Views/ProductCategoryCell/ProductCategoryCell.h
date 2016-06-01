//
//  ProductCategoryCell.h
//  PhotoBookShop
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCategoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *lblProductName;
@property (weak, nonatomic) IBOutlet UIView *labelbackview;
@property (weak, nonatomic) IBOutlet UILabel *lblFromPrice;
@end

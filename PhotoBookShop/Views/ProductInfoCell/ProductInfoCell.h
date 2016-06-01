//
//  ProductInfoCell.h
//  PhotoBookShop
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblSize;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblSellPrice;
@property (weak, nonatomic) IBOutlet UIImageView *imageCheckStatus;

@end

//
//  ProductInfoViewController.h
//  PhotoBookShop
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductInfoViewController : UIViewController
@property (nonatomic, retain) NSArray *arrFormat;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIImageView *imageProduct;
@property (weak, nonatomic) IBOutlet UITableView *tblProductInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;


@property (nonatomic, retain) NSString *category_ID;
@end

//
//  ProductCategoryCell.m
//  PhotoBookShop
//  Copyright © 2016 Peter. All rights reserved.
//

#import "ProductCategoryCell.h"

@implementation ProductCategoryCell

- (void)awakeFromNib {
    self.lblProductName.layer.cornerRadius =5;
    self.lblProductName.layer.borderColor =[UIColor whiteColor].CGColor;
    self.lblProductName.layer.borderWidth =3;
    [[self.lblProductName layer] setMasksToBounds:YES];
    self.labelbackview.layer.cornerRadius =3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

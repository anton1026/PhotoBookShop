//
//  CanvasEditController.h
//  PhotoBookShop
//  Copyright © 2016 Peter. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "LBorderView.h"
@interface CanvasEditController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblProductSize;

@property (weak, nonatomic) IBOutlet UILabel *lblOldPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblCurPrice;
@property (weak, nonatomic) IBOutlet UISwitch *switchWrapMode;
@property (weak, nonatomic) IBOutlet UIImageView *canvasImage;
@property (weak, nonatomic) IBOutlet UIImageView *canvasWrapImage;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectPhotos;
@property (weak, nonatomic) IBOutlet UIButton *btnEditPhotos;
@property (weak, nonatomic) IBOutlet LBorderView *dashBorderView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *canvas_width;
@property (weak, nonatomic) IBOutlet UIView *canvas_view;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *canvas_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CanvasImageConstrianWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CanvasImageConstrainHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dashViewWidthConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dashViewHeightConstrain;
@end

//
//  CanvasPreviewController.h
//  PhotoBookShop
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
//#import "../../libs/ShaderPlayground/Demos/DemoBase.h"

@interface CanvasPreviewController : UIViewController<GLKViewDelegate>

@property (weak, nonatomic) IBOutlet GLKView *preView;

@property (weak, nonatomic) IBOutlet UIView *quantityView;

@property (weak, nonatomic) IBOutlet UIView *countView;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtProjectName;
@property (weak, nonatomic) IBOutlet UILabel *lblSize;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnAddtoCart;

@property double canvas_width;
@property double canvas_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *preview_Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *preview_Height;

//- (void)setDemo:(DemoBase*) demoToShow;
@end

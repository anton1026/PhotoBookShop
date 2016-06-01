//
//  CanvasViewController.h
//  PhotoBookShop
//  Copyright © 2016 Peter. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface CanvasViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnCanvasSize;
@property (weak, nonatomic) IBOutlet UIImageView *imageCanvasView;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblDescriptionTitle;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property NSInteger viewIndex;
@end

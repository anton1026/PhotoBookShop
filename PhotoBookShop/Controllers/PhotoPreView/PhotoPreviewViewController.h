//
//  PhotoPreviewViewController.h
//  PhotoBookShop
//  Copyright © 2016 Peter. All rights reserved.
//
#import <UIKit/UIKit.h>
@class FlipView;
@class AnimationDelegate;
@interface PhotoPreviewViewController : UIViewController<UIGestureRecognizerDelegate>
{
    AnimationDelegate *animationDelegate2;
    
    BOOL runWhenRestart;
}
@property (weak, nonatomic) IBOutlet UIView *countView;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnMinus;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalNumber;
@property (weak, nonatomic) IBOutlet UIButton *btnPlus;
@property (weak, nonatomic) IBOutlet UITextField *txtProjectName;
@property (weak, nonatomic) IBOutlet UILabel *lblSize;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnAddCart;
@property (weak, nonatomic) IBOutlet UILabel *lblPageNumber;
@property (nonatomic, retain) FlipView *flipView2;
@property (nonatomic, retain) UIPanGestureRecognizer *panRecognizer;
@property (weak, nonatomic) IBOutlet UIView *quantityView;
@property UIView *panRegion;
@property (weak, nonatomic) IBOutlet UIView *panRegionView;

@property NSMutableArray *preViewImageArray;
- (void)panned:(UIPanGestureRecognizer *)recognizer;
- (void)toggleRepeat:(UIButton *)sender;
- (void)toggleReverse:(UIButton *)sender;
- (void)toggleShadow:(UIButton *)sender;
@end

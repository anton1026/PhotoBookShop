//
//  ViewController.h
//  PhotoBookShop
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tblProductCategory;
@property (strong, nonatomic) NSMutableDictionary *cachedImages;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@end


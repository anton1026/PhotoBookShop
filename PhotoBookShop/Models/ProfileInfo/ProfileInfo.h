//
//  Profile.h
//  Youth_Hostel
//  Copyright (c) 2015 Anton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ProductCategory.h"
@interface Profile : NSObject

+(Profile *) instance;
@property int selectedPhotoIndex;
@property (nonatomic, retain) UIImage* selectedPhotoImage;
@property (nonatomic, retain) UIImage* editedPhotoImage;
@property (nonatomic, retain) UIImage* cropPhotoImage;
@property (nonatomic, retain) NSString* category_id;
@property (nonatomic, retain) UIImage* product_image;
@property (nonatomic, strong) NSMutableArray *arrAssets;
@property (nonatomic, strong) NSMutableArray *arrPhotos;
@property (nonatomic, strong) Products *selectedProduct;
@property (nonatomic, strong) NSString *currencySymbol;
@property (nonatomic, strong) NSMutableArray *arrExpandPhotos;
@property (nonatomic, strong) NSMutableArray *arrFrontCoverPhotos;
@property (nonatomic, strong) NSMutableArray *arrayCoverImages;
@property (nonatomic, strong) NSMutableArray *arrayCoverAssets;
@property NSString *coverTitle;
@property BOOL warpMode;
@property UIImage *editedCoverImage;
@property BOOL isCoverEdited;
@property CGFloat border_delta;
@end

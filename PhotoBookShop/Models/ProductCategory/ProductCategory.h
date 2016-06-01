//
//  ProductCategory.h
//  PhotoBookShop
//  Copyright © 2016 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductCategory : NSObject

@property(nonatomic,retain) NSString* bannerurl;
@property(nonatomic,retain) NSString* category_name;
@property(nonatomic,retain) NSString* category_id;
@property(nonatomic,retain) NSString* fromprice;
@property(nonatomic,retain) NSString* currency;
@property(nonatomic,retain) NSString* symbol;

@end

@interface CategoryFormats : NSObject

@property(nonatomic,retain) NSString* format_id;
@property(nonatomic,retain) NSString* format_name;

@end


@interface ProductCategorySpecification : NSObject

@property(nonatomic,retain) NSString* bannerurl;
@property(nonatomic,retain) NSString* category_name;
@property(nonatomic,retain) NSString* fromprice;
@property(nonatomic,retain) NSString* canvas_description;
@property(nonatomic,retain) NSString* title;
@property(nonatomic,retain) NSString* currency;
@property(nonatomic,retain) NSString* symbol;
@property(nonatomic,retain) NSArray* formats;

@end

@interface Products :NSObject

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *price;
@property (nonatomic,retain) NSString *productcode;
@property (nonatomic,retain) NSString *rrp;
@property (nonatomic,retain) NSString *sellprice;
@property (nonatomic,retain) NSNumber *width;
@property (nonatomic,retain) NSNumber *height;

@end


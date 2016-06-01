//
//  WebServiceRequest.h
//  Copyright © 2015 Anton. All rights reserved.
//
#define CANVAS       0
#define PHOTOBOOKS   1
#define PRINTS       2
#define CARDS        3
#define MAGNETS      4
#define CATTING_BODY 5
#define CALENDERS    6
#define PHOTO_GIFTS  7
#define ACRYLIC      8
#define KIDS         9
#define PHOTOCOVER   10

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "NSObject+JTObjectMapping.h"
#import "ProfileInfo.h"
#import "ProductCategory.h"

#define kBaseURL @"http://www.photobookshop.com.au/api"
#define SiteURL @"http://www.photobookshop.com.au"

#define ShowAlert(myTitle, myMessage) [[[UIAlertView alloc] initWithTitle:NSLocalizedString(myTitle, nil) message:NSLocalizedString(myMessage, nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show]

typedef void (^ProductCategoriesRequestCompleteBlock) (NSArray *arrProductCategories);
typedef void (^ProductCategoriesSpecificationRequestCompleteBlock) (ProductCategorySpecification *aProductCategory);
typedef void (^ProductInfoRequestCompleteBlock) (NSArray *arrProductInfo,NSString *symbol);

@interface WebClient : NSObject

+(WebClient*) sharedInstance;
@property NSInteger webClientRequestIndex;
/************************ Member Profile *************************/
#pragma mark Member Part Server function
-(void) requestProductCategories:(ProductCategoriesRequestCompleteBlock) callback;
-(void) requestProductCategorySpecifics:(NSString*) category_id withcallback:(ProductCategoriesSpecificationRequestCompleteBlock) callback;
-(void) requestProductInfoWithID:(NSString*) format_id withCategoryID:(NSString*)category_id withcallback:(ProductInfoRequestCompleteBlock) callback;
@end

//
//  WebServiceRequest.m
//  Copyright © 2015 Anton. All rights reserved.
//
#import "WebClient.h"
@interface WebClient ()
{
    Profile            *profileInfo;
    ASIHTTPRequest *request;
    ASIFormDataRequest *requestPost;

}
@end
@implementation WebClient
static WebClient *instance =nil;
+(WebClient*) sharedInstance
{
    if(instance ==nil)
    {
        instance =[[WebClient alloc] init];
    }
    return  instance;
}
-(id)init
{
    self =[super init];
    self.webClientRequestIndex = 0;
    if(self)
    {
        profileInfo =[Profile instance];
    }
    return self;
}
#pragma mark Main Request
-(void) requestProductCategories:(ProductCategoriesRequestCompleteBlock) callback
{
    NSString *strAPICall = @"productcategories";
    NSString *strURL = [NSString stringWithFormat:@"%@/%@",kBaseURL,strAPICall];
    NSURL *url = [NSURL URLWithString:strURL];
    request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        NSError *jsonParsingError = nil;
        NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&jsonParsingError];
        NSLog(@"json======%@",json);
        NSArray *jsonArray = [json objectForKey:@"productcategories"];
        NSArray *arrCategory =[ProductCategory objectFromJSONObject:jsonArray mapping:nil];
        callback(arrCategory);
    }];
    [request setFailedBlock:^{
        callback(nil);
    }];
    [request startAsynchronous];
}
-(void) requestProductCategorySpecifics:(NSString*) category_id withcallback:(ProductCategoriesSpecificationRequestCompleteBlock) callback
{
    NSString *strAPICall = @"productcategories";
    NSString *strURL = [NSString stringWithFormat:@"%@/%@",kBaseURL,strAPICall];
    NSURL *url = [NSURL URLWithString:strURL];
    requestPost = [ASIFormDataRequest requestWithURL:url];
    [requestPost setRequestMethod:@"POST"];
    [requestPost addPostValue:category_id forKey:@"id"];
    [requestPost setCompletionBlock:^{
        NSError *jsonParsingError = nil;
        NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:[requestPost responseData] options:kNilOptions error:&jsonParsingError];
        NSLog(@"json======%@",json);
        NSDictionary *jsonData = [json objectForKey:@"productcategories"];
        
        NSDictionary *mappingFormat = [NSDictionary dictionaryWithObjectsAndKeys:@"format_id",@"id",
                                         @"format_name",@"name"
                                        ,nil];
        NSDictionary *mapping=[NSDictionary dictionaryWithObjectsAndKeys:
                               @"canvas_description",@"description",
                               [CategoryFormats mappingWithKey:@"formats" mapping:mappingFormat],@"formats", nil];
        
        ProductCategorySpecification *aCategory =[ProductCategorySpecification objectFromJSONObject:jsonData mapping:mapping];
        
        callback(aCategory);
    }];
    [requestPost setFailedBlock:^{
        callback(nil);
    }];
    [requestPost startAsynchronous];
}
-(void) requestProductInfoWithID:(NSString*) format_id withCategoryID:(NSString*)category_id withcallback:(ProductInfoRequestCompleteBlock) callback
{
    NSString *strAPICall = @"productcategories";
    NSString *strURL = [NSString stringWithFormat:@"%@/%@",kBaseURL,strAPICall];
    NSURL *url = [NSURL URLWithString:strURL];
    requestPost = [ASIFormDataRequest requestWithURL:url];
    [requestPost setRequestMethod:@"POST"];
    [requestPost addPostValue:category_id forKey:@"id"];
    [requestPost addPostValue:format_id forKey:@"format"];
    [requestPost setCompletionBlock:^{
        NSError *jsonParsingError = nil;
        NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:[requestPost responseData] options:kNilOptions error:&jsonParsingError];
        NSLog(@"json======%@",json);
        NSDictionary *jsonData = [json objectForKey:@"productcategories"];
        NSArray *jsonArray =[jsonData objectForKey:@"products"];
        NSString *symbol =[jsonData valueForKey:@"symbol"];
        NSArray *arrProduct =[Products objectFromJSONObject:jsonArray mapping:nil];

//        NSDictionary *mappingFormat = [NSDictionary dictionaryWithObjectsAndKeys:@"format_id",@"id",
//                                       @"format_name",@"name"
//                                       ,nil];
//        NSDictionary *mapping=[NSDictionary dictionaryWithObjectsAndKeys:
//                               @"canvas_description",@"description",
//                               [CategoryFormats mappingWithKey:@"formats" mapping:mappingFormat],@"formats", nil];
//        
//        ProductCategorySpecification *aCategory =[ProductCategorySpecification objectFromJSONObject:jsonData mapping:mapping];
        
        callback(arrProduct,symbol);
    }];
    [requestPost setFailedBlock:^{
        callback(nil,nil);
    }];
    [requestPost startAsynchronous];

}

@end

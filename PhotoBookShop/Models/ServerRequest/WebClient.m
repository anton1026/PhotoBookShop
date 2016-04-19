//
//  WebServiceRequest.m
//  Youth_Hostel
//
//  Created by Anton Borev on 11/21/15.
//  Copyright © 2015 Anton. All rights reserved.
//
#import "WebClient.h"

@interface WebClient ()
{
    Profile            *profileInfo;
    ASIFormDataRequest *request;
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
    if(self)
    {
        profileInfo =[Profile instance];
    }
    return self;
}
#pragma mark Main Request
-(void) requestLocationAddressWithCallbackBlock:(LocationAddressRequestCompleteBlock) callback
{
    NSString *strAPICall = [NSString stringWithFormat:@"location_address?%@",APIKEY];
    NSString *strURL = [NSString stringWithFormat:@"%@/%@",kBaseURL,strAPICall];
    NSURL *url = [NSURL URLWithString:strURL];
    request = [ASIFormDataRequest requestWithURL:url];
    
    NSNumber *nlat =[NSNumber numberWithDouble:profileInfo.currentLocation.coordinate.latitude];
    NSNumber *nlng =[NSNumber numberWithDouble:profileInfo.currentLocation.coordinate.longitude];
    NSNumber *nNum =[NSNumber numberWithInt:1];
    [request addPostValue:nlat forKey:@"lat"];
    [request addPostValue:nlng forKey:@"lng"];
    [request addPostValue:nNum forKey:@"num"];
    [request setRequestMethod:@"POST"];
    [request setCompletionBlock:^{
        NSError *jsonParsingError = nil;
        NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&jsonParsingError];
        NSLog(@"json====%@",json);
        NSArray *jsonArray = [[json objectForKey:@"RESPONSE"]objectForKey:@"address"];
        NSDictionary *mapping =[NSDictionary dictionaryWithObjectsAndKeys:
                                [multimedia mappingWithKey:@"multimedia" mapping:nil], @"multimedia",
                                nil];
        NSArray *arrCityAddress =[CityAddress objectFromJSONObject:jsonArray mapping:mapping];
        CityAddress *cityAddress =arrCityAddress[0];
        callback(cityAddress);
    }];
    [request setFailedBlock:^{
        callback(nil);
    }];
    [request startAsynchronous];
}

#pragma mark Member Profile Request
-(void) requestMemberProfileWithCallbackBlock:(MemberProfileRequestCompleteBlock) callback
{
    NSString *strAPICall = [NSString stringWithFormat:@"member_profile?%@",APIKEY];
    NSString *strURL = [NSString stringWithFormat:@"%@/%@",kBaseURL,strAPICall];
    NSURL *url = [NSURL URLWithString:strURL];
    request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addPostValue:profileInfo.member_id forKey:@"member_number"];
    [request addPostValue:profileInfo.session_id forKey:@"session_id"];
    [request setCompletionBlock:^{
        NSError *jsonParsingError = nil;
        NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&jsonParsingError];
        NSDictionary *jsonResponse = [[json objectForKey:@"RESPONSE"]objectForKey:@"profile"];
        NSDictionary *mapping =[NSDictionary dictionaryWithObjectsAndKeys:@"ProfileID",@"id",nil];
        PersonalInfo *thePerson =[PersonalInfo objectFromJSONObject:jsonResponse mapping:mapping];
//        profileInfo.curcurrency.currency_id =thePerson.currency_id;
//        profileInfo.curcurrency.currency_code=thePerson.currency_code;
        callback(thePerson);
    }];
    [request setFailedBlock:^{
        callback(nil);
    }];
    [request startAsynchronous];
}
-(void) requestCountryWithCallbackBlock:(CountryRequestCompleteBlock) callback
{
    NSString *strAPICall = [NSString stringWithFormat:@"select?%@",APIKEY];
    NSString *strURL = [NSString stringWithFormat:@"%@/%@",kBaseURL,strAPICall];
    NSURL *url = [NSURL URLWithString:strURL];
    request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        NSError *jsonParsingError = nil;
        NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&jsonParsingError];
        NSArray *jsonArray = [[json objectForKey:@"RESPONSE"]objectForKey:@"COUNTRY_LIST"];
        NSMutableArray *arrCountry =[[NSMutableArray alloc]init];
        for (int i=0; i<[jsonArray count]; i++)
        {
            NSString *str=[[jsonArray objectAtIndex:i]valueForKey:@"value"];
            NSString *newStr = [FormatHelper stringByRemovingQuotationMarks:str];
            [arrCountry addObject:newStr];
        }
        callback(arrCountry);
    }];
    [request setFailedBlock:^{
        callback(nil);
    }];
    [request startAsynchronous];
}
-(void) requestCurrencyWithCallbackBlock:(CurrencyRequestCompleteBlock) callback
{
    NSString *strAPICallCurrency = [NSString stringWithFormat:@"currency?%@",APIKEY];
    NSString *strURLCurrency = [NSString stringWithFormat:@"%@/%@",kBaseURL,strAPICallCurrency];
    NSURL *urlCurrency = [NSURL URLWithString:strURLCurrency];
    request = [ASIFormDataRequest requestWithURL:urlCurrency];
    [request setCompletionBlock:^{
        NSError *jsonParsingError = nil;
        NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&jsonParsingError];
        NSLog(@"json====%@",json);
        NSArray *jsonArray = [[json objectForKey:@"RESPONSE"]objectForKey:@"currency"];
        NSArray *arrCurrency =[CurrencyModel objectFromJSONObject:jsonArray mapping:nil];
        callback(arrCurrency);
    }];
    [request setFailedBlock:^{
        callback(nil);
    }];
    [request startAsynchronous];
}
-(void) requestLanguageWithCallbackBlock:(LanguageRequestCompleteBlock) callback
{
    NSString *strAPICallCurrency = [NSString stringWithFormat:@"language?%@",APIKEY];
    NSString *strURLCurrency = [NSString stringWithFormat:@"%@/%@",kBaseURL,strAPICallCurrency];
    NSURL *urlCurrency = [NSURL URLWithString:strURLCurrency];
    request = [ASIFormDataRequest requestWithURL:urlCurrency];
    [request setCompletionBlock:^{
        NSError *jsonParsingError = nil;
        NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&jsonParsingError];
        NSLog(@"json====%@",json);
        NSArray *jsonArray = [[json objectForKey:@"RESPONSE"]objectForKey:@"language"];
        NSDictionary *mapping =[NSDictionary dictionaryWithObjectsAndKeys:@"description_language",@"description",nil];
        NSArray *arrLanguage =[LanguageModel objectFromJSONObject:jsonArray mapping:mapping];
        callback(arrLanguage);
        
    }];
    [request setFailedBlock:^{
        callback(nil);
    }];
    [request startAsynchronous];
}
-(void) requestCancelAccountWithCallbackBlock:(AccountCancelRequestCompleteBlock) callback
{
    NSString *strAPICall = [NSString stringWithFormat:@"member_cancel_account?%@",APIKEY];
    NSString *strURL = [NSString stringWithFormat:@"%@/%@",kBaseURL,strAPICall];
    NSURL *url = [NSURL URLWithString:strURL];
    request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addPostValue:profileInfo.member_id forKey:@"member_number"];
    [request addPostValue:profileInfo.session_id forKey:@"session_id"];
    [request setCompletionBlock:^{
        NSError *jsonParsingError = nil;
        NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&jsonParsingError];
        NSLog(@"json =======%@",json);
        if ([[[json valueForKey:@"RESPONSE"]valueForKey:@"success"]valueForKey:@"success_status"])
        {
            NSHTTPCookie *cookie;
            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (cookie in [storage cookies])
            {
                [storage deleteCookie:cookie];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
            profileInfo.isSigned =NO;
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            [defaults setBool:profileInfo.isSigned forKey:@"isSigned"];
            [defaults setObject:@""  forKey:@"member_id"];
            [defaults setObject:@""  forKey:@"session_id"];
            [defaults synchronize];
            callback(YES);
        }else{
            callback(NO);
        }
    }];
    [request setFailedBlock:^{
        callback(NO);
    }];
    [request startAsynchronous];
}
-(void) requestProfileUpdateWithLanguege:(LanguageModel*) theLanguage WithCurrency:(CurrencyModel*)theCurrency Gender_ID:(NSString*) gender_ID
                               FirstName:(NSString*) firstname LastName:(NSString*) lastname CountryName:(NSString*)countryName PhoneNumber :(NSString*) phoneNumber WithCompleteBlock:(MemberProfileUpdateRequestCompleteBlock)callback
{
    
    NSString *strAPICallUpdateProfile = [NSString stringWithFormat:@"member_update_profile?%@",APIKEY];
    NSString *strURLUpdateProfile = [NSString stringWithFormat:@"%@/%@",kBaseURL,strAPICallUpdateProfile];
    NSURL *urlUpdateProfile = [NSURL URLWithString:strURLUpdateProfile];
    request = [ASIFormDataRequest requestWithURL:urlUpdateProfile];
    [request setRequestMethod:@"POST"];
    [request addPostValue:profileInfo.member_id forKey:@"member_number"];
    [request addPostValue:profileInfo.session_id forKey:@"session_id"];
    [request addPostValue:@"TRUE" forKey:@"mail_subscription"];
//    [request addPostValue:theLanguage.language_id forKey:@"favorite_lang_id"];
    [request addPostValue:@"1" forKey:@"favorite_lang_id"];
    [request addPostValue:gender_ID forKey:@"gender_id"];
    [request addPostValue:firstname forKey:@"first_name"];
    [request addPostValue:lastname forKey:@"last_name"];
    [request addPostValue:countryName forKey:@"home_country"];
    [request addPostValue:phoneNumber forKey:@"phone_number"];
    [request addPostValue:theCurrency.currency_id forKey:@"favorite_currency"];
    [request addPostValue:@"www.domain.com" forKey:@"website"];
    [request setCompletionBlock:^{
        NSError *jsonParsingError = nil;
        NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&jsonParsingError];
        
        int status =(int)[[[[json valueForKey:@"RESPONSE"]valueForKey:@"success"]valueForKey:@"success_status"]integerValue];
        if(status ==1){
            callback(YES);
        }else{
            NSArray *jsonArray = [[[json objectForKey:@"RESPONSE"]objectForKey:@"error"] objectForKey:@"error_message"];
            NSString* msgStr =(NSString*)jsonArray[0];
            callback(NO);
        }
    }];
    [request setFailedBlock:^{
        callback(NO);
    }];
    [request startAsynchronous];
}

-(void) requestUpdateMemberPassword:(NSString*) oldPassword NewPassword:(NSString*) newPassword
                  WithCompleteBlock:(UpdateMemberPassword)callback;
{
    NSString *strAPICallUpdateProfile = [NSString stringWithFormat:@"member_update_password?%@",APIKEY];
    NSString *strURLUpdateProfile = [NSString stringWithFormat:@"%@/%@",kBaseURL,strAPICallUpdateProfile];
    NSURL *urlUpdateProfile = [NSURL URLWithString:strURLUpdateProfile];
    request = [ASIFormDataRequest requestWithURL:urlUpdateProfile];
    [request setRequestMethod:@"POST"];
    [request addPostValue:profileInfo.member_id forKey:@"member_number"];
    [request addPostValue:profileInfo.session_id forKey:@"session_id"];
    [request addPostValue:oldPassword forKey:@"old_password"];
    [request addPostValue:newPassword forKey:@"new_password"];
    [request setCompletionBlock:^{
        callback(YES);
    }];
    [request setFailedBlock:^{
        callback(NO);
    }];
    [request startAsynchronous];
}
-(void) requestContentWithCategory:(NSString*) category WithCompleteBlock:(ContentCompleteBlock)callback;
{
    NSString *strAPICallUpdateProfile = [NSString stringWithFormat:@"content?%@",APIKEY];
    NSString *strURLUpdateProfile = [NSString stringWithFormat:@"%@/%@",kBaseURL,strAPICallUpdateProfile];
    NSURL *urlUpdateProfile = [NSURL URLWithString:strURLUpdateProfile];
    request = [ASIFormDataRequest requestWithURL:urlUpdateProfile];
    [request setRequestMethod:@"POST"];
    [request addPostValue:category forKey:@"category"];
    [request setCompletionBlock:^{
        NSError *jsonParsingError = nil;
        NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&jsonParsingError];
        NSDictionary *jsonResponse = [[json objectForKey:@"RESPONSE"]objectForKey:@"content"];
        NSString* content =[NSString stringWithFormat:@"%@",jsonResponse];
        //        NSString * content =[[json objectForKey:@"RESPONSE"] stringForKey:@"content"];
        NSLog(@"json====%@",json);
        callback(content);
    }];
    [request setFailedBlock:^{
        callback(nil);
    }];
    [request startAsynchronous];
    
}
#pragma mark Memeber Favorite
-(void) requestMemberFavorite:(MemberFavoriteCompleteBlock) callback
{
    NSString *strAPICall = [NSString stringWithFormat:@"member_favorite?%@",APIKEY];
    NSString *strURL = [NSString stringWithFormat:@"%@/%@",kBaseURL,strAPICall];
    NSURL *url = [NSURL URLWithString:strURL];
    request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addPostValue:profileInfo.member_id forKey:@"member_number"];
    [request addPostValue:profileInfo.session_id forKey:@"session_id"];
    [request setCompletionBlock:^{
        NSError *jsonParsingError = nil;
        NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&jsonParsingError];
        NSArray *jsonArray = [[json objectForKey:@"RESPONSE"]objectForKey:@"favorites"];
        NSDictionary *mapping =[NSDictionary dictionaryWithObjectsAndKeys:@"favorite_id",@"id",nil];
        NSArray* arrFavourite =[FavoriteModel objectFromJSONObject:jsonArray mapping:mapping];
        callback(arrFavourite);
    }];
    [request setFailedBlock:^{
        callback(nil);
    }];
    [request startAsynchronous];
}
-(void) requestAddFavoriteWithPropertyNumber:(NSString*) propertyNumber WithCompleteBlock:(AddFavoriteCompleteBlock) callback
{
    NSString *strAPICall = [NSString stringWithFormat:@"property_to_favorite?%@",APIKEY];
    NSString *strURL = [NSString stringWithFormat:@"%@/%@",kBaseURL,strAPICall];
    NSURL *url = [NSURL URLWithString:strURL];
    request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:[FormatHelper getNumberFromString:profileInfo.member_id] forKey:@"member_number"];
    [request addPostValue:propertyNumber forKey:@"property_number"];
    [request addPostValue:[FormatHelper getStringFromDate:profileInfo.departureDate] forKey:@"departure_date"];
    [request addPostValue:[FormatHelper getStringFromDate:profileInfo.arrivalDate] forKey:@"arrival_date"];
//    [request addPostValue:@"Good Property" forKey:@"notes"];
    [request addPostValue:profileInfo.session_id forKey:@"session_id"];
    [request setRequestMethod:@"POST"];
    [request setCompletionBlock:^{
        NSError *jsonParsingError = nil;
        NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&jsonParsingError];
        
        int status =(int)[[[[json valueForKey:@"RESPONSE"]valueForKey:@"success"]valueForKey:@"success_status"]integerValue];
        if(status ==1){
            callback(@"OK");
        }else{
            NSArray *jsonArray = [[[json objectForKey:@"RESPONSE"]objectForKey:@"error"] objectForKey:@"error_message"];
            NSString* msgStr =(NSString*)jsonArray[0];
            callback(msgStr);
        }
    }];
    [request setFailedBlock:^{
        callback(nil);
    }];
    [request startAsynchronous];
    
}
-(void) requestRemoveFavoriteWithID:(NSString*) favoriteID WithCompleteBlock:(RemoveFavoriteCompleteBlock) callback
{
    NSString *strAPICall = [NSString stringWithFormat:@"remove_favorite_property?%@",APIKEY];
    NSString *strURL = [NSString stringWithFormat:@"%@/%@",kBaseURL,strAPICall];
    NSURL *url = [NSURL URLWithString:strURL];
    request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addPostValue:profileInfo.member_id forKey:@"member_number"];
    [request addPostValue:favoriteID forKey:@"favorite_id"];
    [request addPostValue:profileInfo.session_id forKey:@"session_id"];
    [request setCompletionBlock:^{
        NSError *jsonParsingError = nil;
        NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&jsonParsingError];
        
        int status =(int)[[[[json valueForKey:@"RESPONSE"]valueForKey:@"success"]valueForKey:@"success_status"]integerValue];
        if(status ==1){
            callback(@"OK");
        }else{
            NSArray *jsonArray = [[[json objectForKey:@"RESPONSE"]objectForKey:@"error"] objectForKey:@"error_message"];
            NSString* msgStr =(NSString*)jsonArray[0];
            callback(msgStr);
        }
    }];
    [request setFailedBlock:^{
        callback(nil);
    }];
    
    [request startAsynchronous];
}

#pragma mark Property Part
-(void) requestPropertyReviewWithPropertyNumber:(NSString*) propertyNumber WithCompleteBlock:(PropertyReviewRequestCompleteBlock) callback
{
    
    NSString *strAPICall = [NSString stringWithFormat:@"property_reviews?%@",APIKEY];
    NSString *strURL = [NSString stringWithFormat:@"%@/%@",kBaseURL,strAPICall];
    NSURL *url = [NSURL URLWithString:strURL];
    request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addPostValue:propertyNumber forKey:@"property_number"];
    [request setCompletionBlock:^{
        NSError *jsonParsingError = nil;
        NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&jsonParsingError];
        NSArray *jsonArray = [[json objectForKey:@"RESPONSE"]objectForKey:@"user_reviews"];
        NSArray *arrPropertyReview =[user_reviews objectFromJSONObject:jsonArray mapping:nil];
        callback(arrPropertyReview);
    }];
    [request setFailedBlock:^{
        callback(nil);
    }];
    [request startAsynchronous];
}
-(void) requestPropertyWithPorpertyNumber: (NSString*) propertyNumber WithCompleteBlock:(PropertyRequestCompleteBlock) callback
{
    NSString *strAPICall = [NSString stringWithFormat:@"property?%@",APIKEY];
    NSString *strURL = [NSString stringWithFormat:@"%@/%@",kBaseURL,strAPICall];
    NSURL *url = [NSURL URLWithString:strURL];
    request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addPostValue:propertyNumber forKey:@"property_number"];
    [request setCompletionBlock:^{
        NSError *jsonParsingError = nil;
        NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&jsonParsingError];
        NSDictionary *jsonDictionary = [json objectForKey:@"RESPONSE"];
        NSDictionary *mapping1 =[NSDictionary dictionaryWithObjectsAndKeys:[ADDRESS mappingWithKey:@"ADDRESS" mapping:nil], @"ADDRESS",
                                 [CURRENCY mappingWithKey:@"CURRENCY" mapping:nil], @"CURRENCY",
                                 [CANCELLATIONINFORMATION mappingWithKey:@"CANCELLATIONINFORMATION" mapping:nil], @"CANCELLATIONINFORMATION",
                                 [CHECKINTIMES mappingWithKey:@"CHECKINTIMES" mapping:nil], @"CHECKINTIMES",
                                 [GPS mappingWithKey:@"GPS" mapping:nil], @"GPS",nil];
        NSDictionary *mapping =[NSDictionary dictionaryWithObjectsAndKeys:
                                [DetailedProperty mappingWithKey:@"property_details" mapping:mapping1], @"property_details",
                                [property_services mappingWithKey:@"property_services" mapping:mapping1], @"property_services",
                                [property_districts mappingWithKey:@"property_districts" mapping:mapping1], @"property_districts",
                                [property_ratings mappingWithKey:@"property_ratings" mapping:nil], @"property_ratings",nil];
        GeneralProperty *generalProperty =[GeneralProperty objectFromJSONObject:jsonDictionary mapping:mapping];
        callback(generalProperty);
    }];
    [request setFailedBlock:^{
        callback(nil);
    }];
    
    [request startAsynchronous];
}
-(void) requestPropertyImagesWithPropertyNumber: (NSString*) proeprtyNumber WithCompleteBlock:(PropertyRequestImagesCompleteBlock) callback
{
    NSString *strAPICall = [NSString stringWithFormat:@"property_images?%@",APIKEY];
    NSString *strURL = [NSString stringWithFormat:@"%@/%@",kBaseURL,strAPICall];
    NSURL *url = [NSURL URLWithString:strURL];
    request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addPostValue:proeprtyNumber forKey:@"property_number"];
    [request setCompletionBlock:^{
        NSError *jsonParsingError = nil;
        NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&jsonParsingError];
        NSDictionary *jsonDictionary = [json objectForKey:@"RESPONSE"];
        NSArray *imagesArray =[property_images objectFromJSONObject:jsonDictionary mapping:nil];
        callback(imagesArray);
    }];
    [request setFailedBlock:^{
        callback(nil);
    }];
    [request startAsynchronous];
}
-(void) requestPropertyListWithCity:(PropertyListCompleteBlock)callback
{
    NSString *strAPICall = [NSString stringWithFormat:@"property_search2?%@&currency=%@",APIKEY,profileInfo.curcurrency.currency_code];
    NSString *strURL = [NSString stringWithFormat:@"%@/%@",kBaseURL,strAPICall];
    NSURL *url = [NSURL URLWithString:strURL];
    NSDateFormatter *df =[[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *startDate =[df stringFromDate:profileInfo.arrivalDate];
    request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addPostValue:profileInfo.city forKey:@"city"];
    [request addPostValue:profileInfo.country forKey:@"country"];
    [request addPostValue:startDate forKey:@"datestart"];
    [request addPostValue:profileInfo.numofNights forKey:@"numnights"];
    [requset setTimeOutSeconds:30];
    [request setCompletionBlock:^{
        NSError *jsonParsingError = nil;
        NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&jsonParsingError];
        NSArray *jsonArray = [[json objectForKey:@"RESPONSE"]objectForKey:@"property_list"];
        NSDictionary *mapping =[NSDictionary dictionaryWithObjectsAndKeys:
                                [Geo mappingWithKey:@"Geo" mapping:nil], @"Geo",
                                [Ratings mappingWithKey:@"ratings" mapping:nil], @"ratings",
                                [extras mappingWithKey:@"extras" mapping:nil], @"extras",nil];
        NSArray *arrProperty =[PropertyModel objectFromJSONObject:jsonArray mapping:mapping];

        NSArray *amenitiesArray =[[json objectForKey:@"RESPONSE"]objectForKey:@"most_popular_amenities"];
        NSArray *arrAmenity =[PopularAmenity objectFromJSONObject:amenitiesArray mapping:nil];
        int statuseCode =[request responseStatusCode];
        if(statuseCode ==200){
            callback(arrProperty,arrAmenity,0);
        }else{
            callback(arrProperty,arrAmenity,1);
        }

    }];
    [request setFailedBlock:^{
        callback(nil,nil,1);
    }];
    [request startAsynchronous];
}
-(void) requestPropertyListWithLocation:(PropertyListCompleteBlock)callback
{
    NSString *strAPICall = [NSString stringWithFormat:@"property_search2?%@&currency=%@",APIKEY,profileInfo.curcurrency.currency_code];
    NSString *strURL = [NSString stringWithFormat:@"%@/%@",kBaseURL,strAPICall];
    NSURL *url = [NSURL URLWithString:strURL];
    NSDateFormatter *df =[[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *curDate =[df stringFromDate:profileInfo.arrivalDate];
    NSNumber *nlat =[NSNumber numberWithDouble:profileInfo.currentLocation.coordinate.latitude];
    NSNumber *nlng =[NSNumber numberWithDouble:profileInfo.currentLocation.coordinate.longitude];

    request = [ASIFormDataRequest requestWithURL:url];
//    [request addPostValue:profileInfo.city forKey:@"city"];
//    [request addPostValue:profileInfo.country forKey:@"country"];
    [request addPostValue:curDate forKey:@"datestart"];
    [request addPostValue:profileInfo.numofNights forKey:@"numnights"];
    [request addPostValue:nlat forKey:@"lat"];
    [request addPostValue:nlng forKey:@"lng"];
    [request addPostValue:@"geocode" forKey:@"type"];
    [request setRequestMethod:@"POST"];
    [request setCompletionBlock:^{
        NSError *jsonParsingError = nil;
        NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&jsonParsingError];
        NSArray *jsonArray = [[json objectForKey:@"RESPONSE"]objectForKey:@"property_list"];
        NSDictionary *mapping =[NSDictionary dictionaryWithObjectsAndKeys:
                                [Geo mappingWithKey:@"Geo" mapping:nil], @"Geo",
                                [Ratings mappingWithKey:@"ratings" mapping:nil], @"ratings",
                                [extras mappingWithKey:@"extras" mapping:nil], @"extras",nil];
        NSArray *arrProperty =[PropertyModel objectFromJSONObject:jsonArray mapping:mapping];
        
        NSArray *amenitiesArray =[[json objectForKey:@"RESPONSE"]objectForKey:@"most_popular_amenities"];
        NSArray *arrAmenity =[PopularAmenity objectFromJSONObject:jsonArray mapping:nil];
        int statuseCode =[request responseStatusCode];
        if(statuseCode ==200){
            callback(arrProperty,arrAmenity,0);
        }else{
            callback(arrProperty,arrAmenity,1);
        }
    }];
    [request setFailedBlock:^{
        callback(nil,nil,1);
    }];
    [request startAsynchronous];

}
#pragma mark ContactUs
/************************ Contact Us **************************/
-(void) requestContactUsWithMessage:(NSString *)message WithSubject:(NSString*)subject WithName:(NSString*) name WithEmail:(NSString*)email WithCompleteBlock:(ContactUsReuestCompleteBlock)callback
{
    NSString *strAPICall = [NSString stringWithFormat:@"contact_us?%@",APIKEY];
    NSString *strURL = [NSString stringWithFormat:@"%@/%@",kBaseURL,strAPICall];
    NSURL *url = [NSURL URLWithString:strURL];
    
    request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:profileInfo.firstname forKey:@"first_name"];
    [request addPostValue:profileInfo.lastname forKey:@"last_name"];
    [request addPostValue:email forKey:@"email"];
    [request addPostValue:message forKey:@"message"];
    [request addPostValue:subject forKey:@"subject"];
//    [request addPostValue:profileInfo.ip_address forKey:@"ip"];
    [request addPostValue:profileInfo.member_id forKey:@"member_id"];

    [request setCompletionBlock:^{
        NSError *jsonParsingError = nil;
        NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&jsonParsingError];
        
        int status =(int)[[[json valueForKey:@"RESPONSE"]valueForKey:@"success"] integerValue];
        if(status ==1){
            callback(@"OK");
        }else{
            NSArray *jsonArray = [[[json objectForKey:@"RESPONSE"]objectForKey:@"error"] objectForKey:@"error_message"];
            NSString* msgStr =(NSString*)jsonArray[0];
            callback(msgStr);
        }
    }];
    [request setFailedBlock:^{
        callback(nil);
    }];
    
    [request startAsynchronous];
}
/*************************** Suggestion Request ***********************/
-(void) requestSuggestionWithTerm:(NSString *)term WithCallBack:(SuggestionRequestCompleteBlock)callback
{
    NSString *strAPICall = [NSString stringWithFormat:@"search_suggest?%@",APIKEY];
    NSString *strURL = [NSString stringWithFormat:@"%@/%@",kBaseURL,strAPICall];
    NSURL *url = [NSURL URLWithString:strURL];
    request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:term forKey:@"term"];
    [request addPostValue:@"" forKey:@"filter"];
    //[request addPostValue:@"all" forKey:@"filter"];
    [request setRequestMethod:@"POST"];
    [request setCompletionBlock:^{
        NSError *jsonParsingError = nil;
        NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&jsonParsingError];
        NSArray *jsonArray = [[json objectForKey:@"RESPONSE"]objectForKey:@"suggestions"];
       
        NSArray *arrSuggestion =[Suggestion objectFromJSONObject:jsonArray mapping:nil];
        callback(arrSuggestion);
    }];
    [request setFailedBlock:^{
        callback(nil);
    }];
    [request startAsynchronous];
}
/************************************************************************/
-(void) requestCheckAvailabilty:(AvailabiltyRequestCompleteBlock)callback
{
    NSString *strAPICall = [NSString stringWithFormat:@"property_availability?%@",APIKEY];
    NSString *strURL = [NSString stringWithFormat:@"%@/%@",kBaseURL,strAPICall];
    NSURL *url = [NSURL URLWithString:strURL];
    NSDateFormatter *df =[[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *startDate =[df stringFromDate:profileInfo.arrivalDate];
    request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addPostValue:profileInfo.propertyNumber forKey:@"property_number"];
    [request addPostValue:startDate forKey:@"date_start"];
    [request addPostValue:profileInfo.numofNights forKey:@"num_nights"];
    [request addPostValue:profileInfo.curcurrency.currency_code forKey:@"currency"];
    [request setCompletionBlock:^{
        NSError *jsonParsingError = nil;
        NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&jsonParsingError];
        NSArray *jsonArray = [[json objectForKey:@"RESPONSE"]objectForKey:@"rooms"];
        NSArray *arrRoom =[Property_Availability objectFromJSONObject:jsonArray mapping:nil];
        NSArray *arrCardType = [[json objectForKey:@"RESPONSE"]objectForKey:@"property_cards"];
        int statusCode = [request responseStatusCode];
        if(statusCode ==200){
           callback(arrRoom,arrCardType,0);
        }else{
           callback(arrRoom,arrCardType,1);
        }
        
    }];
    [request setFailedBlock:^{
        callback(nil,nil,1);
    }];
    [request startAsynchronous];
}


/***************************************************************************/
-(void) requestPropertyPrice:(PropertyPriceRequestCompleteBlock)callback
{
    NSString *strAPICall = [NSString stringWithFormat:@"property_pricing?%@",APIKEY];
    NSString *strURL = [NSString stringWithFormat:@"%@/%@",kBaseURL,strAPICall];
    NSURL *url = [NSURL URLWithString:strURL];
    NSDateFormatter *df =[[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *arrivalDate =[df stringFromDate:profileInfo.arrivalDate];
    request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addPostValue:profileInfo.propertyNumber forKey:@"property_number"];
    [request addPostValue:arrivalDate forKey:@"date_start"];
    [request addPostValue:profileInfo.numofNights forKey:@"num_nights"];
    [request addPostValue:profileInfo.booking_rooms forKey:@"room_selected"];
    [request addPostValue:profileInfo.booking_persons forKey:@"bed_selected"];
    [request addPostValue:profileInfo.curcurrency.currency_code forKey:@"currency"];
    [request addPostValue:@"true" forKey:@"charge_fee"];
    [request setCompletionBlock:^{
        NSError *jsonParsingError = nil;
        NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&jsonParsingError];
        NSLog(@"json======%@",json);
        NSArray *jsonArray = [[json objectForKey:@"RESPONSE"]objectForKey:@"PRICES"];
        NSArray *arrPropertyPrice =[Property_Availability objectFromJSONObject:jsonArray mapping:nil];
        callback(arrPropertyPrice);
    }];
    [request setFailedBlock:^{
        callback(nil);
    }];
    [request startAsynchronous];

/*
 property_number – sample request property_number = 72862
 date_start - sample request date_start = 2014-03-28
 num_nights - sample request num_nights = 2
 room_selected - sample request room_selected = 183472 ,183475,184023,196741,183474  (Comma separated values should be of equal length to bed_selected)
 bed_selected - sample request bed_selected = 0,0,1,2,0  (Comma separated values should be of equal length to room_selected)
 currency - sample request currency = EUR
 charge_fee - sample request charge_fee = true
 */
}
/************************ Member Booking ************************/
-(void) requestmemberBooking:(MemberBookingRequestCompleteBolck)callback
{
    NSString *strAPICall = [NSString stringWithFormat:@"member_bookings?%@",APIKEY];
    NSString *strURL = [NSString stringWithFormat:@"%@/%@",kBaseURL,strAPICall];
    NSURL *url = [NSURL URLWithString:strURL];
    request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addPostValue:profileInfo.member_id forKey:@"member_number"];
    [request addPostValue:profileInfo.session_id forKey:@"session_id"];
    [request setCompletionBlock:^{
        NSError *jsonParsingError = nil;
        NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&jsonParsingError];
        NSLog(@"json======%@",json);
        NSArray *jsonArray = [[json objectForKey:@"RESPONSE"]objectForKey:@"bookings"];
        NSArray *arrBooking =[MemberBookingModel objectFromJSONObject:jsonArray mapping:nil];
        callback(arrBooking);
    }];
    [request setFailedBlock:^{
        callback(nil);
    }];
    [request startAsynchronous];

}
/************************ Property Landmark ************************/
-(void) requestLandmarkwithProperty:(NSString*)propertyNumber WithCompleteBlock:(PropertyLandmarkRequestCompleteBolck) callback
{
    NSString *strAPICall = [NSString stringWithFormat:@"property?%@",APIKEY];
    NSString *strURL = [NSString stringWithFormat:@"%@/%@",kBaseURL,strAPICall];
    NSURL *url = [NSURL URLWithString:strURL];
    request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addPostValue:propertyNumber forKey:@"property_number"];
    [request setCompletionBlock:^{
        NSError *jsonParsingError = nil;
        NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&jsonParsingError];
        NSLog(@"json======%@",json);
        NSArray *jsonArray = [[json objectForKey:@"RESPONSE"]objectForKey:@"city_landmarks"];
        LandMarks *arrLandmark =[LandMarks objectFromJSONObject:jsonArray mapping:nil];
        callback(arrLandmark);
    }];
    [request setFailedBlock:^{
        callback(nil);
    }];
    
    [request startAsynchronous];

}

@end

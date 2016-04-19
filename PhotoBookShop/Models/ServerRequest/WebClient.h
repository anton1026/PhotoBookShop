//
//  WebServiceRequest.h
//  Youth_Hostel
//
//  Created by Anton Borev on 11/20/15.
//  Copyright © 2015 Anton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "NSObject+JTObjectMapping.h"
#import "ServerAPI.h"
#import "ProfileInfo.h"
#import "CurrencyModel.h"
#import "LanguageModel.h"
#import "FormatHelper.h"
#import "CityAddress.h"
#import "Suggestion.h"
#import "PropertyModel.h"
#import "detailedProperty.h"
#import "FavoriteModel.h"
#import "MemberBookingModel.h"
#import "Reachability.h"

typedef void (^CountryRequestCompleteBlock) (NSMutableArray *arrCountry);
typedef void (^LanguageRequestCompleteBlock) (NSArray *arrLanguage);
typedef void (^CurrencyRequestCompleteBlock) (NSArray *arrCurrency);
typedef void (^AccountCancelRequestCompleteBlock) (BOOL success);
typedef void (^MemberProfileRequestCompleteBlock) (PersonalInfo *theInfo);
typedef void (^MemberProfileUpdateRequestCompleteBlock) (BOOL success);
typedef void (^LocationAddressRequestCompleteBlock) (CityAddress *theCityAddress);
typedef void (^UpdateMemberPassword) (BOOL success);
typedef void (^ContentCompleteBlock) (NSString* content);
typedef void (^PropertyReviewRequestCompleteBlock) (NSArray *arrPropertyReview);
typedef void (^PropertyRequestCompleteBlock) (GeneralProperty *theProperty);
typedef void (^PropertyRequestImagesCompleteBlock) (NSArray *arrImage);
typedef void (^MemberFavoriteCompleteBlock) (NSArray *arrFavorite);
typedef void (^RemoveFavoriteCompleteBlock) (NSString* response);
typedef void (^AddFavoriteCompleteBlock) (NSString* response);
typedef void (^PropertyListCompleteBlock) (NSArray* arrProperty, NSArray* arrAmenity, int servererror);
typedef void (^ContactUsReuestCompleteBlock) (NSString* response);
typedef void (^SuggestionRequestCompleteBlock) (NSArray* response);
typedef void (^AvailabiltyRequestCompleteBlock) (NSArray* response, NSArray* arrCardType, int servererror);
typedef void (^PropertyPriceRequestCompleteBlock) (NSArray* response);
typedef void (^MemberBookingRequestCompleteBolck)(NSArray* response);
typedef void (^PropertyLandmarkRequestCompleteBolck)(NSArray* response);
@interface WebClient : NSObject

+(WebClient*) sharedInstance;

#pragma mark General server function
-(void) requestLocationAddressWithCallbackBlock:(LocationAddressRequestCompleteBlock) callback;
/************************ Member Profile *************************/
#pragma mark Member Part Server function
-(void) requestMemberProfileWithCallbackBlock:(MemberProfileRequestCompleteBlock) callback;
-(void) requestCountryWithCallbackBlock:(CountryRequestCompleteBlock) callback;
-(void) requestCurrencyWithCallbackBlock:(CurrencyRequestCompleteBlock) callback;
-(void) requestLanguageWithCallbackBlock:(LanguageRequestCompleteBlock) callback;
-(void) requestCancelAccountWithCallbackBlock:(AccountCancelRequestCompleteBlock) callback;
-(void) requestProfileUpdateWithLanguege:(LanguageModel*) theLanguage WithCurrency:(CurrencyModel*)theCurrency Gender_ID:(NSString*) gender_ID
                               FirstName:(NSString*) firstname LastName:(NSString*) lastname CountryName:(NSString*)countryName PhoneNumber :(NSString*) phoneNumber WithCompleteBlock:(MemberProfileUpdateRequestCompleteBlock)callback;
-(void) requestUpdateMemberPassword:(NSString*) oldPassword NewPassword:(NSString*) newPassword WithCompleteBlock:(UpdateMemberPassword)callback;
-(void) requestContentWithCategory:(NSString*) category WithCompleteBlock:(ContentCompleteBlock)callback;
-(void) requestMemberFavorite:(MemberFavoriteCompleteBlock) callback;
-(void) requestRemoveFavoriteWithID:(NSString*) favoriteID WithCompleteBlock:(RemoveFavoriteCompleteBlock) callback;
-(void) requestAddFavoriteWithPropertyNumber:(NSString*) propertyNumber WithCompleteBlock:(AddFavoriteCompleteBlock) callback;
/************************ Property Part **************************/
#pragma mark Property Part Server function
-(void) requestPropertyReviewWithPropertyNumber:(NSString*) propertyNumber WithCompleteBlock:(PropertyReviewRequestCompleteBlock) callback;
;
-(void) requestPropertyWithPorpertyNumber: (NSString*) propertyNumber WithCompleteBlock:(PropertyRequestCompleteBlock) callback;
-(void) requestPropertyImagesWithPropertyNumber: (NSString*) propertyNumber WithCompleteBlock:(PropertyRequestImagesCompleteBlock) callback;

-(void) requestPropertyListWithCity:(PropertyListCompleteBlock)callback;
-(void) requestPropertyListWithLocation:(PropertyListCompleteBlock)callback;

/************************ Contact Us **************************/
-(void) requestContactUsWithMessage:(NSString *)message WithSubject:(NSString*)subject WithName:(NSString*) name WithEmail:(NSString*)email WithCompleteBlock:(ContactUsReuestCompleteBlock)callback;
/************************ Suggestion **************************/
-(void) requestSuggestionWithTerm:(NSString *)term WithCallBack:(SuggestionRequestCompleteBlock)callback;
/************************ Check Avaiablity ************************/
-(void) requestCheckAvailabilty:(AvailabiltyRequestCompleteBlock)callback;
/************************ Property Price ************************/
-(void) requestPropertyPrice:(PropertyPriceRequestCompleteBlock)callback;
/************************ Member Booking ************************/
-(void) requestmemberBooking:(MemberBookingRequestCompleteBolck)callback;
/************************ Property LandMark ************************/
-(void) requestLandmarkwithProperty:(NSString*)propertyNumber WithCompleteBlock:(PropertyLandmarkRequestCompleteBolck) callback;
@end

//
//  ServerAPI.h
//  Youth_Hostel
//
//  Created by Anton Borev on 8/22/15.
//  Copyright (c) 2015 Anton. All rights reserved.
//

#ifndef Youth_Hostel_ServerAPI_h
#define Youth_Hostel_ServerAPI_h

//#define kBaseURL @"http://www.auberges.com/api"
//#define kBaseURL @"http://www.youth-hostels.co.uk/api"
#define kBaseURL @"https://www.dorms.com/api"
#define APIKEY @"api_key=123456"


#define GoogleMapKey @"AIzaSyAT1yW0_QISbWc6BPhrgudX2IGlkB1A-zw"
#define GooglePlusClientID @"31207950231-832s1i935cbqj35htar6arcsfad3s32s.apps.googleusercontent.com"
//Alert Message for Regieter New user
#define ALERT_FIRST_NAME @"Please enter first name"
#define ALERT_LAST_NAME @"Please enter last name"
#define ALERT_EMAIL @"Please enter email address"
#define ALERT_CHECKIN_TIME @"Please enter check_in time"
#define ALERT_VALID_EMAIL @"Please enter valid email address"
#define ALERT_PHONE_NUMBER @"Please enter Phone Number"
#define ALERT_SELECT_ROOM @"Please add any room"
#define ALERT_CURPASSWORD @"Please enter current password"
#define ALERT_PASSWORD @"Please enter password"
#define ALERT_CONF_PASSWORD @"Please enter confirm password"
#define ALERT_PASSWORD_NOTMATCH @"Password and Confirm password not same"
#define ALERT_PASSWORD_LENGHT @"The password must be at least 8 characters"
#define ALERT_NEWSLETTER_SUBSCRIPTION @"Please select NEWS letter subscription checkbox"


//Alert Message for Search
#define ALERT_SEARCH_FOR @"Please enter city,country name to search"
#define ALERT_CHECKIN_DATE @"Please select check in date"
#define ALERT_CHECKOUT_DATE @"Please select check out date"
#define ALERT_NO_NIGHTS @"Please select number of nights"
#define ALERT_NO_GUEST @"Please select number of guest"


//Alert Message for Change Passaword
#define ALERT_PREV_PASS @"Please enter previous password"
#define ALERT_NEW_PASS @"Please enter new password"
#define ALERT_PASS_UPDATED @"Password Successfully Updated"
#define ALERT_PASS_NOT_UPDATED @"Password Not Updated"


//Alert Message for Payment Option
#define ALERT_FULL_NAME @"Please enter Full name"
#define ALERT_CREDITCARD_NO @"Please enter credit card number"
#define ALERT_CREDITCARD_HOLDERNAME @"Please enter credit card holder name"
#define ALERT_CREDITCARD_TYPE @"Please enter card type"
#define ALERT_SELECT_MONTH @"Please select month"
#define ALERT_SELECT_YEAR @"Please select year"
#define ALERT_SECURITY_CODE @"Please enter security code"
#define ALERT_TERM_CONDITION @"Accept all terms and conditions"

//Alert Message for Personal Information View
#define ALERT_COUNTRY @"Please enter country"
#define ALERT_MALE @"Please select no of males"
#define ALERT_FEMALE @"Please select no of females"
#define ALERT_GENDER @"Please select no of Males/Females"



#define ALERT_CONFIRMATION_EMAILID @"Please enter email address for cofirmation"
#define ALERT_CONFIRMATION_NOT_VALID_EMAILID @"Please enter valid email address for cofirmation"
#define ALERT_CONFIRMEMAIL_EMAIL_NOTSAME @"Email address and Confirmation Email Address are not same"
#define ALERT_MOBILE_NO @"Please enter Mobile Number"
#define ALERT_SMS_CONFIRM @"Please select SMS Confirmation"
#define ALERT_TIME @"Please select time for check in"
#define ALERT_NEWSLETTER @"Please select NEWSletter subscriptions"

//Alert Message for Sign Out
#define ALERT_SIGN_OUT @"You are now logged out!"
#define ALERT_SIGN_IN @"First, You have to log in now!"

//Alert for My Profile
#define ALERT_PROFILE_UPDATED @"Profile Updated!"
#define ALERT_PROFILE_NOT_UPDATED @"Profile Not Updated!"


#define ShowAlert(myTitle, myMessage) [[[UIAlertView alloc] initWithTitle:NSLocalizedString(myTitle, nil) message:NSLocalizedString(myMessage, nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show]
//*request call back functions
#endif

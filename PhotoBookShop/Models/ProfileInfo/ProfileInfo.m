//
//  Profile.m
//  Youth_Hostel
//  Copyright (c) 2015 Anton. All rights reserved.
//

#import "ProfileInfo.h"

@implementation Profile
-(id)init
{
    self =[super init];
    self.arrExpandPhotos = [NSMutableArray array];
    self.arrFrontCoverPhotos = [NSMutableArray array];
    self.arrayCoverImages = [NSMutableArray array];
    self.coverTitle = @"Front Cover";
    self.isCoverEdited = false;
    if(self)
    {
//        self.gotoAddress =@"";
//        self.selectedCheckInTime =8;
//        self.isInternetConnect =YES;
//        self.isCompleteProfileRead =NO;
//        self.previousDate =nil;
//        self.isModifyBooking = NO;
//        self.isChangedStatus = YES;
        self.border_delta =50.0f;
    }
    return self;
}
+(Profile*) instance
{
    static Profile *instance =nil;
    if(instance ==nil){
        instance =[[Profile alloc]init];
    }
    return instance;
}

@end

//
//  PhotoCoverCell.m
//  PhotoBookShop
//  Copyright © 2016 Peter. All rights reserved.
//

#import "PhotoCoverCell.h"

@implementation PhotoCoverCell
- (IBAction)onSubCover1_Edit:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"" message:@"Testing1" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}
- (IBAction)onSubCover2_Edit:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"" message:@"Testing2" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}
- (IBAction)onSubCover3_Edit:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"" message:@"Testing3" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}
- (IBAction)onSubCover4_Edit:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"" message:@"Testing4" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}
- (IBAction)onFronCoverTitleEdit:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"" message:@"Testing_Title" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

@end

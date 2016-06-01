//
//  PhotoBookCoverViewController.m
//  PhotoBookShop
//  Copyright © 2016 Peter. All rights reserved.
//
#import "PhotoBookCoverViewController.h"
#import "ProductCategory.h"
#import "WebClient.h"
#import "LXReorderableCollectionViewFlowLayout.h"
#import "ProfileInfo.h"
#import "PhotoBookCoverCell.h"
#import "PhotoEditController.h"
#import "PhotoCustomViewController.h"
@interface PhotoBookCoverViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>
{
    NSArray *imgPointArray;
    UIImage *mergedImage;
    Products *selectedProduct;
}

@end

@implementation PhotoBookCoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Profile instance].isCoverEdited = true;
    selectedProduct = [Profile instance].selectedProduct;
    UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self  action:@selector(handlePan:)];
    pgr.maximumNumberOfTouches = 2;
    pgr.delegate = self;
    [self.view addGestureRecognizer:pgr];
    [self setCanvasSize];
    [self initCoverImages];
    [self.photoCoverCollectionview reloadData];
}
-(void) setCanvasSize
{
    int product_width  = [selectedProduct.width intValue];
    int product_height = [selectedProduct.height intValue];
    double ratio=1.0;
    if(product_height >product_width)
    {
        ratio =(product_width*1.0) /(product_height*1.0);
        self.superViewHeight.constant =350;
        self.superViewWidth.constant =(int) (350 *ratio);
    }else{
        ratio =(product_height*1.0) /(product_width*1.0);
        self.superViewWidth.constant =350;
        self.superViewHeight.constant =(int) (350*ratio);
    }
   
    [self.photoCoverSuperView layoutIfNeeded];
    
}
- (void)initCoverImages{
    _coverSubImage1.image = [Profile instance].arrFrontCoverPhotos[0];
    _coverSubImage2.image = [Profile instance].arrFrontCoverPhotos[1];
    _coverSubImage3.image = [Profile instance].arrFrontCoverPhotos[2];
    _coverSubImage4.image = [Profile instance].arrFrontCoverPhotos[3];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self initCoverImages];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Pangesture
-(void)handlePan:(UIPanGestureRecognizer *)panGesture{
    CGPoint touchPoint = [panGesture locationInView:self.view];
    _touchImageView.alpha = 0.2f;
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        _touchImageView.center = touchPoint;
    }
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        _touchImageView.center = touchPoint;
        if (touchPoint.x > self.photoCoverSuperView.frame.origin.x && touchPoint.x < (self.photoCoverSuperView.frame.origin.x + self.photoCoverSuperView.frame.size.width/2)) {
            if (touchPoint.y > _photoCoverSuperView.frame.origin.y && touchPoint.y < (_photoCoverSuperView.frame.origin.y + _photoCoverSuperView.frame.size.height/ 2)) {
                [UIView animateWithDuration:0.5 animations:^{
                    if (_touchImageView.image != nil) {
                        _coverSubImage1.image = _touchImageView.image;
                        NSLog(@"Number 1");
                    }
                } completion:^(BOOL finished) {
                    if (finished == true) {
                        if (_touchImageView.image != nil) {
                            [[Profile instance].arrFrontCoverPhotos removeObjectAtIndex:0];
                            [[Profile instance].arrFrontCoverPhotos insertObject:_coverSubImage1.image atIndex:0];
                            [self initCoverImages];
                            _touchImageView.image = nil;
                            [_touchImageView setHidden:YES];
                        }
                    }
                    
                }];
            }
        }
        
        if (touchPoint.x > (_photoCoverSuperView.frame.origin.x + _photoCoverSuperView.frame.size.width/2) && touchPoint.x <( _photoCoverSuperView.frame.origin.x  + _photoCoverSuperView.frame.size.width)) {
            if (touchPoint.y > _photoCoverSuperView.frame.origin.y && touchPoint.y < (_photoCoverSuperView.frame.origin.y + _photoCoverSuperView.frame.size.height/ 2)) {
                [UIView animateWithDuration:0.5 animations:^{
                    if (_touchImageView.image != nil) {
                        _coverSubImage2.image = _touchImageView.image;
                        NSLog(@"Number 2");
                    }
                } completion:^(BOOL finished) {
                    if (finished == true) {
                        if (_touchImageView.image != nil) {
                            [[Profile instance].arrFrontCoverPhotos removeObjectAtIndex:1];
                            [[Profile instance].arrFrontCoverPhotos insertObject:_coverSubImage2.image atIndex:1];
                            [self initCoverImages];
                            _touchImageView.image = nil;
                            [_touchImageView setHidden:YES];
                        }
                    }
                }];
            }
        }
        if (touchPoint.x > self.photoCoverSuperView.frame.origin.x && touchPoint.x < (self.photoCoverSuperView.frame.origin.x + self.photoCoverSuperView.frame.size.width/2)) {
            if (touchPoint.y > (_photoCoverSuperView.frame.origin.y + _photoCoverSuperView.frame.size.height/2) && touchPoint.y < (_photoCoverSuperView.frame.origin.y + _photoCoverSuperView.frame.size.height)) {
                [UIView animateWithDuration:0.5 animations:^{
                    if (_touchImageView.image != nil) {
                        _coverSubImage3.image = _touchImageView.image;
                        NSLog(@"Number 3");
                    }
                } completion:^(BOOL finished) {
                    if (finished == true) {
                        if (_touchImageView.image != nil) {
                            [[Profile instance].arrFrontCoverPhotos removeObjectAtIndex:2];
                            [[Profile instance].arrFrontCoverPhotos insertObject:_coverSubImage3.image atIndex:2];
                            [self initCoverImages];
                            _touchImageView.image = nil;
                            [_touchImageView setHidden:YES];
                        }
                    }
                    
                }];
            }
        }
        if (touchPoint.x > (_photoCoverSuperView.frame.origin.x + _photoCoverSuperView.frame.size.width/2) && touchPoint.x <( _photoCoverSuperView.frame.origin.x  + _photoCoverSuperView.frame.size.width)) {
            if (touchPoint.y > (_photoCoverSuperView.frame.origin.y + _photoCoverSuperView.frame.size.height/2) && touchPoint.y < (_photoCoverSuperView.frame.origin.y + _photoCoverSuperView.frame.size.height)) {
                [UIView animateWithDuration:0.5 animations:^{
                    if (_touchImageView.image != nil) {
                        _coverSubImage4.image = _touchImageView.image;
                        
                        NSLog(@"Number 4");
                    }
                } completion:^(BOOL finished) {
                    if (finished == true) {
                        if (_touchImageView.image != nil) {
                            [[Profile instance].arrFrontCoverPhotos removeObjectAtIndex:3];
                            [[Profile instance].arrFrontCoverPhotos insertObject:_coverSubImage4.image atIndex:3];
                            [self initCoverImages];
                            _touchImageView.image = nil;
                            [_touchImageView setHidden:YES];
                        }
                    }
                    
                }];
            }
        }
    }
    if (panGesture.state == UIGestureRecognizerStateFailed) {
        [UIView animateWithDuration:0.5 animations:^{
            [_touchImageView setHidden:YES];
            _touchImageView.image = nil;
            
        } completion:^(BOOL finished) {
        }];
    }if (panGesture.state == UIGestureRecognizerStateCancelled) {
        [UIView animateWithDuration:0.5 animations:^{
            [_touchImageView setHidden:YES];
            _touchImageView.image = nil;
            
        } completion:^(BOOL finished) {
        }];
    }
    
}

#pragma  mark LongpressTouch

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    CGPoint p = [gestureRecognizer locationInView:self.photoCoverCollectionview];
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        NSIndexPath *indexPath = [self.photoCoverCollectionview indexPathForItemAtPoint:p];
        if (indexPath == nil) {
            NSLog(@"Couldn't find index path");
        }else{
            PhotoBookCoverCell *cell = (PhotoBookCoverCell *)[self.photoCoverCollectionview cellForItemAtIndexPath:indexPath];
            self.touchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.origin.x - 10, cell.frame.origin.y + 50, cell.frame.size.width + 20, cell.frame.size.height + 20)];
            _touchImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            self.touchImageView.image= [Profile instance].arrayCoverImages[indexPath.row];
            [self.view addSubview:self.touchImageView];
            p = [gestureRecognizer locationInView:self.view];
            NSLog(@"Position X = %f Postition Y = %f",p.x, p.y);
            self.touchImageView.center = p;
        }
    }
}

#pragma mark - Collection View Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [Profile instance].arrayCoverImages.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoBookCoverCell * cell =(PhotoBookCoverCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoBookCoverCell" forIndexPath:indexPath];
    cell.coverImage.image = [Profile instance].arrayCoverImages[indexPath.row];
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_touchImageView.image == nil) {
        PhotoBookCoverCell *cell = (PhotoBookCoverCell *)[self.photoCoverCollectionview cellForItemAtIndexPath:indexPath];
        
        CGPoint p = CGPointMake(self.view.center.x, self.view.center.y + 150);
        self.touchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.origin.x - 10, cell.frame.origin.y + 20, cell.frame.size.width + 20, cell.frame.size.height + 20)];
        _touchImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.touchImageView.image= [Profile instance].arrayCoverImages[indexPath.row];
        [self.view addSubview:self.touchImageView];
        NSLog(@"Position X = %f Postition Y = %f",p.x, p.y);
        self.touchImageView.center = p;
    }else{
        _touchImageView.image = nil;
        [_touchImageView setHidden:YES];
    }
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
#pragma mark - UICollectionViewFlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80,80);
}
#pragma mark- UpdateFrontCover
- (void)onUpdateFrontCoverImage{
    [[Profile instance].arrFrontCoverPhotos insertObject:_coverSubImage1.image atIndex:0];
    [[Profile instance].arrFrontCoverPhotos insertObject:_coverSubImage2.image atIndex:1];
    [[Profile instance].arrFrontCoverPhotos insertObject:_coverSubImage3.image atIndex:2];
    [[Profile instance].arrFrontCoverPhotos insertObject:_coverSubImage4.image atIndex:3];
}
#pragma mark- onDone
- (IBAction)onDone:(id)sender {
    [self onUpdateFrontCoverImage];
    [[Profile instance].arrExpandPhotos removeObjectAtIndex:1];
    [[Profile instance].arrExpandPhotos insertObject:[Profile instance].arrFrontCoverPhotos atIndex:1];
    [Profile instance].editedCoverImage =[self setMergeImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark- onBack
- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark front cover edit
- (IBAction)onFrontCoverEdit:(id)sender {
    UIAlertView *frontCoverTitleEditAlert = [[UIAlertView alloc] initWithTitle:@"Please enter front cover title." message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
    frontCoverTitleEditAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [frontCoverTitleEditAlert show];
    
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSString *buttonTitle = [alertView textFieldAtIndex:0].text;
        [Profile instance].coverTitle = buttonTitle;
        [_btnFrontCover setTitle:[Profile instance].coverTitle forState:UIControlStateNormal];
    }else{
        
    }
    
}
- (IBAction)onEditSubImage4:(id)sender {
    [WebClient sharedInstance].webClientRequestIndex = PHOTOCOVER;
    PhotoEditController *photoEditViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoEditController"];
    photoEditViewController.selectedIndex =  3;
    photoEditViewController.canvas_height = self.view.frame.size.width *0.7;
    photoEditViewController.canvas_width  = self.view.frame.size.width - 50;
    [self presentViewController:photoEditViewController animated:YES completion:nil];
    
}
- (IBAction)onEditSubImage2:(id)sender {
    [WebClient sharedInstance].webClientRequestIndex = PHOTOCOVER;
    PhotoEditController *photoEditViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoEditController"];
    photoEditViewController.selectedIndex =  1;
    photoEditViewController.canvas_height = self.view.frame.size.width *0.7;
    photoEditViewController.canvas_width  = self.view.frame.size.width - 50;
    [self presentViewController:photoEditViewController animated:YES completion:nil];
}
- (IBAction)onEditSubImage3:(id)sender {
    [WebClient sharedInstance].webClientRequestIndex = PHOTOCOVER;
    PhotoEditController *photoEditViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoEditController"];
    photoEditViewController.selectedIndex =  2;
    photoEditViewController.canvas_height = self.view.frame.size.width *0.7;
    photoEditViewController.canvas_width  = self.view.frame.size.width - 50;
    [self presentViewController:photoEditViewController animated:YES completion:nil];
}
- (IBAction)onEditSubImage1:(id)sender {
    [WebClient sharedInstance].webClientRequestIndex = PHOTOCOVER;
    PhotoEditController *photoEditViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoEditController"];
    photoEditViewController.selectedIndex =  0;
    photoEditViewController.canvas_height = self.view.frame.size.width *0.7;
    photoEditViewController.canvas_width  = self.view.frame.size.width - 50;
    [self presentViewController:photoEditViewController animated:YES completion:nil];
}

#pragma mark ImageMerge

-(void)setMergeImage1:(NSMutableArray *) imageArrray
{
    UIImage *image1 = imageArrray[0];
    UIImage *image2 = imageArrray[2];
    NSLog(@"width = %f,height %f",_coverImage.frame.size.width,_coverImage.frame.size.height);
    CGSize size = CGSizeMake(200, 200);
    
    UIGraphicsBeginImageContext(size);
    [image1 drawInRect:CGRectMake(_coverSubImage3.frame.origin.x,_coverSubImage3.frame.origin.y,_coverSubImage3.frame.size.width, _coverSubImage3.frame.size.height)];
    [image2 drawInRect:CGRectMake(_coverSubImage1.frame.origin.x,_coverSubImage1.frame.origin.y,_coverSubImage1.frame.size.width, _coverSubImage1.frame.size.height)];
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    NSLog(@"width = %f,height %f",finalImage.size.width,finalImage.size.height);
    //Add image to view
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, finalImage.size.width, finalImage.size.height)];
    imageView.image = finalImage;
    //    [self.view addSubview:imageView];
}

-(void)setMergeImage2:(NSMutableArray *) imageArrray
{
    UIImage *image1 = imageArrray[1];
    UIImage *image2 = imageArrray[3];
    NSLog(@"width = %f,height %f",_coverImage.frame.size.width,_coverImage.frame.size.height);
    CGSize size1 = CGSizeMake(200, 200);
    
    UIGraphicsBeginImageContext(size1);
    
    [image1 drawInRect:CGRectMake(_coverSubImage4.frame.origin.x,_coverSubImage4.frame.origin.y,_coverSubImage4.frame.size.width, _coverSubImage4.frame.size.height)];
    [image2 drawInRect:CGRectMake(_coverSubImage2.frame.origin.x,_coverSubImage2.frame.origin.y,_coverSubImage2.frame.size.width, _coverSubImage2.frame.size.height)];
    UIImage *finalImage1 = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    NSLog(@"width = %f,height %f",finalImage1.size.width,finalImage1.size.height);
    //Add image to view
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(200, 0, finalImage1.size.width, finalImage1.size.height)];
    imageView1.image = finalImage1;
    //    [self.view addSubview:imageView1];
}
#pragma mark ImageMerge

-(UIImage *)setMergeImage
{
    
    [_backgroundView addSubview:_coverImage];
    [_backgroundView addSubview:_coverSubImage1];
    [_backgroundView addSubview:_coverSubImage2];
    [_backgroundView addSubview:_coverSubImage3];
    [_backgroundView addSubview:_coverSubImage4];
    [_backgroundView addSubview:_coverTitle];
    
    [_photoCoverSuperView addSubview:_backgroundView];
    UIGraphicsBeginImageContext(_photoCoverSuperView.bounds.size);
    [_photoCoverSuperView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  finalImage;
}

@end

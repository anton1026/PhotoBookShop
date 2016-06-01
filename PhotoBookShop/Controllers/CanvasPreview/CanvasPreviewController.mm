//
//  CanvasPreviewController.m
//  PhotoBookShop
//  Copyright © 2016 Peter. All rights reserved.
//

#import "CanvasPreviewController.h"
#import "WebClient.h"


#include "../../libs/ShaderPlayground/Demos/BlinnPhongPerFrag.h"
#include <vector>
#include "../../libs/ShaderPlayground/Helpers.h"

@interface CanvasPreviewController ()
{
    int nCount;
    Profile *profileInfo;
    Products *selectedProduct;
    float nPrice;
    NSString *price_symbol;
    
    DemoBase* demo;
    vector<DemoBase*> demos;
    UIView *_renderView;
    float mouse_x;
    float mouse_y;
    
}

@property (strong, nonatomic) EAGLContext *context;

- (void)setupGL;
- (void)tearDownGL;
- (void)standView;
- (void)setDemo:(DemoBase*) demoToShow;

@end

@implementation CanvasPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    profileInfo =[Profile instance];
    selectedProduct =profileInfo.selectedProduct;
    price_symbol =profileInfo.currencySymbol;
    nPrice = [selectedProduct.sellprice floatValue];
    
    self.quantityView.layer.cornerRadius =5;
    self.quantityView.layer.borderColor =[UIColor blackColor].CGColor;
    self.quantityView.layer.borderWidth =1;
    
    self.countView.layer.cornerRadius =5;
    self.countView.layer.borderColor =[UIColor grayColor].CGColor;
    self.countView.layer.borderWidth =1;
    
    self.btnAddtoCart.layer.cornerRadius =3;
    self.btnAddtoCart.layer.borderColor =[UIColor grayColor].CGColor;
    self.btnAddtoCart.layer.borderWidth =2;
    
    nCount =1;
    self.lblTotalNumber.text =[NSString stringWithFormat:@"%d",nCount];
    self.lblSize.text =[NSString stringWithFormat:@"%d x %@",nCount,selectedProduct.name];
    self.lblPrice.text =[NSString stringWithFormat:@"%@%.2f",price_symbol,nPrice*nCount];
    
    //opengl init
    self.preview_Width.constant =300;
    self.preview_Height.constant =300;
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    self.preView.context = self.context;
    self.preView.delegate = self;
    self.preView.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    [self.preView setEnableSetNeedsDisplay:YES];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    [EAGLContext setCurrentContext:self.context];
    demos.push_back(new BlinnPhongPerFrag());
    [self setDemo:demos.at(0)];
    [EAGLContext setCurrentContext:self.context];
   // NSString* imgName = [NSString stringWithCString:"image2.jpg" encoding:NSUTF8StringEncoding];
    
//    UIImage* flippedImage = [UIImage imageWithCGImage:profileInfo.editedPhotoImage.CGImage
//                                                scale:profileInfo.editedPhotoImage.scale
//                                          orientation:UIImageOrientationDownMirrored];
    
    UIImage* _image =profileInfo.editedPhotoImage;  //[UIImage imageNamed:imgName];
//    CGSize size=CGSizeMake(512,512);
//    _image=[self imageScaledToSize:size withImage:_image];
    GLuint px=LoadGLTexture(_image);
    demo->SetupGL(px,false,self.preView.bounds.size.width/self.preView.bounds.size.height);
    
//    if(self.canvas_width == self.canvas_height){
//        demo->UpdateChange(0.4,self.preView.bounds.size.width/self.preView.bounds.size.height,0.1,profileInfo.warpMode);
//    }else if(self.canvas_width > self.canvas_height){
//        demo->UpdateChange(0.4,self.preView.bounds.size.width/self.preView.bounds.size.height,0.1,profileInfo.warpMode);
//        
//    }else{
//        demo->UpdateChange(0.3,self.preView.bounds.size.width/self.preView.bounds.size.height,0.1,profileInfo.warpMode);
//    }

        if(self.canvas_width == self.canvas_height){
            demo->UpdateChange(0.4,self.canvas_width/self.canvas_height,0.1,profileInfo.warpMode);
        }else if(self.canvas_width > self.canvas_height){
            demo->UpdateChange(0.4,self.canvas_width/self.canvas_height,0.1,profileInfo.warpMode);
    
        }else{
            if(self.canvas_width/self.canvas_height<=0.5)
               demo->UpdateChange(0.15,self.canvas_width/self.canvas_height,0.1,profileInfo.warpMode);
            else
               demo->UpdateChange(0.3,self.canvas_width/self.canvas_height,0.1,profileInfo.warpMode);
        }
    mouse_x=0.67;
    mouse_y=0.05;
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawFrame)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}
-(void) viewDidAppear:(BOOL)animated
{
   
    
}
-(void) viewDidDisappear:(BOOL)animated
{
    [self tearDownGL];
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}
- (IBAction)onPlusClick:(id)sender {
    nCount++;
    self.lblTotalNumber.text =[NSString stringWithFormat:@"%d",nCount];
    self.lblSize.text =[NSString stringWithFormat:@"%d x %@",nCount,selectedProduct.name];
    self.lblPrice.text =[NSString stringWithFormat:@"%@%.2f",price_symbol,nPrice*nCount];


}
- (IBAction)onMinusClick:(id)sender {
    if(nCount >1)
        nCount--;
    self.lblTotalNumber.text =[NSString stringWithFormat:@"%d",nCount];
    self.lblSize.text =[NSString stringWithFormat:@"%d x %@",nCount,selectedProduct.name];
    self.lblPrice.text =[NSString stringWithFormat:@"%@%.2f",price_symbol,nPrice*nCount];
}
- (IBAction)onAddCartClick:(id)sender {
}
- (IBAction)onBackClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark UitextField Delegate Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
  
}
//  ************************  open gl related functions  *****************************
- (UIImage *)imageScaledToSize:(CGSize)size withImage:(UIImage *)_image
{
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    //draw
    [_image drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //return image
    return image;
}
GLuint LoadGLTexture(UIImage*_image)
{
    // 1
    
    CGImageRef spriteImage = _image.CGImage;
    
    if (!spriteImage)
    {
        LOGI("Image: failed to load.");
        return 0;
    }
    
    // 2
    size_t width = 1024;
    size_t height = 1024;
    
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    // 3
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    // 4
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width, (GLsizei)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);
    return texName;
}

- (void)dealloc
{
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    // Dispose of any resources that can be recreated.
}

- (void)setDemo:(DemoBase *)demoToShow
{
    demo = demoToShow;
}

- (void)setupGL
{
    
}
- (void)standView
{
    
    mouse_y=0.0;
    mouse_x=0.0;
    
}
//- (IBAction)changeValue:(id)sender {
//    
//    float kk=0.2*_slider.value;
//    demo->UpdateChange(0.3,self.preView.bounds.size.width/self.preView.bounds.size.height,kk,true);
//    
//}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    demo->TearDownGL();
}
- (IBAction)changeFormat:(id)sender {
    demo->UpdateChange(0.3,0.8,0.1,true);
}
- (IBAction)standview:(id)sender {
    [self standView];
    demo->UpdateChange(0.4,self.preView.bounds.size.width/self.preView.bounds.size.height,0.1,true);
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)drawFrame
{
    demo->Update(self.preView.bounds.size.width, self.preView.bounds.size.height, 1.0,mouse_x,mouse_y);
    [self.preView setNeedsDisplay];
}
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    if (demo->isLoaded==true)
        demo->Render();
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    UITouch *touched = [[event allTouches] anyObject];
    CGPoint location = [touched locationInView: self.view];
    
    if(!CGRectContainsPoint(self.preView.frame, location))
    {
        return;
    }
    mouse_x=2.5f*(location.x/self.preView.bounds.size.width-0.5f);
    mouse_y=2.5f*(location.y/self.preView.bounds.size.height-0.5f);
    NSLog(@"x=%.2f y=%.2f", mouse_x, mouse_y);
}


@end

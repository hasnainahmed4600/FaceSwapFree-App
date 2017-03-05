//
//  ViewController.m
//  FaceDetectionExample
//
//  Created by Johann Dowa on 11-11-01.
//  Copyright (c) 2011 ManiacDev.Com. All rights reserved.
//
#import "InfoViewController.h"
#import "SwapFaceView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Resize.h"
#import "ViewController.h"
#import "FaceBookImagePicker.h"

@import GoogleMobileAds;

@interface ViewController () <GADInterstitialDelegate, UIAlertViewDelegate>

/// The interstitial ad.
@property(nonatomic, strong) GADInterstitial *interstitial;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@end

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bannerView.adUnitID = @"ca-app-pub-5838027022031261/6783938434";
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
    
   // [NSTimer scheduledTimerWithTimeInterval:30.f target:self selector:@selector(showCustomBanner) userInfo:nil repeats:NO];
//
//    SwapFaceView *swapFaceView=[[SwapFaceView alloc]init];
//    swapFaceView.image11=[UIImage imageNamed:@"fb_icon.png"];
//   // swapFaceView.features=features;
//    [self.navigationController pushViewController:swapFaceView animated:YES];
//
//
   // startAppAd_autoLoad = [[STAStartAppAd alloc] init];
 //   startAppAd_loadShow = [[STAStartAppAd alloc] init];
 //   [startAppAd_autoLoad loadAdWithDelegate:self];
//  startAppAd_autoLoad showAd];
   
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
    HUD.delegate = self;
	HUD.labelText = @"Loading";
   // self.interstitial = [self createAndLoadInterstitial];
  //  [self createAndLoadInterstitial];
    
}

- (void)showCustomBanner
{
    if ( self.customBanner.hidden )
    {
        self.customBanner.hidden = NO;
        
        [NSTimer scheduledTimerWithTimeInterval:30.f target:self selector:@selector(showCustomBanner) userInfo:nil repeats:NO];
    }
    else
    {
        self.customBanner.hidden = YES;
        
        [NSTimer scheduledTimerWithTimeInterval:45.f target:self selector:@selector(showCustomBanner) userInfo:nil repeats:NO];
    }
}
- (IBAction)bannerClick:(id)sender {
    NSString *GiftAppURL = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/spin-dottor/id1020899804?mt=8"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:GiftAppURL]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}
/*
- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-5838027022031261/7623120030"];
    interstitial.delegate = self;
    [interstitial loadRequest:[GADRequest request]];
    return interstitial;
}
*/
- (void)createAndLoadInterstitial {
    self.interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-5838027022031261/7623120030"];
    self.interstitial.delegate = self;
    
    GADRequest *request = [GADRequest request];
    // Request test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made. GADInterstitial automatically returns test ads when running on a
    // simulator.
    request.testDevices = @[ kGADSimulatorID ];

    //request.testDevices = @[
     //                       @"2077ef9a63d2b398840261c8221a0c9a"  // Eric's iPod Touch
    //                        ];
    [self.interstitial loadRequest:request];
}



#pragma mark GADInterstitialDelegate implementation

- (void)interstitial:(GADInterstitial *)interstitial
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, [error localizedDescription]);
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    NSLog(@"%s", __PRETTY_FUNCTION__);
   // [self createAndLoadInterstitial];
}


/// Tells the delegate an ad request loaded an ad.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"adViewDidReceiveAd");
}

/// Tells the delegate an ad request failed.
- (void)adView:(GADBannerView *)adView
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

/// Tells the delegate that a full screen view will be presented in response
/// to the user clicking on an ad.
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillPresentScreen");
}

/// Tells the delegate that the full screen view will be dismissed.
- (void)adViewWillDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillDismissScreen");
}

/// Tells the delegate that the full screen view has been dismissed.
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewDidDismissScreen");
}

/// Tells the delegate that a user click will open another app (such as
/// the App Store), backgrounding the current app.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    NSLog(@"adViewWillLeaveApplication");
}

-(IBAction)takeImageButtonClick:(id)sender
{
    //[STAStartAppAdBasic showAd];
    
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self];
    } else {
       /* [[[UIAlertView alloc] initWithTitle:@"Interstitial not ready"
                                    message:@"The interstitial didn't finish loading or failed to load"
                                   delegate:self
                          cancelButtonTitle:@"Drat"
                          otherButtonTitles:nil] show];
        */
    }
    
    UIButton *btn=(UIButton *)sender;
    if (btn.tag==2)
    {
        NSString *GiftAppURL = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/swap-face/id683749922?mt=8"];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:GiftAppURL]];

//        if (fbImagePickerView==nil) {
//            fbImagePickerView=[[FaceBookImagePicker alloc]init];
//            fbImagePickerView.delegate=self;
//        }
//        [self presentModalViewController:fbImagePickerView animated:YES];
    }
    else
    {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        if (btn.tag==1 )
        {
             picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.modalPresentationStyle = UIModalPresentationFullScreen;
             [self presentViewController:picker animated:YES completion:nil];
        }
        else if (btn.tag==3)
        {
            BOOL isCameraAvailable = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
            if (isCameraAvailable) {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.modalPresentationStyle = UIModalPresentationFullScreen;
                 [self presentViewController:picker animated:YES completion:nil];
            } else {
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Camera doesn't support" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                       [alertView show];
            }
            
        }
        
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{    

    UIImage *image1 = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	//[HUD showWhileExecuting:@selector(imageCheck:) onTarget:self withObject:image1 animated:YES];
    
    [self imageCheck:image1];
    [self dismissViewControllerAnimated:YES completion:nil];
    /*if ([self.interstitial isReady]) {
        [self.interstitial presentFromRootViewController:self];
    }*/
}

-(void)imageCheck:(UIImage *)image1
{
    CIImage* image = [CIImage imageWithCGImage:[self fixrotation:image1].CGImage];
    
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    NSArray* features = [detector featuresInImage:image];
    if (features.count>1)
    {
        SwapFaceView *swapFaceView=[[SwapFaceView alloc]init];
        swapFaceView.image11=[self fixrotation:image1];
        swapFaceView.features=features;
        [self.navigationController pushViewController:swapFaceView animated:YES];
    }
    else
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Two Or more face needed for swapping" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }

}

//-(void)showAlert
//{
////    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Two Or more face needed for swapping" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
////    
////    [alertView show];
//    
//    //[[[UIAlertView alloc] initWithTitle:@"Alert" message:@"" delegate:@"Two Or more face needed for swapping" cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//    
//}
-(void)facebookImagePicker:(FaceBookImagePicker *)fbImagePicker selectedImage:(UIImage *)image1
{
    [HUD showWhileExecuting:@selector(imageCheck:) onTarget:self withObject:image1 animated:YES];
}

- (UIImage *)fixrotation:(UIImage *)image{
    
    
    if (image.imageOrientation == UIImageOrientationUp)
    {
        return image;
    }
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
/*

   /////////////////////////////////////////////////// 
  //                                               //
 //   //                                          //
//   //------------------/TTT/                   //
\\   \\------------------\___\                   \\
 \\   \\                                          \\
  \\                                               \\
   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */


-(IBAction)SwapButtonClick:(id)sender
{

    CIImage* image = [CIImage imageWithCGImage:mainImageView.image.CGImage];
    
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    
    // create an array containing all the detected faces from the detector
    NSArray* features = [detector featuresInImage:image];
    
    if (features.count>1)
    {
        
        
        CIFaceFeature *face1=[features objectAtIndex:0];
        CIFaceFeature *face2=[features objectAtIndex:1];
        
        CGRect rect1=[self flipRect:face1.bounds Bound:mainImageView.bounds];
        
        CGImageRef imageRef = CGImageCreateWithImageInRect([mainImageView.image CGImage], rect1);
        UIImage *img = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        CGRect rect2=[self flipRect:face2.bounds Bound:mainImageView.bounds];
        CGImageRef imageRef1 = CGImageCreateWithImageInRect([mainImageView.image CGImage], rect2);
        UIImage *img1 = [UIImage imageWithCGImage:imageRef1];
        CGImageRelease(imageRef1);

//        GLfloat x = face1.rightEyePosition.x - face1.leftEyePosition.x;
//        GLfloat y = (CGRectGetMaxY(mainImageView.bounds)-face1.rightEyePosition.y) - (CGRectGetMaxY(mainImageView.bounds)-face1.leftEyePosition.y);
//        float radians = atan2(-x, -y);
    
        float radians = atan2((CGRectGetMaxY(mainImageView.bounds)-face1.rightEyePosition.y) - (CGRectGetMaxY(mainImageView.bounds)-face1.leftEyePosition.y) , face1.rightEyePosition.x - face1.leftEyePosition.x);
        
//        GLfloat x1 =  face2.rightEyePosition.x - face2.leftEyePosition.x;
//        GLfloat y1 = (CGRectGetMaxY(mainImageView.bounds)-face2.rightEyePosition.y) - (CGRectGetMaxY(mainImageView.bounds)-face2.leftEyePosition.y);
//        float radians1 = atan2(-x1, -y1);

       float radians1 = atan2((CGRectGetMaxY(mainImageView.bounds)-face2.rightEyePosition.y) - (CGRectGetMaxY(mainImageView.bounds)-face2.leftEyePosition.y) , face2.rightEyePosition.x - face2.leftEyePosition.x);
        
        NSLog(@"radians 1 :%f",radians);
        NSLog(@"radians 2 :%f",radians1);
        UIImage *rowMask=[self rotateImage:radians image:[[UIImage imageNamed:@"mask_image.png"] resizedImage:img.size interpolationQuality:kCGInterpolationDefault]];
        UIImage *getMaskedImage1=[self maskImage:img withMaskImage:rowMask];
        UIImage *maskImage1=[self rotateImage:radians1 image:getMaskedImage1];
        
        
        UIImage *rowMask1=[self rotateImage:radians1 image:[[UIImage imageNamed:@"mask_image.png"] resizedImage:img1.size interpolationQuality:kCGInterpolationDefault]];

        UIImage *getMaskedImage2=[self maskImage:img1 withMaskImage:rowMask1];
        UIImage *maskImage2=[self rotateImage:radians image:getMaskedImage2];
        UIImage *final1=[self rotateImage:radians1 image:maskImage1];
        UIImage *final2=[self rotateImage:radians image:maskImage2];
        CGSize offScreenSize=mainImageView.image.size;
        UIGraphicsBeginImageContext(offScreenSize);
        
        
        [mainImageView.image  drawInRect:CGRectMake(0, 0,offScreenSize.width, offScreenSize.height)];
        [final1 drawInRect:rect2];
        [final2 drawInRect:rect1];
        //[img1 roundedCornerImage:img1.size.height/5 borderSize:0]
        UIImage* imagez = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        mainImageView.image=imagez;
        mainImageView.frame=CGRectMake(0, 0, 320, 460);
   
    }
}


-(CGRect)flipRect:(CGRect)rect Bound:(CGRect)bounds
{
    return CGRectMake(CGRectGetMinX(rect),
                      CGRectGetMaxY(bounds)-CGRectGetMaxY(rect),
                      CGRectGetWidth(rect),
                      CGRectGetHeight(rect));
}

-(UIImage *)rotateImage:(float)degree image:(UIImage *)img
{
    UIGraphicsBeginImageContext(img.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, +(img.size.width * 0.5f), +(img.size.height * 0.5f));
    CGContextRotateCTM (context,degree);//35.0 * M_PI/180);
    NSLog(@"angle : %f",degree);
    //[img drawAtPoint:CGPointMake(-50, -100)];
    [img drawInRect:CGRectMake(-img.size.width/2,-img.size.height/2, img.size.width,img.size.height)];
    return UIGraphicsGetImageFromCurrentImageContext();
}
- (GLfloat) calculateAngle:(GLfloat)x1 :(GLfloat)y1 :(GLfloat)x2 :(GLfloat)y2
{
    GLfloat x = x2 - x1;
    GLfloat y = y2 - y1;
    GLfloat angle = 180 + (atan2(-x, -y) * (180/3.14));
    return angle;
}

- (UIImage*) maskImage:(UIImage *)image withMaskImage:(UIImage*)maskImage {
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef maskImageRef = [maskImage CGImage];
    
    CGContextRef mainViewContentContext = CGBitmapContextCreate (NULL, maskImage.size.width, maskImage.size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    
    if (mainViewContentContext==NULL)
        return NULL;
    
    CGFloat ratio = 0;
    ratio = maskImage.size.width/ image.size.width;
    if(ratio * image.size.height < maskImage.size.height) {
        ratio = maskImage.size.height/ image.size.height;
    }
    
    CGRect rect1 = {{0, 0}, {maskImage.size.width, maskImage.size.height}};
    CGRect rect2  = {{-((image.size.width*ratio)-maskImage.size.width)/2,-((image.size.height*ratio)-maskImage.size.height)/2},{image.size.width*ratio, image.size.height*ratio}};
    
    CGContextClipToMask(mainViewContentContext, rect1, maskImageRef);
    CGContextDrawImage(mainViewContentContext, rect2, image.CGImage);
    
    CGImageRef newImage = CGBitmapContextCreateImage(mainViewContentContext);
    CGContextRelease(mainViewContentContext);
    
    UIImage *theImage = [UIImage imageWithCGImage:newImage];
    CGImageRelease(newImage);
    return theImage;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



-(void)customNavigation:(UINavigationController *)nav
{
    for (id view in [nav.view subviews])
    {
        //NSLog(@"View : %@",[view description]);
        if ([view isKindOfClass:[UINavigationBar class]])
        {
            for (id view1 in [(UINavigationBar *)view subviews])
            {
                UIView *v=(UIView *)view1;
                v.backgroundColor=[UIColor clearColor];
                
                for (id sub in [(UIView *)view1 subviews])
                {
                    UIImageView *img=(UIImageView *)sub;
                    img.contentMode=UIViewContentModeScaleAspectFit;
                }
            }
        }
        else
        {
            UIView *v=(UIView *)view;
            //v.frame=CGRectMake(0, -3, 320, 436);
            v.backgroundColor=[UIColor clearColor];
        }
    }
    
    //nav.view.backgroundColor=[UIColor clearColor];
    
    nav.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor colorWithRed:234.0/255.0 green:161.0/255.0 blue:84.0/255.0 alpha:1.0],[UIFont boldSystemFontOfSize:20.0],[UIColor colorWithRed:248.0/255.0 green:203.0/255.0 blue:156.0/255.0 alpha:1.0], nil] forKeys:[NSArray arrayWithObjects:UITextAttributeTextColor,UITextAttributeFont,UITextAttributeTextShadowColor, nil]];
    
    nav.navigationBar.backgroundColor = [UIColor clearColor];
    UIImage *image = [UIImage imageNamed:@"navBar.png"];
    [nav.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}
-(IBAction)infoButtonClick:(id)sender
{
    InfoViewController *vc = [[InfoViewController alloc] init];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];

}


//CGFloat faceWidth = face1.bounds.size.width;
//UIView* leftEyeView = [[UIView alloc] initWithFrame:CGRectMake(face1.leftEyePosition.x-faceWidth*0.15, face1.leftEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
//// change the background color of the eye view
//[leftEyeView setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
//// set the position of the leftEyeView based on the face
//[leftEyeView setCenter:face1.leftEyePosition];
//// round the corners
//leftEyeView.layer.cornerRadius = faceWidth*0.15;
//// add the view to the window
//[self.view addSubview:leftEyeView];
//
//UIView* leftEyeView1 = [[UIView alloc] initWithFrame:CGRectMake(face1.rightEyePosition.x-faceWidth*0.15, face1.rightEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
//// change the background color of the eye view
//[leftEyeView1 setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
//// set the position of the leftEyeView based on the face
//[leftEyeView1 setCenter:face1.rightEyePosition];
//// round the corners
//leftEyeView1.layer.cornerRadius = faceWidth*0.15;
//// add the view to the window
//[self.view addSubview:leftEyeView1];

@end

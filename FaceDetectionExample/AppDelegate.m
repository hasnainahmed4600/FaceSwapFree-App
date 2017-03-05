//
//  AppDelegate.m
//  FaceDetectionExample
//
//  Created by Johann Dowa on 11-11-01.
//  Copyright (c) 2011 ManiacDev.Com All rights reserved.
//
//  "Monster Face" Image by Tobyotter on Flickr

#import "UIImage+Alpha.h"
#import <CoreImage/CoreImage.h>
#import <CoreImage/CoreImage.h>
#import <CoreImage/CIImage.h>
#import <QuartzCore/QuartzCore.h>
#import "UIImage+RoundedCorner.h"

#import "AppDelegate.h"

#import "ViewController.h"
#import <Crashlytics/Crashlytics.h>

@import GoogleMobileAds;

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:self.viewController];
    nav.navigationBarHidden=YES;
  
    //STAStartAppSDK* sdk = [STAStartAppSDK sharedInstance];
    //sdk.appID = @"204843570";
    //sdk.devID = @"104808420";

    //[sdk showSplashAd];  // display the splash screen
    //[STAStartAppAdBasic showAd];

     //[Fabric with:@[[Crashlytics class]]];

    self.window.rootViewController =nav;
    [self.window makeKeyAndVisible];
    //[self faceDetector]; // execute the faceDetector code
    
    [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}




-(UIImage *)rotateImage:(UIImage *)img
{
    //return img;
    UIGraphicsBeginImageContext(img.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, +(img.size.width * 0.5f), +(img.size.height * 0.5f));
    CGContextRotateCTM (context,90.0*3.14/180.0);
        
    //[img drawAtPoint:CGPointMake(-50, -100)];
    [img drawInRect:CGRectMake(-img.size.width/2,-img.size.height/2, img.size.width,img.size.height)];
    return UIGraphicsGetImageFromCurrentImageContext();
}
-(float)degree
{
    return 3.14*90.0/180.0;
}
- (UIImage*)upsideDownBunny:(CGFloat)radians withImage:(UIImage*)testImage {
    __block CGImageRef cgImg;
    __block CGSize imgSize;
    __block UIImageOrientation orientation;
    dispatch_block_t createStartImgBlock = ^(void) {
        // UIImages should only be accessed from the main thread
        
        UIImage *img =testImage;
        imgSize = [img size]; // this size will be pre rotated
        orientation = [img imageOrientation];
        cgImg = CGImageRetain([img CGImage]); // this data is not rotated
    };
    if([NSThread isMainThread]) {
        createStartImgBlock();
    } else {
        dispatch_sync(dispatch_get_main_queue(), createStartImgBlock);
    }
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    // in iOS4+ you can let the context allocate memory by passing NULL
    CGContextRef context = CGBitmapContextCreate( NULL,
                                                 imgSize.width,
                                                 imgSize.height,
                                                 8,
                                                 imgSize.width * 4,
                                                 colorspace,
                                                 kCGImageAlphaPremultipliedLast);
    // rotate so the image respects the original UIImage's orientation
    switch (orientation) {
        case UIImageOrientationDown:
            CGContextTranslateCTM(context, imgSize.width, imgSize.height);
            CGContextRotateCTM(context, -radians);
            break;
        case UIImageOrientationLeft:
            CGContextTranslateCTM(context, 0.0, imgSize.height);
            CGContextRotateCTM(context, 3.0 * -radians / 2.0);
            break;
        case UIImageOrientationRight:
            CGContextTranslateCTM(context,imgSize.width, 0.0);
            CGContextRotateCTM(context, -radians / 2.0);
            break;
        default:
            // there are mirrored modes possible
            // but they aren't generated by the iPhone's camera
            break;
    }
    // rotate the image upside down
    
    CGContextTranslateCTM(context, +(imgSize.width * 0.5f), +(imgSize.height * 0.5f));
    CGContextRotateCTM(context, -radians);
    //CGContextDrawImage( context, CGRectMake(0.0, 0.0, imgSize.width, imgSize.height), cgImg );
    CGContextDrawImage(context, (CGRect){.origin.x = -imgSize.width* 0.5f , .origin.y = -imgSize.width* 0.5f , .size.width = imgSize.width, .size.height = imgSize.width}, cgImg);
    // grab the new rotated image
    CGContextFlush(context);
    CGImageRef newCgImg = CGBitmapContextCreateImage(context);
    __block UIImage *newImage;
    dispatch_block_t createRotatedImgBlock = ^(void) {
        // UIImages should only be accessed from the main thread
        newImage = [UIImage imageWithCGImage:newCgImg];
    };
    if([NSThread isMainThread]) {
        createRotatedImgBlock();
    } else {
        dispatch_sync(dispatch_get_main_queue(), createRotatedImgBlock);
    }
    CGColorSpaceRelease(colorspace);
    CGImageRelease(newCgImg);
    CGContextRelease(context);
    return newImage;
}

/*
 -(void)markFaces:(UIImageView *)facePicture
 {
 
 CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
 
 context:nil
 
 options:nil];
 CIImage *image=[CIImage imageWithCGImage:[UIImage imageNamed:@"m(01-32)_gr.jpg"].CGImage];
 NSArray *faceArray = [detector featuresInImage:image options:nil];
 
 
 
 // Create a green circle to cover the rects that are returned.
 
 
 
 CIImage *maskImage =nil;
 
 
 
 for (CIFeature *f in faceArray){
 
 CGFloat radius = MIN([f bounds].size.width, [f bounds].size.height)/1.5;
 
 CIColor* cc0 = [CIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:1.0];
 CIColor* cc1 = [CIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
 CIVector *cen = [CIVector vectorWithX:f.bounds.origin.x+f.bounds.size.width/2.0 Y:f.bounds.origin.y+f.bounds.size.height/2.0];
 
 CIFilter* filter = [CIFilter filterWithName:@"CIRadialGradient"];
 [filter setDefaults];
 [filter setValue:cen forKey:@"inputCenter"];
 [filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius0"];
 [filter setValue:[NSNumber numberWithFloat:radius+5.0f] forKey:@"inputRadius1"];
 [filter setValue:cc0 forKey:@"inputColor0"];
 [filter setValue:cc1 forKey:@"inputColor1"];
 
 CIImage* outputImage = [filter valueForKey:@"outputImage"];
 
 
 //        CGRect newRect=[self flipRect:f.bounds Bound:facePicture.bounds];
 //        CGImageRef imageRef = CGImageCreateWithImageInRect([UIImage imageNamed:@"m(01-32)_gr.jpg"].CGImage, newRect);
 //        UIImage *img = [UIImage imageWithCGImage:imageRef];
 
 CGImageRef moi3 = [[CIContext contextWithOptions:nil] createCGImage:filter.outputImage
 fromRect:outputImage.extent];
 UIImage *moi4 = [UIImage imageWithCGImage:moi3];
 CGImageRelease(moi3);
 UIImageView *img11=[[UIImageView alloc] initWithImage:moi4];
 img11.frame=CGRectMake(0, 0, 300, 300);
 [self.window addSubview:img11];
 
 }
 
 
 
 //   CIImage* image = [CIImage imageWithCGImage:facePicture.image.CGImage];
 //
 //
 //   // CIImage* image = [CIImage imageWithCGImage:facePicture.image.CGImage];
 //
 //    // create a face detector - since speed is not an issue we'll use a high accuracy
 //    // detector
 //    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
 //                                              context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
 //
 ////    UIImage *uiImage = [UIImage imageNamed:@"test"];
 ////    CIImage *ciImage = [[CIImage alloc] initWithImage:uiImage];
 //   // NSArray *features = [detector featuresInImage:ciImage];
 //
 //    NSArray* features = [detector featuresInImage:image];
 //
 //   // for(CIFaceFeature* f in features)
 //   // {
 //    CIFaceFeature *f=[features objectAtIndex:0];
 //
 //    CGFloat xCenter = f.bounds.origin.x + f.bounds.size.width/2.0;
 //
 //    CGFloat yCenter = f.bounds.origin.y + f.bounds.size.height/2.0;
 //    NSLog(@"X center : %f",xCenter);
 //    NSLog(@"Y center : %f",yCenter);
 //        CIVector *cen = [CIVector vectorWithX:xCenter Y:yCenter];
 //
 //        CGFloat radius = MIN([f bounds].size.width, [f bounds].size.height)/1.5;
 //    NSLog(@"radius : %@",[NSNumber numberWithFloat:radius]);
 //
 //        CIFilter *radialGradient = [CIFilter filterWithName:@"CIRadialGradient" keysAndValues:
 //
 //                                    @"inputRadius0", [NSNumber numberWithFloat:radius],
 //                                    @"inputRadius1", [NSNumber numberWithFloat:f.bounds.size.height + 50],
 //                                    @"inputColor0", [CIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0],
 //                                    @"inputColor1", [CIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0],@"inputCenter",cen, nil];
 //
 //        CIImage *circleImage = [radialGradient valueForKey:kCIOutputImageKey];
 //
 //        CIImage *maskImage = [[CIFilter filterWithName:@"CISourceOverCompositing" keysAndValues:
 //
 //                      kCIInputImageKey, circleImage, kCIInputBackgroundImageKey, image,
 //
 //                      nil] valueForKey:kCIOutputImageKey];
 //
 //        UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageWithCIImage:maskImage]];
 //        img.frame=CGRectMake(0, 0, 200, 200);
 //        [self.window addSubview:img];
 
 //        NSLog(@"X : %f",faceFeature.bounds.origin.x);
 //        NSLog(@"Y : %f",faceFeature.bounds.origin.y);
 //        // get the width of the face
 //        CGFloat faceWidth = faceFeature.bounds.size.width;
 //
 //        // create a UIView using the bounds of the face
 //        UIView* faceView = [[UIView alloc] initWithFrame:faceFeature.bounds];
 //
 //        // add a border around the newly created UIView
 //        faceView.layer.borderWidth = 1;
 //        faceView.layer.borderColor = [[UIColor redColor] CGColor];
 //
 //        // add the new view to create a box around the face
 //        [self.window addSubview:faceView];
 //
 //        if(faceFeature.hasLeftEyePosition)
 //        {
 //            // create a UIView with a size based on the width of the face
 //            UIView* leftEyeView = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.leftEyePosition.x-faceWidth*0.15, faceFeature.leftEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
 //            // change the background color of the eye view
 //            [leftEyeView setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
 //            // set the position of the leftEyeView based on the face
 //            [leftEyeView setCenter:faceFeature.leftEyePosition];
 //            // round the corners
 //            leftEyeView.layer.cornerRadius = faceWidth*0.15;
 //            // add the view to the window
 //            [self.window addSubview:leftEyeView];
 //
 //           CGRect rect=CGRectMake(faceFeature.leftEyePosition.x-faceWidth*0.15 , faceFeature.mouthPosition.y-faceWidth*0.2, (faceFeature.rightEyePosition.x-faceWidth*0.15)+(faceWidth*0.3)-(faceFeature.leftEyePosition.x-faceWidth*0.15) ,(faceFeature.leftEyePosition.y-faceWidth*0.15)+(faceWidth*0.3)-(faceFeature.mouthPosition.y-faceWidth*0.2));
 //
 //            // create a UIView with a size based on the width of the face
 //            UIView* leftEye = [[UIView alloc] initWithFrame:rect];
 //            // change the background color of the eye view
 //            [leftEye setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
 //
 //            [self.window addSubview:leftEye];
 //
 //        }
 //
 //
 //
 //
 //
 //        if(faceFeature.hasRightEyePosition)
 //        {
 //            // create a UIView with a size based on the width of the face
 //            UIView* leftEye = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.rightEyePosition.x-faceWidth*0.15, faceFeature.rightEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
 //            // change the background color of the eye view
 //            [leftEye setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
 //            // set the position of the rightEyeView based on the face
 //            [leftEye setCenter:faceFeature.rightEyePosition];
 //            // round the corners
 //            leftEye.layer.cornerRadius = faceWidth*0.15;
 //            // add the new view to the window
 //            [self.window addSubview:leftEye];
 //        }
 //
 //        if(faceFeature.hasMouthPosition)
 //        {
 //            NSLog(@"mouth position x = %f , y = %f", faceFeature.mouthPosition.x, faceFeature.mouthPosition.y);
 //
 //            // create a UIView with a size based on the width of the face
 //            UIView* mouth = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.mouthPosition.x-faceWidth*0.2, faceFeature.mouthPosition.y-faceWidth*0.2, faceWidth*0.4, faceWidth*0.4)];
 //            // change the background color for the mouth to green
 //            [mouth setBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.3]];
 //            // set the position of the mouthView based on the face
 //            [mouth setCenter:faceFeature.mouthPosition];
 //            // round the corners
 //            mouth.layer.cornerRadius = faceWidth*0.2;
 //            // add the new view to the window
 //            [self.window addSubview:mouth];
 //        }
 //
 //}
 
 //    UIImage* flippedImage = [UIImage imageWithCGImage:facePicture.image.CGImage
 //                                                scale:1.0 orientation: UIImageOrientationDownMirrored];
 //    UIImageView* image1 = [[UIImageView alloc] initWithImage:flippedImage];
 //    [self.window addSubview:image1];
 }
 
 
 */
/*
 -(void)markFaces:(UIImageView *)facePicture
 {
 // draw a CI image with the previously loaded face detection picture
 CIImage* image = [CIImage imageWithCGImage:facePicture.image.CGImage];
 
 CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
 context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
 
 // create an array containing all the detected faces from the detector
 NSArray* features = [detector featuresInImage:image];
 
 
 if(features.count>=2)
 {
 CIFaceFeature *face1=[features objectAtIndex:0];
 CIFaceFeature *face2=[features objectAtIndex:1];
 
 CGFloat faceWidth1 = face1.bounds.size.width;
 CGFloat faceWidth2 = face2.bounds.size.width;
 
 CGRect rect;
 if(face1.hasLeftEyePosition)
 {
 
 
 rect=CGRectMake(face1.leftEyePosition.x-faceWidth1*0.15, face1.mouthPosition.y-faceWidth1*0.2 , (face1.rightEyePosition.x-faceWidth1*0.15)+(faceWidth1*0.3)-(face1.leftEyePosition.x-faceWidth1*0.15) , (face1.leftEyePosition.y-faceWidth1*0.15)+(faceWidth1*0.3)-(face1.mouthPosition.y-faceWidth1*0.2));
 
 }
 
 CGRect rect1=face2.bounds;
 
 if (face2.hasLeftEyePosition) {
 
 rect1=CGRectMake(face2.leftEyePosition.x-faceWidth2*0.15, face2.mouthPosition.y-faceWidth2*0.2 , (face2.rightEyePosition.x-faceWidth2*0.15)+(faceWidth2*0.3)-(face2.leftEyePosition.x-faceWidth2*0.15) , (face2.leftEyePosition.y-faceWidth2*0.15)+(faceWidth2*0.3)-(face2.mouthPosition.y-faceWidth2*0.2));
 }
 
 
 UIImage *image = facePicture.image;
 // CGRect rect=face1.bounds;
 CGRect newRect=[self flipRect:rect Bound:facePicture.bounds];
 CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], newRect);
 UIImage *img = [UIImage imageWithCGImage:imageRef];
 CGImageRelease(imageRef);
 
 
 //CGRect rect1=face2.bounds;
 CGRect newRect1=[self flipRect:rect1 Bound:facePicture.bounds];
 CGImageRef imageRef1 = CGImageCreateWithImageInRect([image CGImage], newRect1);
 UIImage *img1 = [UIImage imageWithCGImage:imageRef1];
 CGImageRelease(imageRef1);
 
 CGSize offScreenSize=image.size;
 UIGraphicsBeginImageContext(offScreenSize);
 
 [image  drawInRect:CGRectMake(0, 0,offScreenSize.width, offScreenSize.height)];
 [img drawInRect:newRect1];
 [img1 drawInRect:newRect];
 //[img1 roundedCornerImage:img1.size.height/5 borderSize:0]
 UIImage* imagez = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 
 // UIImage *imagez=[self mergeTwoImages:img1 img:image img1:img rect:newRect rect1:newRect1];
 
 UIImageView* imageView = [[UIImageView alloc] initWithImage:imagez];
 [self.window addSubview:imageView];
 
 }
 }
 */
-(CGRect)flipRect:(CGRect)rect Bound:(CGRect)bounds
{
    return CGRectMake(CGRectGetMinX(rect),
                      CGRectGetMaxY(bounds)-CGRectGetMaxY(rect),
                      CGRectGetWidth(rect),
                      CGRectGetHeight(rect));
}

//CGRect CGRectFlipped(CGRect rect, CGRect bounds) {
//    return CGRectMake(CGRectGetMinX(rect),
//                      CGRectGetMaxY(bounds)-CGRectGetMaxY(rect),
//                      CGRectGetWidth(rect),
//                      CGRectGetHeight(rect));
//}
-(void)faceDetector
{
    
    
    facePicture = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img3.jpg"]];
    // image.frame=CGRectMake(0, 0, 320, 480);
    // UIImageView* image = [[UIImageView alloc] initWithImage:[self radialGradientImage:CGRectMake(0, 0, 300, 300)]];
    // image.backgroundColor=[UIColor clearColor];
    
    [self.window addSubview:facePicture];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(aMethod:)
     forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Exchange Face" forState:UIControlStateNormal];
    button.frame = CGRectMake(80.0, 400,170, 40.0);
    [self.window addSubview:button];
    
    
    // Execute the method used to markFaces in background
    // [self performSelectorInBackground:@selector(markFaces:) withObject:image];
    
    // [image setTransform:CGAffineTransformMakeScale(1, -1)];
    // [self.window setTransform:CGAffineTransformMakeScale(1, -1)];
}
-(IBAction)aMethod:(id)sender
{
    NSMutableArray *p = [NSMutableArray array];
    
    CIImage* image = [CIImage imageWithCGImage:facePicture.image.CGImage];
    
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    
    // create an array containing all the detected faces from the detector
    NSArray* features = [detector featuresInImage:image];
    
    
    if(features.count>=2)
    {
        CIFaceFeature *face1=[features objectAtIndex:0];
        CIFaceFeature *face2=[features objectAtIndex:1];
        
        
        //CGRect rect1=CGRectMake(face2.leftEyePosition.x-faceWidth2*0.15, face2.mouthPosition.y-faceWidth2*0.2 , (face2.rightEyePosition.x-faceWidth2*0.15)+(faceWidth2*0.3)-(face2.leftEyePosition.x-faceWidth2*0.15) , (face2.leftEyePosition.y-faceWidth2*0.15)+(faceWidth2*0.3)-(face2.mouthPosition.y-faceWidth2*0.2));
        
        CGFloat faceWidth1 = face1.bounds.size.width;
        CGFloat faceWidth2 = face2.bounds.size.width;
        
        
        CGRect rectOne=CGRectMake(face1.leftEyePosition.x-faceWidth1*0.15, face1.mouthPosition.y-faceWidth1*0.2 , (face1.rightEyePosition.x-faceWidth1*0.15)+(faceWidth1*0.3)-(face1.leftEyePosition.x-faceWidth1*0.15) , (face1.leftEyePosition.y-faceWidth1*0.15)+(faceWidth1*0.3)-(face1.mouthPosition.y-faceWidth1*0.2));
        CGRect newRect=[self flipRect:rectOne Bound:facePicture.bounds];
        
        // CGPoint point=CGPointMake(face1.leftEyePosition.x-faceWidth1*0.15,face1.leftEyePosition.y - faceWidth1*0.15);
        [p addObject:[NSValue valueWithCGPoint:newRect.origin]];
        CGPoint point1=CGPointMake(face1.mouthPosition.x-faceWidth1*0.2,newRect.origin.y+newRect.size.height);
        [p addObject:[NSValue valueWithCGPoint:point1]];
        
        CGPoint point2=CGPointMake((face1.mouthPosition.x-faceWidth1*0.2)+(faceWidth1*0.4),newRect.origin.y+newRect.size.height);
        [p addObject:[NSValue valueWithCGPoint:point2]];
        
        CGPoint point3=CGPointMake(newRect.origin.x + newRect.size.width,newRect.origin.y);
        [p addObject:[NSValue valueWithCGPoint:point3]];
        
        
        CGRect rect =CGRectZero;
        rect.size =facePicture.image.size;
        
        UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0);
        
        {
            [[UIColor blackColor] setFill];
            UIRectFill(rect);
            [[UIColor whiteColor] setFill];
            
            UIBezierPath *aPath = [UIBezierPath bezierPath];
            
            // Set the starting point of the shape.
            CGPoint p1 = [self convertCGPoint:[[p objectAtIndex:0] CGPointValue] fromRect1:facePicture.frame.size toRect2:facePicture.image.size];
            [aPath moveToPoint:CGPointMake(p1.x, p1.y)];
            //[aPath moveToPoint:[[p objectAtIndex:0] CGPointValue]];
            
            for (uint i=1; i<p.count; i++)
            {
                CGPoint p1 = [self convertCGPoint:[[p objectAtIndex:i] CGPointValue] fromRect1:facePicture.frame.size toRect2:facePicture.image.size];
                [aPath addLineToPoint:CGPointMake(p1.x, p1.y)];
                //[aPath moveToPoint:[[p objectAtIndex:i] CGPointValue]];
            }
            [aPath closePath];
            [aPath fill];
        }
        
        UIImage *mask = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
        
        {
            CGContextClipToMask(UIGraphicsGetCurrentContext(), rect, mask.CGImage);
            [facePicture.image drawAtPoint:CGPointZero];
        }
        
        UIImage *maskedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CGImageRef imageRef = CGImageCreateWithImageInRect([maskedImage CGImage], newRect);
        UIImage *img = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        
        UIImage *image = facePicture.image;
        CGRect rect1=CGRectMake(face2.leftEyePosition.x-faceWidth2*0.15, face2.mouthPosition.y-faceWidth2*0.2 , (face2.rightEyePosition.x-faceWidth2*0.15)+(faceWidth2*0.3)-(face2.leftEyePosition.x-faceWidth2*0.15) , (face2.leftEyePosition.y-faceWidth2*0.15)+(faceWidth2*0.3)-(face2.mouthPosition.y-faceWidth2*0.2));
        
        CGSize offScreenSize=image.size;
        
        
        UIGraphicsBeginImageContext(offScreenSize);
        CGRect newRect1=[self flipRect:rect1 Bound:facePicture.bounds];
        [image  drawInRect:CGRectMake(0, 0,offScreenSize.width, offScreenSize.height)];
        [[img roundedCornerImage:img.size.height/5 borderSize:0] drawInRect:newRect1];
        // [img1 drawInRect:newRect];
        //[img1 roundedCornerImage:img1.size.height/5 borderSize:0]
        UIImage* imagez = UIGraphicsGetImageFromCurrentImageContext();
        [imagez roundedCornerImage:imagez.size.height/5 borderSize:0];
        UIGraphicsEndImageContext();
        
        facePicture.image=imagez;
        //        CGRect rect;
        //        if(face1.hasLeftEyePosition)
        //        {
        //
        //
        //            rect=CGRectMake(face1.leftEyePosition.x-faceWidth1*0.15, face1.mouthPosition.y-faceWidth1*0.2 , (face1.rightEyePosition.x-faceWidth1*0.15)+(faceWidth1*0.3)-(face1.leftEyePosition.x-faceWidth1*0.15) , (face1.leftEyePosition.y-faceWidth1*0.15)+(faceWidth1*0.3)-(face1.mouthPosition.y-faceWidth1*0.2));
        //
        //        }
        //
        //        CGRect rect1=face2.bounds;
        //
        //        if (face2.hasLeftEyePosition) {
        //
        //            rect1=CGRectMake(face2.leftEyePosition.x-faceWidth2*0.15, face2.mouthPosition.y-faceWidth2*0.2 , (face2.rightEyePosition.x-faceWidth2*0.15)+(faceWidth2*0.3)-(face2.leftEyePosition.x-faceWidth2*0.15) , (face2.leftEyePosition.y-faceWidth2*0.15)+(faceWidth2*0.3)-(face2.mouthPosition.y-faceWidth2*0.2));
        //        }
        //
        //
        //        UIImage *image = facePicture.image;
        //        // CGRect rect=face1.bounds;
        //        CGRect newRect=[self flipRect:rect Bound:facePicture.bounds];
        //        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], newRect);
        //        UIImage *img = [UIImage imageWithCGImage:imageRef];
        //        CGImageRelease(imageRef);
        //
        //
        //        //CGRect rect1=face2.bounds;
        //        CGRect newRect1=[self flipRect:rect1 Bound:facePicture.bounds];
        //        CGImageRef imageRef1 = CGImageCreateWithImageInRect([image CGImage], newRect1);
        //        UIImage *img1 = [UIImage imageWithCGImage:imageRef1];
        //        CGImageRelease(imageRef1);
        //
        //        CGSize offScreenSize=image.size;
        //
        //
        //        UIGraphicsBeginImageContext(offScreenSize);
        //
        //        [image  drawInRect:CGRectMake(0, 0,offScreenSize.width, offScreenSize.height)];
        //        [img drawInRect:newRect1];
        //        [img1 drawInRect:newRect];
        //        //[img1 roundedCornerImage:img1.size.height/5 borderSize:0]
        //        UIImage* imagez = UIGraphicsGetImageFromCurrentImageContext();
        //        UIGraphicsEndImageContext();
        //
        //        // UIImage *imagez=[self mergeTwoImages:img1 img:image img1:img rect:newRect rect1:newRect1];
        //        facePicture.image=imagez;
        //        //UIImageView* imageView = [[UIImageView alloc] initWithImage:imagez];
        //        //[self.window addSubview:imageView];
        
    }
    
}
- (CGPoint)convertCGPoint:(CGPoint)point1 fromRect1:(CGSize)rect1 toRect2:(CGSize)rect2
{
    point1.y = rect1.height - point1.y;
    CGPoint result = CGPointMake((point1.x*rect2.width)/rect1.width, (point1.y*rect2.height)/rect1.height);
    return result;
}



@end

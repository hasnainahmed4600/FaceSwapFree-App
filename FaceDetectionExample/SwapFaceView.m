//
//  SwapFaceView.m
//  FaceDetectionExample
//
//  Created by Alpesh3 on 7/8/13.
//  Copyright (c) 2013 JID Marketing. All rights reserved.
//
#import "UIImage+Resize.h"
#import "SwapFaceView.h"

@interface SwapFaceView ()
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imageView1;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imageView2;
@property (nonatomic, retain) UIDocumentInteractionController *documentController;
@end

@implementation SwapFaceView
@synthesize image11;
@synthesize features;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageView.image=image11;
    swaped=NO;
    //imageView.frame=CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y,image11.size.width, image11.size.height);
    self.bannerView.adUnitID = @"ca-app-pub-5838027022031261/6783938434";
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
    
  //  [NSTimer scheduledTimerWithTimeInterval:30.f target:self selector:@selector(showCustomBanner) userInfo:nil repeats:NO];
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

//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

-(IBAction)swapButtonClick:(id)sender
{
    if (swaped) {
        imageView.image=image11;
        self.imageView1.image = nil;
        self.imageView2.image = nil;
        swaped=NO;
    }
    else
    {
//        CIImage* image = [CIImage imageWithCGImage:imageView.image.CGImage];
//        
//        CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
//                                                  context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
//        NSArray* features = [detector featuresInImage:image];
        
        if (features.count>1)
        {
            
            CIFaceFeature *face1=[features objectAtIndex:0];
            CIFaceFeature *face2=[features objectAtIndex:1];
            
            //crop image for face 1 
            CGRect rect1=[self flipRect:face1.bounds Bound:CGRectMake(0, 0,imageView.image.size.width, imageView.image.size.height)];//imageView.bounds];
            
            CGImageRef imageRef = CGImageCreateWithImageInRect([imageView.image CGImage], rect1);
            UIImage *img = [UIImage imageWithCGImage:imageRef];
            CGImageRelease(imageRef);
            //img=[self rotateLeft:img];
           //crop image for face 1
            CGRect rect2=[self flipRect:face2.bounds Bound:CGRectMake(0, 0,imageView.image.size.width, imageView.image.size.height)];//imageView.bounds];
            
            CGImageRef imageRef1 = CGImageCreateWithImageInRect([imageView.image CGImage], rect2);
            UIImage *img1 = [UIImage imageWithCGImage:imageRef1];
            CGImageRelease(imageRef1);
           // img1=[self rotateLeft:img1];
            // find radians for face 1
            float radians = atan2((CGRectGetMaxY(CGRectMake(0, 0,imageView.image.size.width, imageView.image.size.height))-face1.rightEyePosition.y) - (CGRectGetMaxY(CGRectMake(0, 0,imageView.image.size.width, imageView.image.size.height))-face1.leftEyePosition.y) , face1.rightEyePosition.x - face1.leftEyePosition.x);
            
            // find radians for face 2                        
            float radians1 = atan2((CGRectGetMaxY(CGRectMake(0, 0,imageView.image.size.width, imageView.image.size.height))-face2.rightEyePosition.y) - (CGRectGetMaxY(CGRectMake(0, 0,imageView.image.size.width, imageView.image.size.height))-face2.leftEyePosition.y) , face2.rightEyePosition.x - face2.leftEyePosition.x);
            
            // mast image for face 1
            UIImage *rowMask=[self rotateImage:radians image:[[UIImage imageNamed:@"mask_image.png"] resizedImage:img.size interpolationQuality:kCGInterpolationDefault]];
            //rowMask=[self rotateLeft:rowMask];
            UIImage *getMaskedImage1=[self maskImage:img withMaskImage:rowMask];
            UIImage *maskImage1=[self rotateImage:-radians image:getMaskedImage1];
            
            //mask image for face 2
            UIImage *rowMask1=[self rotateImage:radians1 image:[[UIImage imageNamed:@"mask_image.png"] resizedImage:img1.size interpolationQuality:kCGInterpolationDefault]];
            //rowMask1=[self rotateLeft:rowMask1];
            UIImage *getMaskedImage2=[self maskImage:img1 withMaskImage:rowMask1];
            UIImage *maskImage2=[self rotateImage:-radians1 image:getMaskedImage2];
            
            UIImage *final1=[self rotateImage:radians1 image:maskImage1];
            UIImage *final2=[self rotateImage:radians image:maskImage2];
            CGSize offScreenSize=imageView.image.size;
            
            CGSize frameSize = imageView.frame.size;
            float   xrate = frameSize.width/offScreenSize.width;
            float   yrate = frameSize.height/offScreenSize.height;
            
            float rate = xrate > yrate ? yrate : xrate;
            float xPos = (frameSize.width - offScreenSize.width * rate)/2 + imageView.frame.origin.x;
            float yPos = (frameSize.height - offScreenSize.height * rate)/2 + imageView.frame.origin.y;
            
            // get final image with face swaped
            self.imageView2.image = final2;
            
            CGRect frame1 = CGRectMake(xPos + rect1.origin.x*rate, yPos + rect1.origin.y*rate, rect1.size.width*rate, rect1.size.height*rate);
            CGRect frame2 = CGRectMake(xPos + rect2.origin.x*rate, yPos + rect2.origin.y*rate, rect2.size.width*rate, rect2.size.height*rate);
            self.imageView2.frame = frame2;
            self.imageView1.image = final1;
            self.imageView1.frame = frame1;
            
            [UIView animateWithDuration:3.f animations:^{
                self.imageView1.frame = frame2;
                self.imageView2.frame = frame1;
                
            }];

            UIGraphicsBeginImageContext(offScreenSize);
            
            // get final image with face swaped
            [imageView.image  drawInRect:CGRectMake(0, 0,offScreenSize.width, offScreenSize.height)];
            [final1 drawInRect:rect2];
            [final2 drawInRect:rect1];
            
//            [[self rotateLeft:img] drawInRect:rect2];
//            [[self rotateLeft:img1] drawInRect:rect1];
            
            UIImage* imagez = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            imageView.image=imagez;
           
            
            swaped=YES;
            
        }
        else
        {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Two Or more face needed for swapping" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }

}
- (UIImage*) maskImage:(UIImage *)image1 withMaskImage:(UIImage*)maskImage {
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef maskImageRef = [maskImage CGImage];
    
    CGContextRef mainViewContentContext = CGBitmapContextCreate (NULL, maskImage.size.width, maskImage.size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    
    if (mainViewContentContext==NULL)
        return NULL;
    
    CGFloat ratio = 0;
    ratio = maskImage.size.width/ image1.size.width;
    if(ratio * image1.size.height < maskImage.size.height) {
        ratio = maskImage.size.height/ image1.size.height;
    }
    
    CGRect rect1 = {{0, 0}, {maskImage.size.width, maskImage.size.height}};
    CGRect rect2  = {{-((image1.size.width*ratio)-maskImage.size.width)/2,-((image1.size.height*ratio)-maskImage.size.height)/2},{image1.size.width*ratio, image1.size.height*ratio}};
    
    CGContextClipToMask(mainViewContentContext, rect1, maskImageRef);
    CGContextDrawImage(mainViewContentContext, rect2, image1.CGImage);
    
    CGImageRef newImage = CGBitmapContextCreateImage(mainViewContentContext);
    CGContextRelease(mainViewContentContext);
    
    UIImage *theImage = [UIImage imageWithCGImage:newImage];
    CGImageRelease(newImage);
    return theImage;
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
-(UIImage *)rotateLeft:(UIImage *)image
{
    int i=image.imageOrientation;
    NSLog(@"Image : %d",i);
    CGContextRef context = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    
    CGAffineTransform transform; //flipTransform = CGAffineTransformMake(-1.0, 0.0, 0.0, 1.0, image.size.width, 0.0);
    float width=image.size.width;
    float height=image.size.height;
    switch(i) {
        case UIImageOrientationDown:		// 0th row is at the bottom, and 0th column is on the right - Rotate 180 degrees
            transform = CGAffineTransformMake(-1.0, 0.0, 0.0, -1.0, width, height);
            break;
            
        case UIImageOrientationLeft:		// 0th row is on the left, and 0th column is the bottom - Rotate -90 degrees
            transform = CGAffineTransformMake(0.0, 1.0, -1.0, 0.0, height, 0.0);
            break;
            
        case UIImageOrientationRight:		// 0th row is on the right, and 0th column is the top - Rotate 90 degrees
            transform = CGAffineTransformMake(0.0, -1.0, 1.0, 0.0, 0.0, width);
            break;
            
        case UIImageOrientationUpMirrored:	// 0th row is at the top, and 0th column is on the right - Flip Horizontal
            transform = CGAffineTransformMake(-1.0, 0.0, 0.0, 1.0, width, 0.0);
            break;
            
        case UIImageOrientationDownMirrored:	// 0th row is at the bottom, and 0th column is on the left - Flip Vertical
            transform = CGAffineTransformMake(1.0, 0.0, 0, -1.0, 0.0, height);
            break;
            
        case UIImageOrientationLeftMirrored:	// 0th row is on the left, and 0th column is the top - Rotate -90 degrees and Flip Vertical
            transform = CGAffineTransformMake(0.0, -1.0, -1.0, 0.0, height, width);
            break;
            
        case UIImageOrientationRightMirrored:	// 0th row is on the right, and 0th column is the bottom - Rotate 90 degrees and Flip Vertical
            transform = CGAffineTransformMake(0.0, 1.0, 1.0, 0.0, 0.0, 0.0);
            break;
            
        default:
           // mustTransform = NO;
            break;
    }

    

    CGContextConcatCTM(context, transform);
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    
    CGImageRef cgimg = CGBitmapContextCreateImage(context);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(context);
    CGImageRelease(cgimg);

    return img;
}

- (UIImage *)fixrotation:(UIImage *)image orientation:(UIImage *)ortImage{
    
    
    if (image.imageOrientation == UIImageOrientationUp)
    {
        return image;
    }
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (ortImage.imageOrientation) {
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
    
    switch (ortImage.imageOrientation) {
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
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (ortImage.imageOrientation) {
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


- (UIImageOrientation)orientationFromEXIF:(int)exif
{
    UIImageOrientation newOrientation;
    switch (exif)
    {
        case 1:
            newOrientation = UIImageOrientationUp;
            break;
        case 3:
            newOrientation = UIImageOrientationDown;
            break;
        case 8:
            newOrientation = UIImageOrientationLeft;
            break;
        case 6:
            newOrientation = UIImageOrientationRight;
            break;
        case 2:
            newOrientation = UIImageOrientationUpMirrored;
            break;
        case 4:
            newOrientation = UIImageOrientationDownMirrored;
            break;
        case 5:
            newOrientation = UIImageOrientationLeftMirrored;
            break;
        case 7:
            newOrientation = UIImageOrientationRightMirrored;
            break;  
    }  
    return newOrientation;  
}
-(IBAction)infoButtonClick:(id)sender
{
    InfoViewController *vc = [[InfoViewController alloc] init];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}


-(IBAction)shareButtonClick:(id)sender
{
    /*UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Twitter",@"Instagram", @"Mail",@"Save to Library", nil];*/
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Twitter", @"Mail",@"Save to Library", nil];
    [actionSheet showInView:self.view];
}

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    return interactionController;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    /*if (buttonIndex==0) {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            
            SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [mySLComposerSheet setInitialText:@"Check out this funny photo.\nBecome savvy and create."];
            
    
            
            [mySLComposerSheet addImage:imageView.image];
            
            [mySLComposerSheet addURL:[NSURL URLWithString:@"http://www.stcreate.net"]];
            
            [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"Post Canceled");
                        break;
                    case SLComposeViewControllerResultDone:
                        NSLog(@"Post Sucessful");
                        break;
                        
                    default:
                        break;
                }
            }];
            
            [self presentViewController:mySLComposerSheet animated:YES completion:nil];
        }
    }
    else if(buttonIndex==1)*/
    if(buttonIndex==0)
    {
        TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
        [tweetViewController setInitialText:@"Check out this funny photo.\nBecome savvy and create."];
        [tweetViewController addImage:imageView.image];
        [tweetViewController addURL:[NSURL URLWithString:@"http://www.stcreate.net"]];

                // Create the completion handler block.
        [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
            NSString *output;
            
            switch (result) {
                case TWTweetComposeViewControllerResultCancelled:
                    // The cancel button was tapped.
                    output = @"Tweet cancelled.";
                    break;
                case TWTweetComposeViewControllerResultDone:
                    // The tweet was sent.
                    output = @"done";
                    break;
                default:
                    break;
            }
            [self performSelectorOnMainThread:@selector(displayText:) withObject:output waitUntilDone:NO];
            // Dismiss the tweet composition view controller.
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        // Present the tweet composition view controller modally.
        tweetViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:tweetViewController animated:YES completion:nil];
    }
    /*else if(buttonIndex==2)
    {
        NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
        if([[UIApplication sharedApplication] canOpenURL:instagramURL]) //check for App is install or not
        {
            NSData *imageData = UIImagePNGRepresentation(imageView.image); //convert image into .png format.
            NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
            NSString *documentsDirectory = [paths objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"insta.igo"]]; //add our image to the path
            [fileManager createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)
            NSLog(@"image saved");
            
            CGRect rect = CGRectMake(0 ,0 , 0, 0);
            UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
            [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIGraphicsEndImageContext();
            NSString *fileNameToSave = [NSString stringWithFormat:@"Documents/insta.igo"];
            NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fileNameToSave];
            NSLog(@"jpg path %@",jpgPath);
            NSString *newJpgPath = [NSString stringWithFormat:@"file://%@",jpgPath];
            NSLog(@"with File path %@",newJpgPath);
//            NSURL *igImageHookFile = [[NSURL alloc]initFileURLWithPath:newJpgPath];
            NSURL *igImageHookFile = [NSURL URLWithString:newJpgPath];
            NSLog(@"url Path %@",igImageHookFile);
            
            self.documentController.UTI = @"com.instagram.exclusivegram";
            self.documentController = [self setupControllerWithURL:igImageHookFile usingDelegate:self];
            self.documentController=[UIDocumentInteractionController interactionControllerWithURL:igImageHookFile];
            NSString *caption = @"Check out this funny photo.\nBecome savvy and create.\nhttp://www.stcreate.net"; //settext as Default Caption
            self.documentController.annotation=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",caption],@"InstagramCaption", nil];
            [self.documentController presentOpenInMenuFromRect:rect inView: self.view animated:YES];
        }
        else
        {
            NSLog (@"Instagram not found");
        }
    }
    else if(buttonIndex==3)*/
    else if(buttonIndex==1)
    {
        if ([MFMailComposeViewController canSendMail])
        {
            
            MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
            mailViewController.mailComposeDelegate = self;
            
            [mailViewController setSubject:@"Image"];
            [mailViewController addAttachmentData:UIImageJPEGRepresentation(imageView.image, 1) mimeType:@"image/jpeg" fileName:@"MyFile.jpeg"];
            //[mailViewController setMessageBody:body isHTML:NO];
                
            [self presentViewController:mailViewController animated:YES completion: nil];
        }
        else
        {
            NSLog(@"Device is unable to send email in its current state.");
        }

    }
    //else if(buttonIndex==4)
    else if(buttonIndex==2)
    {
        //UIImageWriteToSavedPhotosAlbum(imageView.image, nil, nil, nil);
       // UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(fileSave), nil);
        UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
    // Unable to save the image
    if (error)
        alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                           message:@"Unable to save image to Photo Album."
                                          delegate:self cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
    else // All is well
        alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                           message:@"Image saved to Photo Album."
                                          delegate:self cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
    
    
    [alert show];
}
- (void)displayText:(NSString *)text
{
    if([text isEqualToString:@"done"])
    {
        [self.navigationController popViewControllerAnimated:YES];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Thanks for spreading the Bidzy love." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        //[alert release];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
            
        case MFMailComposeResultCancelled:
            
            break;
        case MFMailComposeResultSaved:
            
            break;
        case MFMailComposeResultSent:
            
            break;
        case MFMailComposeResultFailed:
            
            break;
        default:
            NSLog (@"Result: not sent");
            break;
    }
    
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
-(IBAction)swapButtonClick:(id)sender
{
    if (swaped) {
        imageView.image=image11;
        swaped=NO;
    }
    else
    {
        CIImage* image = [CIImage imageWithCGImage:imageView.image.CGImage];
        
        CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                                  context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
        NSArray* features = [detector featuresInImage:image];
        
        if (features.count>1)
        {
            
            CIFaceFeature *face1=[features objectAtIndex:0];
            CIFaceFeature *face2=[features objectAtIndex:1];
            
            CGRect rect1=[self flipRect:face1.bounds Bound:CGRectMake(0, 0,imageView.image.size.width, imageView.image.size.height)];//imageView.bounds];
            
            CGImageRef imageRef = CGImageCreateWithImageInRect([imageView.image CGImage], rect1);
            UIImage *img = [UIImage imageWithCGImage:imageRef];
            CGImageRelease(imageRef);
            
            // CGRect rect2=[self flipRect:face2.bounds Bound:imageView.bounds];
            CGRect rect2=[self flipRect:face2.bounds Bound:CGRectMake(0, 0,imageView.image.size.width, imageView.image.size.height)];//imageView.bounds];
            CGImageRef imageRef1 = CGImageCreateWithImageInRect([imageView.image CGImage], rect2);
            UIImage *img1 = [UIImage imageWithCGImage:imageRef1];
            CGImageRelease(imageRef1);
            
            
            float radians = atan2((CGRectGetMaxY(CGRectMake(0, 0,imageView.image.size.width, imageView.image.size.height))-face1.rightEyePosition.y) - (CGRectGetMaxY(CGRectMake(0, 0,imageView.image.size.width, imageView.image.size.height))-face1.leftEyePosition.y) , face1.rightEyePosition.x - face1.leftEyePosition.x);
            
            
            float radians1 = atan2((CGRectGetMaxY(CGRectMake(0, 0,imageView.image.size.width, imageView.image.size.height))-face2.rightEyePosition.y) - (CGRectGetMaxY(CGRectMake(0, 0,imageView.image.size.width, imageView.image.size.height))-face2.leftEyePosition.y) , face2.rightEyePosition.x - face2.leftEyePosition.x);
            
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
            CGSize offScreenSize=imageView.image.size;
            UIGraphicsBeginImageContext(offScreenSize);
            
            
            [imageView.image  drawInRect:CGRectMake(0, 0,offScreenSize.width, offScreenSize.height)];
            [final1 drawInRect:rect2];
            [final2 drawInRect:rect1];
            //[img1 roundedCornerImage:img1.size.height/5 borderSize:0]
            UIImage* imagez = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            imageView.image=imagez;
            // mainImageView.frame=CGRectMake(0, 0, 320, 460);
            
            swaped=YES;
            
        }
        else
        {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Two Or more face needed for swapping" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}
*/
@end

//
//  InfoViewController.h
//  FaceDetectionExample
//
//  Created by Alpesh3 on 7/30/13.
//  Copyright (c) 2013 JID Marketing. All rights reserved.
//
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface InfoViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
    
    
}
-(IBAction)backButtonClick:(id)sender;
-(IBAction)fbButtonTap:(id)sender;
-(IBAction)twitterButtonTap:(id)sender;
-(IBAction)sButtonTap:(id)sender;
-(IBAction)termsButtonTap:(id)sender;
@end

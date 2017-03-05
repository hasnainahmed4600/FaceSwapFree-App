//
//  SwapFaceView.h
//  FaceDetectionExample
//
//  Created by Alpesh3 on 7/8/13.
//  Copyright (c) 2013 JID Marketing. All rights reserved.
//
#import "InfoViewController.h"
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface SwapFaceView : UIViewController<UIActionSheetDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    IBOutlet UIImageView *imageView;
    BOOL swaped;
}
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UIButton *customBanner;
@property (nonatomic,retain)UIImage *image11;
@property (nonatomic,retain)NSArray *features;
-(IBAction)swapButtonClick:(id)sender;
-(IBAction)backButtonClick:(id)sender;
-(IBAction)shareButtonClick:(id)sender;
-(IBAction)infoButtonClick:(id)sender;
@end

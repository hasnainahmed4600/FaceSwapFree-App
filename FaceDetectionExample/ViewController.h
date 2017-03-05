//
//  ViewController.h
//  FaceDetectionExample
//
//  Created by Johann Dowa on 11-11-01.
//  Copyright (c) 2011 ManiacDev.Com. All rights reserved.
//
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>
#import "FaceBookImagePicker.h"
#import "MBProgressHUD.h"

@interface ViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,FaceBookImagePickerDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    IBOutlet UIImageView *mainImageView;
    FaceBookImagePicker *fbImagePickerView;
  
   
}


@property (weak, nonatomic) IBOutlet UIButton *customBanner;
-(IBAction)takeImageButtonClick:(id)sender;
-(IBAction)infoButtonClick:(id)sender;

@end

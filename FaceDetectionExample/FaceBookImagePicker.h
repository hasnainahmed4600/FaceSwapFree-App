//
//  FaceBookImagePicker.h
//  FaceDetectionExample
//
//  Created by Alpesh3 on 7/14/13.
//  Copyright (c) 2013 JID Marketing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/ACAccountStore.h>
#import <Accounts/ACAccount.h>
#import <QuartzCore/QuartzCore.h>
@protocol FaceBookImagePickerDelegate;
@interface FaceBookImagePicker : UIViewController
{
    NSDictionary *list;
    
    IBOutlet UIScrollView *scrollView;
}

@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccount *facebookAccount;
@property (nonatomic, assign) id<FaceBookImagePickerDelegate> delegate;
-(IBAction)backButtonClick:(id)sender;


@end
@protocol FaceBookImagePickerDelegate <NSObject>

-(void)facebookImagePicker:(FaceBookImagePicker *)fbImagePicker selectedImage:(UIImage *)image;

@end

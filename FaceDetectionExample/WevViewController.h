//
//  WevViewController.h
//  FaceDetectionExample
//
//  Created by Alpesh on 8/2/13.
//  Copyright (c) 2013 JID Marketing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WevViewController : UIViewController<WKNavigationDelegate>
{
    IBOutlet WKWebView *web;
    IBOutlet UIActivityIndicatorView *indicator;
}
@property (nonatomic, retain) NSString *linkurl;
@end

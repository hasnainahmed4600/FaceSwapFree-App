//
//  WevViewController.m
//  FaceDetectionExample
//
//  Created by Alpesh on 8/2/13.
//  Copyright (c) 2013 JID Marketing. All rights reserved.
//

#import "WevViewController.h"

@interface WevViewController ()

@end

@implementation WevViewController
@synthesize linkurl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(IBAction)backButtonClick:(id)sender
{
    //self.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    web.navigationDelegate = self;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            indicator.frame=CGRectMake(150,244,37,37);
        }
        if(result.height == 568)
        {
            indicator.frame=CGRectMake(142,255,37,37);
        }
    }
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:linkurl]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    indicator.hidden= FALSE;
    [indicator startAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    indicator.hidden= TRUE;
    [indicator stopAnimating];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    indicator.hidden= TRUE;
    [indicator stopAnimating];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    indicator.hidden= TRUE;
    [indicator stopAnimating];
}

@end

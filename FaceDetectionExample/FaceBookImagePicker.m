//
//  FaceBookImagePicker.m
//  FaceDetectionExample
//
//  Created by Alpesh3 on 7/14/13.
//  Copyright (c) 2013 JID Marketing. All rights reserved.
//
#import "MBProgressHUD.h"
#import "FaceBookImagePicker.h"
#import <Social/Social.h>
#import <Accounts/ACAccountType.h>
#import <Accounts/ACAccountCredential.h>
@interface FaceBookImagePicker ()

@end

@implementation FaceBookImagePicker
@synthesize delegate;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountChanged:) name:ACAccountStoreDidChangeNotification object:nil];
    
    self.accountStore = [[ACAccountStore alloc]init];
    ACAccountType *FBaccountType= [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSString *key = @"225853407754340";
    NSDictionary *dictFB = [NSDictionary dictionaryWithObjectsAndKeys:key,ACFacebookAppIdKey,@[@"user_photos"],ACFacebookPermissionsKey, nil];
    
    
    [self.accountStore requestAccessToAccountsWithType:FBaccountType options:dictFB completion:
     ^(BOOL granted, NSError *e) {
         if (granted) {
             NSArray *accounts = [self.accountStore accountsWithAccountType:FBaccountType];
             //it will always be the last object with single sign on
             self.facebookAccount = [accounts lastObject];
             [self get];
         } else {
             //Fail gracefully...
             NSLog(@"error getting permission %@",e);
             
         }
     }];
}

-(void)get
{
    
    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me/photos"]];
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                            requestMethod:SLRequestMethodGET
                                                      URL:requestURL
                                               parameters:@{@"fields":@"source,picture",@"limit":@"1000"}];
    request.account = self.facebookAccount;
    
    [request performRequestWithHandler:^(NSData *data,
                                         NSHTTPURLResponse *response,
                                         NSError *error) {
        
        if(!error)
        {
            list =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            //NSLog(@"Result : %@",list);
            
            NSArray *ImageArray=[list objectForKey:@"data"];
            
            //NSLog(@"array : %@",ImageArray);
            float x=0;
            float y=0;
            float height=((ImageArray.count/4)+1)*75;
           // NSLog(@"Height :%i - %f",ImageArray.count,height);
            scrollView.contentSize=CGSizeMake(320,height);
            for (int i=1;i<=ImageArray.count;i++)
            {
                
                CGRect rect=CGRectMake((x*65)+(12*(x+1)),(y*65)+(10*(y+1)),65, 65);
            
                UIImage *img=[self getImage:[[ImageArray objectAtIndex:i-1] objectForKey:@"source"]];//
                if (img==nil) {
                    
                img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[ImageArray objectAtIndex:i-1] objectForKey:@"source"]]]];
                }
                UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                [btn setImage:img forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                btn.frame=rect;
                btn.tag=i;
                btn.backgroundColor=[UIColor whiteColor];
                btn.layer.shadowOpacity = 0.8;
                btn.layer.shadowRadius=3.0;
                btn.layer.shadowOffset = CGSizeMake(2.0,2.0);
                btn.layer.shadowColor = [[UIColor blackColor] CGColor];
                btn.layer.shouldRasterize = YES;
                btn.layer.borderWidth=3;
                btn.layer.borderColor=[UIColor whiteColor].CGColor;
                [scrollView addSubview:btn];
                
                x++;
                if (i%4==0) {
                    x=0;
                    y++;
                }
            }
            //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if([list objectForKey:@"error"]!=nil)
            {
                [self attemptRenewCredentials];
            }
        }
        else
        {
            //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            //NSLog(@"error from get%@",error);
        }
        
    }];
    
}
- (UIImage *)getImage:(NSString *)ImageURLString
{
    NSMutableString *tmpStr = [NSMutableString stringWithString:ImageURLString];
    [tmpStr replaceOccurrencesOfString:@"/" withString:@"-" options:1 range:NSMakeRange(0, [tmpStr length])];
    
    NSString *filename = [NSString stringWithFormat:@"%@",tmpStr];
    NSString *uniquePath = [NSTemporaryDirectory() stringByAppendingPathComponent: filename];
    //NSLog(@"UniquePath : %@",uniquePath);
    UIImage *image;
    
    // Check for a cached version
    if([[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
    {
        NSData *data = [[NSData alloc] initWithContentsOfFile:uniquePath];
        image = [[UIImage alloc] initWithData:data] ; // this is the cached image
    }
    else
    {
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:ImageURLString]];
        
        UIImage *image = [[UIImage alloc] initWithData: data];
        
        if([ImageURLString rangeOfString: @".png" options: NSCaseInsensitiveSearch].location != NSNotFound)
        {
            [UIImagePNGRepresentation(image) writeToFile:uniquePath atomically: YES];
        }
        else if(
                [ImageURLString rangeOfString: @".jpg" options: NSCaseInsensitiveSearch].location != NSNotFound ||
                [ImageURLString rangeOfString: @".jpeg" options: NSCaseInsensitiveSearch].location != NSNotFound
                )
        {
            [UIImageJPEGRepresentation(image, 100) writeToFile: uniquePath atomically: YES];
        }
    
        return nil;
        
//        NSData *data1 = [[NSData alloc] initWithContentsOfFile:uniquePath];
//        if (data1) {
//            
//        }
        
        
    }
    
    return image;
}
-(IBAction)imageButtonClick:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    NSArray *ImageArray=[list objectForKey:@"data"];
    NSLog(@"Selected Image : %@",[[ImageArray objectAtIndex:btn.tag-1] objectForKey:@"source"]);
    [delegate facebookImagePicker:self selectedImage:btn.currentImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)accountChanged:(NSNotification *)notif//no user info associated with this notif
{
    [self attemptRenewCredentials];
}

-(void)attemptRenewCredentials{
    [self.accountStore renewCredentialsForAccount:(ACAccount *)self.facebookAccount completion:^(ACAccountCredentialRenewResult renewResult, NSError *error){
        if(!error)
        {
            switch (renewResult) {
                case ACAccountCredentialRenewResultRenewed:
                    NSLog(@"Good to go");
                    [self get];
                    break;
                case ACAccountCredentialRenewResultRejected:
                    NSLog(@"User declined permission");
                    break;
                case ACAccountCredentialRenewResultFailed:
                    NSLog(@"non-user-initiated cancel, you may attempt to retry");
                    break;
                default:
                    break;
            }
            
        }
        else{
            //handle error gracefully
            NSLog(@"error from renew credentials%@",error);
        }
    }];
}

-(IBAction)backButtonClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

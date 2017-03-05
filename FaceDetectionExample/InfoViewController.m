//
//  InfoViewController.m
//  FaceDetectionExample
//
//  Created by Alpesh3 on 7/30/13.
//  Copyright (c) 2013 JID Marketing. All rights reserved.
//

#import "InfoViewController.h"
#import "WevViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(IBAction)backButtonClick:(id)sender
{
    self.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)fbButtonTap:(id)sender
{
//    NSURL *fbURL=[[NSURL alloc] initWithString:@"fb://profile/388064624549142"];
//    if ( ! [[UIApplication sharedApplication] canOpenURL:fbURL] ) {
//        fbURL = [[NSURL alloc] initWithString:@"http://www.facebook.com/savvytechcreations"];     
//
//    }
//     //fbURL = [[NSURL alloc] initWithString:@"http://www.facebook.com/savvytechcreations"];
//    [[UIApplication sharedApplication] openURL:fbURL];
    
    WevViewController *web=[[WevViewController alloc]init];
    web.linkurl=@"http://www.facebook.com/savvytechcreations";
    web.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:web animated:YES completion:nil];
}
-(IBAction)sButtonTap:(id)sender
{
    NSURL *fbURL=nil;
   
    fbURL = [[NSURL alloc] initWithString:@"http://www.stcreate.net/"];
   
    [[UIApplication sharedApplication] openURL:fbURL];
}
-(IBAction)twitterButtonTap:(id)sender
{   
//    NSURL *fbURL = [[NSURL alloc] initWithString:@"twitter://user?screen_name=savvy_tech"];
//    if ( ! [[UIApplication sharedApplication] canOpenURL:fbURL] ) {
//        fbURL = [[NSURL alloc] initWithString:@"https://twitter.com/savvy_tech"];
//    }
//    [[UIApplication sharedApplication] openURL:fbURL];
    
    WevViewController *web=[[WevViewController alloc]init];
    web.linkurl=@"https://twitter.com/savvy_tech";
    web.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:web animated:YES completion:nil];
}

-(IBAction)termsButtonTap:(id)sender
{
    WevViewController *web=[[WevViewController alloc]init];
    web.linkurl=@"https://www.app-central.com/terms";
    web.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:web animated:YES completion:nil];
}
-(void)webviewopen
{
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    if (section==0) {
        return 1;
    }
    else
    {
        return 1;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return @"More App:";
    }
    else
    {
        return @"Contact:";
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    if (indexPath.section==0 && indexPath.row==0) {
        cell.textLabel.text=@"I'm Away";
        cell.imageView.image=[UIImage imageNamed:@"imaway"];
    }
    
    /*if (indexPath.section==0 && indexPath.row==0) {
        cell.textLabel.text=@"SonicGraph";
        cell.imageView.image=[UIImage imageNamed:@"sonicGraph_icon"];
    }
    if (indexPath.section==0 && indexPath.row==1) {
        cell.textLabel.text=@"Alarm clock extra";
        cell.imageView.image=[UIImage imageNamed:@"alarm_icon"];
    }
    if (indexPath.section==0 && indexPath.row==2) {
        cell.textLabel.text=@"Frames R Us";
        cell.imageView.image=[UIImage imageNamed:@"frameRS_icon"];
    }
    if (indexPath.section==0 && indexPath.row==3) {
        cell.textLabel.text=@"Spin Dottor";
        cell.imageView.image=[UIImage imageNamed:@"spindottor"];
    }
    if (indexPath.section==0 && indexPath.row==4) {
        cell.textLabel.text=@"I'm Away";
        cell.imageView.image=[UIImage imageNamed:@"imaway"];
    }
    if (indexPath.section==0 && indexPath.row==5) {
        cell.textLabel.text=@"Chill Out Button!";
        cell.imageView.image=[UIImage imageNamed:@"chillout"];
    }
    if (indexPath.section==1) {
        cell.textLabel.text=@"        Feedback and support";
        cell.textLabel.textAlignment=UITextAlignmentCenter;
    }*/
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section==0) {
        return 60.0;
    }else{
        return 40.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0) {
        NSString *GiftAppURL=nil;
        if(indexPath.row==0)
        {
            GiftAppURL = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/im-away/id1031066842?mt=8"];
        }
        /*if (indexPath.row==0) {
            GiftAppURL = [NSString stringWithFormat:@"https://itunes.apple.com/in/app/sonicgraph/id643143227?mt=8"];
        }
        else if(indexPath.row==1)
        {
            GiftAppURL = [NSString stringWithFormat:@"https://itunes.apple.com/in/app/alarm-clock-extra/id554126520?mt=8"];
        }
        else if(indexPath.row==2)
        {
            GiftAppURL = [NSString stringWithFormat:@"https://itunes.apple.com/in/app/frames-r-us/id577779907?mt=8"];
        }
        else if(indexPath.row==3)
        {
            GiftAppURL = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/spin-dottor/id1020899804?mt=8"];
        }
        else if(indexPath.row==4)
        {
            GiftAppURL = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/im-away/id1031066842?mt=8"];
        }
        else
        {
            GiftAppURL = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/chill-out-button!/id953526421?mt=8"];
        }*/
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:GiftAppURL]];
    }
    else
    {
        if ([MFMailComposeViewController canSendMail])
        {
            
            MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
            mailViewController.mailComposeDelegate = self;
            
            [mailViewController setToRecipients:[NSArray arrayWithObjects:@"savvytechcreations@gmail.com", nil]];
            [mailViewController setSubject:@"FeedBack &Support For Face Swap!"];
            //[mailViewController setMessageBody:@"" isHTML:NO];
            
            mailViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:mailViewController animated:YES completion:nil];
            
            
        }
        else
        {
            NSLog(@"Device is unable to send email in its current state.");
        }

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
            
            NSLog(@"sent");
            {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Thanks for spreading the My Video Downloader love." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            }
            
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


@end

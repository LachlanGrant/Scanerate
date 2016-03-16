//
//  InfoViewController.m
//  Scanerate
//
//  Created by Lachlan Grant on 13/06/2014.
//  Copyright (c) 2014 BLAT Dev. All rights reserved.
//

#import "InfoViewController.h"

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)email:(NSString *)title:(NSString *)message {
    NSArray *to = [NSArray arrayWithObject:@"lachy.g572@me.com"];
    
    MFMailComposeViewController *mf = [[MFMailComposeViewController alloc] init];
    mf.mailComposeDelegate = self;
    [mf setSubject:title];
    [mf setMessageBody:message isHTML:NO];
    [mf setToRecipients:to];
    [self presentViewController:mf animated:YES completion:nil];

}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)feedback:(id)sender {
    NSString *title = @"[Scanerate][Feedback] Version 1.0.2";
    NSString *message = @"I thought Scanerate was...";
    [self email:title :message];
    }
- (IBAction)issue:(id)sender {
    [self email:@"[Scanerate][BUG] Version 1.0.2" :@"The problem with Scanerate is..."];
}
- (IBAction)website:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://blatdev.sytes.net"];
    [[UIApplication sharedApplication] openURL:url];
}

@end

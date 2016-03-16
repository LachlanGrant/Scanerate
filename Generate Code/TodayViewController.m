//
//  TodayViewController.m
//  Generate Code
//
//  Created by Lachlan Grant on 15/12/2014.
//  Copyright (c) 2014 BLAT Dev. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "BLATQRGen.h"

@interface TodayViewController () <NCWidgetProviding>
@property (weak, nonatomic) IBOutlet UIButton *genButton;
@property IBOutlet UIImageView *imageView;

@end

@implementation TodayViewController

-(IBAction)genButtonAction {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *pasteboardData = [pasteboard string];
    
    if ([pasteboardData containsString:@" "]) {
        [pasteboardData stringByReplacingOccurrencesOfString:@" " withString:@"*"];
    }
    
    NSURL *scheme = [NSURL URLWithString:[NSString stringWithFormat:@"scanerate://?%@", pasteboardData]];
    [self.extensionContext openURL:scheme completionHandler:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.genButton addTarget:self action:@selector(genButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.genButton setBounds:self.view.bounds];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end

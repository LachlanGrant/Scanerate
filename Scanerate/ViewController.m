//
//  ViewController.m
//  Scanerate
//
//  Created by Lachlan Grant on 3/06/2014.
//  Copyright (c) 2014 BLAT Dev. All rights reserved.
//

#import "ViewController.h"
#import <CoreImage/CoreImage.h>
//#import <BLATpod/BLATQRGen.h>
#import "BLATQRGen.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *BarcodeView;
@property (weak, nonatomic) IBOutlet UITextField *barcodeTextField;
@property (weak, nonatomic) IBOutlet UIImageView *barcodeImageView;

@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

-(void)viewDidAppear:(BOOL)animated {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"shouldgen"] == TRUE) {
        //generate code
        self.barcodeTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"barcode"];
        [self generateButton:nil];
        [self shareButton:nil];
    }
}


-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)generateButton:(id)sender {
    [self generateBarcode:self.barcodeTextField.text];
}
- (IBAction)shareButton:(id)sender {
    if (self.barcodeImageView.image == nil) {
        //No image
        [self generateButton:nil];
    }
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObject:self.barcodeImageView.image] applicationActivities:nil];
    [self presentViewController:controller animated:YES completion:nil];
}

-(void)generateBarcode:(NSString *)barcodeText {
    self.barcodeImageView.image = [BLATQRGen barcodeimage:barcodeText];
}

-(IBAction)ReturnKeyButton:(id)sender {
    [sender resignFirstResponder];
    [self generateBarcode:self.barcodeTextField.text];
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [banner setFrame:CGRectMake(999999, 999999, banner.frame.size.width, banner.frame.size.height)];
    [self updateViewConstraints];
    NSLog(@"Failed");
   // [banner removeFromSuperview];
}


-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    
}

-(void)setBarcodeFieldText:(NSString *)text {
    self.barcodeTextField.text = text;
}

@end

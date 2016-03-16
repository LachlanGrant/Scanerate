//
//  igViewController.m
//  ScanBarCodes
//
//  Scanerate
//
//  Created by Lachlan Grant on 3/06/2014.
//  Copyright (c) 2014 BLAT Dev. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "igViewController.h"

@interface igViewController () <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    
    //UIView *_highlightView;
    // UILabel *_label;
    
}
@property (weak, nonatomic) IBOutlet UIView *barcodeView;
@property UIImage *bluredImage;
@end

@implementation igViewController
@synthesize hasBeenShown;
@synthesize barcodeView;
@synthesize bluredImage;

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)prefersStatusBarHidden {
    return TRUE;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _session = [[AVCaptureSession alloc] init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        //NSLog(@"Error: %@", error);
    }
    
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];
    
    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
    
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = self.view.bounds;
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_prevLayer];
    
    [_session startRunning];
    
    [self takeSnapShot];
    
}

-(void)takeSnapShot {
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0f);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:NO];
    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.bluredImage = [self applyBlurOnImage:snapshotImage withRadius:10];
    
}

- (UIImage *)applyBlurOnImage: (UIImage *)imageToBlur withRadius: (CGFloat)blurRadius { CIImage *originalImage = [CIImage imageWithCGImage: imageToBlur.CGImage]; CIFilter *filter = [CIFilter filterWithName: @"CIGaussianBlur" keysAndValues: kCIInputImageKey, originalImage, @"inputRadius", @(blurRadius), nil]; CIImage *outputImage = filter.outputImage; CIContext *context = [CIContext contextWithOptions:nil]; CGImageRef outImage = [context createCGImage: outputImage fromRect: [outputImage extent]]; return [UIImage imageWithCGImage: outImage];
}

-(void)applyBluredImage {
    self.barcodeView.backgroundColor = [UIColor colorWithPatternImage:self.bluredImage];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil)
        {
            NSLog(@"%@",detectionString);
            [self useTheCode:detectionString];
            break;
        }
        else
            NSLog(@"");
    }
}

-(void)useTheCode:(NSString *)text {
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"lastscan"] isEqualToString:text]) {
        //Dont show the alert twice!
    } else {
        //Show and save
        
        if ([text hasPrefix:@"http://"] || [text hasPrefix:@"https://"]) {
            //Is a url
            NSURL *url = [NSURL URLWithString:text];
            [[UIApplication sharedApplication] openURL:url];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Barcode Message" message:text delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
            [alert show];
            [[NSUserDefaults standardUserDefaults] setObject:text forKey:@"lastscan"];
        }
    }
    
    
    if ([text hasPrefix:@"http://"] || [text hasPrefix:@"https://"]) {
        //Is a url
        NSURL *url = [NSURL URLWithString:text];
        [[UIApplication sharedApplication] openURL:url];
        //[[UIApplication sharedApplication] openURL:text];
    } else {
        
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
}

@end
//
//  BLATQRGen.m
//  BLATFramework
//
//  Created by Lachlan Grant on 25/05/2014.
//  Copyright (c) 2014 BLAT Dev. All rights reserved.
//

#import "BLATQRGen.h"

@implementation BLATQRGen

+(UIImage *)barcodeimage:(NSString *)barcodeMessage {
    UIImage *image = [[UIImage alloc] init];
    if ([barcodeMessage isEqualToString:@""]) {
        //We need to fix this
        barcodeMessage = @"There was no text entered :(";
    } else {
        //sweet
    }
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setDefaults];
    
    NSData *data = [barcodeMessage dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    
    CIImage *outputImage = [filter outputImage];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputImage
    
    image = [UIImage imageWithCGImage:cgImage scale:1.0 orientation:UIImageOrientationUp];
    
    UIImage *resized = [self image:image withQuality:kCGInterpolationNone rate:5.0];

             return resized;
}

+(UIImage *)image:(UIImage *)image
      withQuality:(CGInterpolationQuality)quality
             rate:(CGFloat)rate
{
	UIImage *resized = nil;
	CGFloat width = image.size.width * rate;
	CGFloat height = image.size.height * rate;
	
	UIGraphicsBeginImageContext(CGSizeMake(width, height));
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetInterpolationQuality(context, quality);
	[image drawInRect:CGRectMake(0, 0, width, height)];
	resized = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return resized;
}

@end

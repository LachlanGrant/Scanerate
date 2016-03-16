//
//  BLATQRGen.h
//  BLATFramework
//
//  Created by Lachlan Grant on 25/05/2014.
//  Copyright (c) 2014 BLAT Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>

@interface BLATQRGen : NSObject

/** Simple QR Code generator
 @param barcodeMessage NSString - the text the user will see when they scan the barcode
 @return UIImage of the barcode
 */

+(UIImage *)barcodeimage:(NSString *)barcodeMessage;

+(UIImage *)image:(UIImage *)image
             withQuality:(CGInterpolationQuality)quality
                    rate:(CGFloat)rate;

@end

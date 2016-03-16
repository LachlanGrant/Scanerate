//
//  ViewController.h
//  Scanerate
//
//  Created by Lachlan Grant on 3/06/2014.
//  Copyright (c) 2014 BLAT Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "igViewController.h"
#import <iAd/iAd.h>


@interface ViewController : UIViewController <ADBannerViewDelegate>

-(IBAction)ReturnKeyButton:(id)sender;

-(void)setBarcodeFieldText:(NSString *)text;

-(void)shareBarcode;


@end


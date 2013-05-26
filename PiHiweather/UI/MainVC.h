//
//  MainVC.h
//  PiHiweather
//
//  Created by Hokila on 13/5/25.
//  Copyright (c) 2013年 PiHi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CWBForecastDataParser.h"

@interface MainVC : UIViewController<CLLocationManagerDelegate,CWBForecastDataParserDelegate>
@property(strong, nonatomic) NSString* cityName;
@property(strong, nonatomic) NSArray* townList;
- (IBAction)clickFindLocation:(id)sender;

@end

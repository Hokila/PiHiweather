//
//  CWBForecastData.h
//  CWBForecastData
//
//  Created by Peni on 13/5/25.
//  Copyright (c) 2013年 Peni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWBForecastData : NSObject

@property NSString *CountyID;
@property NSString *AreaID;
@property NSString *FcstTime;
@property NSString *Wx;
@property NSString *WeatherIcon;
@property NSString *Temperature;
@property NSString *WindSpeed;
@property NSString *WindLevel;
@property NSString *WindDir;
@property NSString *RH;
@property NSString *PoP;
@property NSString *MaxT;
@property NSString *MinT;
@property NSString *MaxCI;
@property NSString *MinCI;
@property NSString *WeatherDes;

- (void)print;

@end

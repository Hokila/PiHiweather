//
//  CWBForecastData.m
//  CWBForecastData
//
//  Created by Peni on 13/5/25.
//  Copyright (c) 2013年 Peni. All rights reserved.
//

#import "CWBForecastData.h"

@implementation CWBForecastData

- (void)print
{
    NSLog(@"CountyID = %@, AreaID = %@, FcstTime = %@, Wx = %@, WeatherIcon = %@, Temperature = %@, WindSpeed = %@, WindLevel = %@, WindDir = %@, RH = %@, PoP = %@, MaxT = %@, MinT = %@, MaxCI = %@, MinCI = %@, WeatherDes = %@", self.CountyID, self.AreaID, self.FcstTime, self.Wx, self.WeatherIcon, self.Temperature, self.WindSpeed, self.WindLevel, self.WindDir, self.RH, self.PoP, self.MaxT, self.MinT, self.MaxCI, self.MinCI, self.WeatherDes);
}

@end

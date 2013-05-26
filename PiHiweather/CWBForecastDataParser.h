//
//  CWBForecastDataParser.h
//  CWBForecastData
//
//  Created by Peni on 13/5/25.
//  Copyright (c) 2013年 Peni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWBForecastData.h"

@protocol CWBForecastDataParserDelegate;


@interface CWBForecastDataParser : NSObject

@property (nonatomic, assign) id<CWBForecastDataParserDelegate> delegate;

- (id)initWithCountyID:(NSString *)countyID areaId:(NSString *)areaID;
- (void)start;

@end


@protocol CWBForecastDataParserDelegate <NSObject>
@required
-(void)onParseComplete:(NSArray *)result;

@end
//
//  CWBForecastDataParser.m
//  CWBForecastData
//
//  Created by Peni on 13/5/25.
//  Copyright (c) 2013年 Peni. All rights reserved.
//

#import "CWBForecastDataParser.h"
#import "AFHTTPRequestOperation.h"
#import "GDataXMLNode.h"

const NSString *XML_PREFIX = @"http://www.cwb.gov.tw/township/XML/";
const NSString *WEEKDAY_XML_POSTFIX = @"_Weekday_CH.xml";

@interface CWBForecastDataParser()

@property NSString *CountyID;
@property NSString *AreaID;

@end

@implementation CWBForecastDataParser

- (id)initWithCountyID:(NSString *)countyID areaId:(NSString *)areaID
{
    self = [super init];
    if (self) {
        self.CountyID = countyID;
        self.AreaID = areaID;
    }
    return self;
}

- (void)start
{
    NSString *xmlPath = [NSString stringWithFormat:@"%@%@%@", XML_PREFIX, self.CountyID, WEEKDAY_XML_POSTFIX];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:xmlPath]];
    __block AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    __block CWBForecastDataParser *tempSelf = self;
    operation.completionBlock = ^ {
        if ([operation hasAcceptableStatusCode]) {
            NSString *responseString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
            NSLog(@"success %@", responseString);
            [tempSelf parseXMLFromResponseString:responseString];
        } else {
            NSLog(@"statusCode = %d", [operation.response statusCode]);
        }
    };
    
    [operation start];
}

- (void)parseXMLFromResponseString:(NSString *)responseString
{
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:responseString                                                         options:0 error:&error];
    
    if (doc == nil) {
        NSLog(@"Parse xml failed");
    } else {
        NSLog(@"Parse xml successful, %@", doc.rootElement );
        NSArray *countyList = [doc.rootElement nodesForXPath:@"//TownWeekdaysForecast/ForecastData/County" error:nil];
        NSMutableArray *forecastDataList = [[NSMutableArray alloc] init];
        
        GDataXMLElement *countyElement = [countyList lastObject];
        NSLog(@"Parse xml county =  %@", [[countyElement attributeForName:@"CountyID"] stringValue]);
        NSString *countyID = [[countyElement attributeForName:@"CountyID"] stringValue];
        
        NSArray *areaList = [countyElement elementsForName:@"Area"];
        for (GDataXMLElement *areaElement in areaList) {
            NSString *areaID = [[areaElement attributeForName:@"AreaID"] stringValue];
            if (![areaID isEqualToString:self.AreaID])
                continue;
            
            NSArray *valueList = [areaElement elementsForName:@"Value"];
            for (GDataXMLElement *valueElement in valueList) {
                CWBForecastData *data = [[CWBForecastData alloc] init];
                data.CountyID = countyID;
                data.AreaID = areaID;
                data.Wx = [[[valueElement elementsForName:@"Wx"] lastObject] stringValue];
                data.WeatherIcon = [[[valueElement elementsForName:@"WeatherIcon"] lastObject] stringValue];
                data.Temperature = [[[valueElement elementsForName:@"Temperature"] lastObject] stringValue];
                data.WindSpeed = [[[valueElement elementsForName:@"WindSpeed"] lastObject] stringValue];
                data.WindLevel = [[[valueElement elementsForName:@"WindLevel"] lastObject] stringValue];
                data.WindDir = [[[valueElement elementsForName:@"WindDir"] lastObject] stringValue];
                data.RH = [[[valueElement elementsForName:@"RH"] lastObject] stringValue];
                data.PoP = [[[valueElement elementsForName:@"PoP"] lastObject] stringValue];
                data.MaxT = [[[valueElement elementsForName:@"MaxT"] lastObject] stringValue];
                data.MinT = [[[valueElement elementsForName:@"MinT"] lastObject] stringValue];
                data.MaxCI = [[[valueElement elementsForName:@"MaxCI"] lastObject] stringValue];
                data.MinCI = [[[valueElement elementsForName:@"MinCI"] lastObject] stringValue];
                data.WeatherDes = [[[valueElement elementsForName:@"WeatherDes"] lastObject] stringValue];
                
                [forecastDataList addObject:data];
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(onParseComplete:)]) {
            [self.delegate onParseComplete:forecastDataList];
        }
    }
}

@end

//
//  MainVC.m
//  PiHiweather
//
//  Created by Hokila on 13/5/25.
//  Copyright (c) 2013年 PiHi. All rights reserved.
//

#import "MainVC.h"
#import "SVGeocoder.h"

@interface MainVC (){
    CGFloat latValue,lngValue;
    CLLocationManager *locmanager;
    
    NSInteger cityID,townID;
}
@end

@implementation MainVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (nil==self.townList ) {
        self.townList = [[NSArray alloc]init];
    }
    
    CWBForecastDataParser *parser = [[CWBForecastDataParser alloc] initWithCountyID:@"67000" areaId:@"6700030"];
    [parser setDelegate:self];
    [parser start];
}

- (IBAction)clickFindLocation:(id)sender {
    [self loadLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark location method
-(void)loadLocation{
    if (locmanager == nil) {
        PiHiLog(@"第一次啟動，init & startUpdatingLocation");
        locmanager = [[CLLocationManager alloc] init];
        [locmanager setDelegate:self];
        [locmanager setDesiredAccuracy:kCLLocationAccuracyBest];
        [locmanager startUpdatingLocation];
    }
    else{
        PiHiLog(@"not 第一次啟動，just startUpdatingLocation");
        [locmanager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    latValue = newLocation.coordinate.latitude;
    lngValue = newLocation.coordinate.longitude;
    if (latValue >0) {
        [manager stopUpdatingLocation];
        [SVGeocoder reverseGeocode:CLLocationCoordinate2DMake(latValue,lngValue)
                        completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
                            
//                            PiHiLog(@"placemarks = %@",placemarks );
                            for (NSDictionary *SVPlacemark in placemarks) {
                                if ([SVPlacemark valueForKey:@"locality"] != nil) {
                                    NSString *locality = [SVPlacemark valueForKey:@"locality"];
                                    NSString *cityName = [SVPlacemark valueForKey:@"subAdministrativeArea"];
                                    NSString*alertStr = [NSString stringWithFormat:@"你在%@%@",cityName,locality];
                                    ShowAlert(alertStr);
                                    
                                    [self loadLocationData:locality city:cityName];
                                    break;
                                }
                            }
                            
                        }];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    ShowAlert(@"定位失敗");
    [manager stopUpdatingLocation];
}

-(void)loadLocationData:(NSString*)townName city:(NSString*)cityName{
    self.cityName = cityName;
    
    NSDictionary *CityDic = [[NSDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Area" ofType:@"plist"]];
    NSArray* CityList = [CityDic objectForKey:@"City"];
    
    [CityList enumerateObjectsUsingBlock:^(NSDictionary *CityItem, NSUInteger idx, BOOL *stop) {
        if ([[CityItem objectForKey:@"COUN_NA"]isEqualToString:cityName]) {
            
            self.townList = [CityItem objectForKey:@"Town"];
            cityID = [[CityItem objectForKey:@"COUN_ID"] integerValue];
            
            [self.townList enumerateObjectsUsingBlock:^(NSDictionary *townItem, NSUInteger idx, BOOL *stop) {
                if ([[townItem objectForKey:@"TOWN_NA"]isEqualToString:townName]) {
                    townID = [[townItem objectForKey:@"TOWN_ID"]integerValue];
                    PiHiLog(@"%@ = %d, %@= %d",cityName,cityID,townName,townID);
                }
            }];
            
            *stop = YES;
        }
//        PiHiLog(@"%@",[CityItem objectForKey:@"COUN_NA"]);
        
        if (idx == [CityList count]-1) {
            PiHiLog(@"已到最後一筆，都找不到");
        }
    }];
}

#pragma -mark CWBForecastDataParserDelegate
-(void)onParseComplete:(NSArray *)result{
    [result enumerateObjectsUsingBlock:^(CWBForecastData* data, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            [data print];
        }
    }];
}

@end

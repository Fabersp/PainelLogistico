//
//  Map.h
//  AppsAgronomo
//
//  Created by Fabricio Padua on 19/07/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface Map : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {
    
    NSString * endereco, * cinema, * onde;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    double lat;
    double lng;
    
}

@property (nonatomic, strong) IBOutlet MKMapView *mapkit;
@property (nonatomic, retain) NSString * endereco, * cinema, * onde;



@end

//
//  ContatoRevide.h
//  AppsAgronomo
//
//  Created by Fabricio Padua on 28/07/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>

@interface ContatoRevide : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate> {
    
    Reachability* internetReachable;
    Reachability* hostReachable;
    bool internetActive;
    bool hostActive;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    double lat;
    double lng;
    
    NSString * endereco, * cinema, * onde;
}



@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIView *ViewApper;
@property (weak, nonatomic) IBOutlet MKMapView *map;

@property (nonatomic, retain) NSString * endereco, * cinema, * onde;



@end

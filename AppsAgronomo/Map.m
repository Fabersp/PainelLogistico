//
//  Map.m
//  AppsAgronomo
//
//  Created by Fabricio Padua on 19/07/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import "Map.h"

#define METERS_PER_MILE 1609.344

@interface Map ()


@end

@implementation Map 

@synthesize mapkit;
@synthesize endereco;
@synthesize cinema, onde;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    locationManager = [[CLLocationManager alloc] init];
    
    self.title = cinema;
       
    [self localizar:endereco];
    
}

-(void) localizar:(NSString *) Endereco {
    geocoder = [[CLGeocoder alloc] init];
    
    NSLog(@"%@", Endereco);
    
    [geocoder geocodeAddressString:Endereco completionHandler:^(NSArray *placemarks, NSError *error) {
        //Error checking
        
        placemark = [placemarks objectAtIndex:0];
        CLLocation *location = placemark.location;
        CLLocationCoordinate2D coordinate = location.coordinate;
        NSLog(@"coordinate = (%f, %f)", coordinate.latitude, coordinate.longitude);
        
          //  -21.225784,-47.8374115
        MKCoordinateRegion region;
        region.center = [(CLCircularRegion *)placemark.region center];
        lat = coordinate.latitude;
        lng = coordinate.longitude;
        NSLog(@"Localização");
       
        CLLocationCoordinate2D zoomLocation;
        zoomLocation.latitude = lat;
        zoomLocation.longitude= lng;
        
        mapkit.mapType = MKMapTypeStandard;
        mapkit.showsUserLocation = YES;
        
        MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
        myAnnotation.coordinate = CLLocationCoordinate2DMake(lat, lng);
        myAnnotation.title = cinema;
        //myAnnotation.subtitle = onde;
        [mapkit addAnnotation:myAnnotation];
        
        float spanX = 0.00725;
        float spanY = 0.00725;

        region.span.latitudeDelta = spanX;
        region.span.longitudeDelta = spanY;
        [mapkit setRegion:region animated:YES];
        
    
    }];
}
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        NSLog(@"Clicked Pizza Shop");
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Disclosure Pressed" message:@"Click Cancel to Go Back" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertView show];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
            pinView.calloutOffset = CGPointMake(0, 32);
            
            // Add a detail disclosure button to the callout.
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            pinView.rightCalloutAccessoryView = rightButton;
            
            // Add an image to the left callout.
            UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pizza_slice_32.png"]];
            pinView.leftCalloutAccessoryView = iconView;
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}


@end

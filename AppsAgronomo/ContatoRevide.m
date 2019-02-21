//
//  ContatoRevide.m
//  AppsAgronomo
//
//  Created by Fabricio Padua on 28/07/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import "ContatoRevide.h"
#import "Reachability.h"
#import "SWRevealViewController.h"
#import "Map.h"
#import <sys/utsname.h>

@implementation ContatoRevide

@synthesize ViewApper;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [ViewApper setFrame:[[UIScreen mainScreen] bounds]];
    
    [self.navigationController.view addSubview:ViewApper];
    
    // [self.view addSubview:ViewApper];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self localizar:@"Atibaia-SP"];
   
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
        
        self.map.mapType = MKMapTypeStandard;
        self.map.showsUserLocation = YES;
        
        MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
        myAnnotation.coordinate = CLLocationCoordinate2DMake(lat, lng);
        myAnnotation.title = cinema;
        //myAnnotation.subtitle = onde;
        [self.map addAnnotation:myAnnotation];
        
        float spanX = 0.00725;
        float spanY = 0.00725;
        
        region.span.latitudeDelta = spanX;
        region.span.longitudeDelta = spanY;
        [self.map setRegion:region animated:YES];
        
        
    }];
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
    //	[self dismissModalViewControllerAnimated:YES];
    [self becomeFirstResponder];
    [self dismissViewControllerAnimated:NO completion:nil];
}



- (IBAction)btnMap:(id)sender {
    NSString * Endereco = @"Atibaia-SP";
    
   
    Map * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"1234"];
    
    vc.endereco = Endereco;
    vc.cinema = @"Revista Painel Logístico";
   
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)btnEmail:(id)sender {
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
       // [[mailer navigationBar] setTintColor:[UIColor whiteColor]];
        
        [mailer setSubject:@"Contato - App Painel Logístico - iOS"];
        
        NSArray *toRecipients = [NSArray arrayWithObjects:@"contato@painellogistico.com.br", nil];
        [mailer setToRecipients:toRecipients];
        // only for iPad
        mailer.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentViewController:mailer animated:YES completion:^{NSLog (@"Action Completed");}];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Falha"
                                                        message:@"Este dispositivo não suporta o envio de e-mail."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}
- (IBAction)btnFacebook:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/PainelLogistico/"]];
    
}

- (IBAction)btnInstagram:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.instagram.com/revista_painel_logistico/"]];
}

- (IBAction)btnHome:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.painellogistico.com.br/"]];
}




- (IBAction)btnTelefone:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:1144175072"]];
}




@end

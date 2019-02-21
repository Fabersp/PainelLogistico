//
//  MenuGastronomiaTV.m
//  AppsAgronomo
//
//  Created by Fabricio Padua on 30/08/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//


#import "MenuGastronomiaTV.h"

#import <TSMessages/TSMessageView.h>
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "SWRevealViewController.h"
#import "MenuGastronomiaCell.h"
#import "DetalheGastronomia.h"
#import "MenuGastronomiaCellNovo.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]



@interface MenuGastronomiaTV ()

@end

@implementation MenuGastronomiaTV

@synthesize ViewApper;
@synthesize ObjetoJson;
@synthesize Id_Menu;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [ViewApper setFrame:[[UIScreen mainScreen] bounds]];
    
    [self.navigationController.view addSubview:ViewApper];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

    
    
}



//--------------- Verificar a internet -----------------//
-(void) viewWillAppear:(BOOL)animated
{
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [Reachability reachabilityWithHostName:@"www.revide.com.br"];
    [hostReachable startNotifier];
    
    // now patiently wait for the notification
}

-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)MensagemErro{
    
    // Add a button inside the message
    [TSMessage showNotificationInViewController:self
                                          title:@"Sem conexão com a intenet"
                                       subtitle:nil
                                          image:nil
                                           type:TSMessageNotificationTypeError
                                       duration:10.0
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:^{
                                     NSLog(@"User tapped the button");
                                     
                                 }
                                     atPosition:TSMessageNotificationPositionTop
                           canBeDismissedByUser:YES];
}



-(void) checkNetworkStatus:(NSNotification *)notice {
    // called after network status changes
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus) {
        case NotReachable: {
            [self MensagemErro];
            self->internetActive = NO;
            break;
        }
        case ReachableViaWiFi: {
            self->internetActive = YES;
            [self Loading];
            
            break;
        }
        case ReachableViaWWAN: {
            self->internetActive = YES;
            [self Loading];
            break;
        }
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus) {
        case NotReachable: {
            NSLog(@"Estamos com instabilidade no site neste momento, tente mais tarde...");
            self->hostActive = NO;
            
            break;
        }
        case ReachableViaWiFi: {
            self->hostActive = YES;
            
            break;
        }
        case ReachableViaWWAN: {
            self->hostActive = YES;
            
            break;
        }
    }
}


-(void)Loading{
    
    if (internetActive){
        
        NSURL  *url = [NSURL URLWithString:@"http://www.revide.com.br/api_revide/lista_CategoriaGastronomia.php"];
        
        NSURLSession * session = [NSURLSession sharedSession];
        
        NSURLSessionDownloadTask * task =
        [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            NSData * jsonData = [[NSData alloc] initWithContentsOfURL:location];
            
            listaManu = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                //hud.hidden = YES;
                
            });
            
            
        }];
        
        [task resume];
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return listaManu.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuGastronomiaCellNovo *cell = (MenuGastronomiaCellNovo *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    
    
    NSURL * urlImage = [NSURL URLWithString:[[listaManu objectAtIndex:indexPath.row] objectForKey:@"imagem"]];
    
    cell.lbImagem.image = [UIImage imageNamed:@"loading_materia"];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:urlImage completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    MenuGastronomiaCellNovo * updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                    if (updateCell)
                        updateCell.lbImagem.image = image;
                });
            }
        }
    }];
    
    [task resume];
    
    cell.lbTitulo.text = [[listaManu objectAtIndex:indexPath.row] objectForKey:@"nome"];
    
    return cell;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    ObjetoJson = [listaManu objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];

    NSString * idView = [ObjetoJson objectForKey:@"id"];
    NSString * categoria  = [ObjetoJson objectForKey:@"nome"];
    
    if ([[segue identifier] isEqualToString:@"Gastronomia"]) {
        DetalheGastronomia * vc = segue.destinationViewController;
        vc.id_Categoria = idView;
        vc.Categoria = categoria;
        
    }
}






@end

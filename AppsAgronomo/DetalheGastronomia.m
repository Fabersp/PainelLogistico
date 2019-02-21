//
//  DetalheGastronomia.m
//  AppsAgronomo
//
//  Created by Fabricio Padua on 24/07/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import "DetalheGastronomia.h"
#import "DetalhesGastronomiaCell.h"
#import "GatronomiaVc.h"
#import <TSMessages/TSMessageView.h>
#import "MBProgressHUD.h"
#import "Reachability.h"

@interface DetalheGastronomia ()




@end

@implementation DetalheGastronomia

@synthesize id_Categoria;
@synthesize Categoria;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = Categoria;
    self.navigationController.navigationBar.translucent = NO;
    
}

-(void) Loading:(NSURL *) urlLista {
    
    if (internetActive){

        NSURLSession * session = [NSURLSession sharedSession];
        
        NSURLSessionDownloadTask * task =
        [session downloadTaskWithURL:urlLista completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            NSData * jsonData = [[NSData alloc] initWithContentsOfURL:location];
            lista = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
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
    return lista.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetalhesGastronomiaCell *cell = (DetalhesGastronomiaCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    urlImage = [NSURL URLWithString:[[lista objectAtIndex:indexPath.row] objectForKey:@"imagem"]];
    
    cell.lbcapa.text = [[lista objectAtIndex:indexPath.row] objectForKey:@"nome"];
    cell.img_capa.image = [UIImage imageNamed:@"loading_materia"];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:urlImage completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    DetalhesGastronomiaCell * updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                    if (updateCell)
                        updateCell.img_capa.image = image;
                });
            }
        }
    }];
    [task resume];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (internetActive){
        
        NSDictionary *  ObjetoJson = [lista objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        NSString * idView = [ObjetoJson objectForKey:@"id"];
        urlImage = [NSURL URLWithString:[ObjetoJson objectForKey:@"imagem"]];
        NSString * estabelecimento = [ObjetoJson objectForKey:@"nome"];
        NSString * texto = [ObjetoJson objectForKey:@"texto"];
        
        if ([[segue identifier] isEqualToString:@"segueDetalheGastronomia"]) {
            
            GatronomiaVc * vc = segue.destinationViewController;
            vc.idView = idView;
            vc.UrlImagem = urlImage;
            vc.estabelecimento = estabelecimento;
            vc.texto = texto;
        }
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
            NSString * UrlMontadada = [NSString stringWithFormat:@"http://www.revide.com.br/api_revide/lista_GastronomiaporCategoria.php?id=%@", id_Categoria];
            
            [self Loading:[NSURL URLWithString:UrlMontadada]];
            
            break;
        }
        case ReachableViaWWAN: {
            self->internetActive = YES;
            NSString * UrlMontadada = [NSString stringWithFormat:@"http://www.revide.com.br/api_revide/lista_GastronomiaporCategoria.php?id=%@", id_Categoria];
            [self Loading:[NSURL URLWithString:UrlMontadada]];

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




@end

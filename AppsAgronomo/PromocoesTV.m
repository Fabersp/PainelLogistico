//
//  PromocoesTV.m
//  AppsAgronomo
//
//  Created by Fabricio Padua on 27/07/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import "PromocoesTV.h"
#import <TSMessages/TSMessageView.h>
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "SWRevealViewController.h"
#import "PromocoesCell.h"
#import "DetalhesPromocao.h"

@implementation PromocoesTV
@synthesize ViewApper;


- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    self.navigationController.navigationBar.translucent = NO;
    
}


-(void) Loading:(NSURL *) urlLista {
    
    if (internetActive) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.dimBackground = YES;
    
        NSURLSession * session = [NSURLSession sharedSession];
        
        NSURLSessionDownloadTask * task =
        [session downloadTaskWithURL:urlLista completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            NSData * jsonData = [[NSData alloc] initWithContentsOfURL:location];
            lista = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                
                
                hud.hidden = YES;
                
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
    PromocoesCell *cell = (PromocoesCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
     cell.imgCapa.image = [UIImage imageNamed:@"loading_materia"];
    
    urlImage = [NSURL URLWithString:[[lista objectAtIndex:indexPath.row] objectForKey:@"imagem"]];
    
    cell.lbtitulo.text = [[lista objectAtIndex:indexPath.row] objectForKey:@"titulo"];
    
    cell.lbtitulo.hidden = NO;
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:urlImage completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    PromocoesCell * updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                    if (updateCell)
                        updateCell.imgCapa.image = image;
                });
            }
        }
    }];
    [task resume];
    

    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSDictionary*  ObjetoJson = [lista objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
    
    NSString * idNoticia = [ObjetoJson objectForKey:@"id_vigencia"];
    NSURL * url = [NSURL URLWithString:[ObjetoJson objectForKey:@"imagem"]];
    NSString * texto_Titulo = [ObjetoJson objectForKey:@"titulo"];
    NSString * Resenha = [ObjetoJson objectForKey:@"resenha"];
    NSString * Descricao = [ObjetoJson objectForKey:@"descricao"];
    
    if ([[segue identifier] isEqualToString:@"seguePromocao"]) {
        DetalhesPromocao * destViewController = segue.destinationViewController;
        
        
        destViewController.UrlImagem = url;
        destViewController.id_Vigencia = idNoticia;
        destViewController.text_Capa = texto_Titulo;
        destViewController.resenha = Resenha;
        destViewController.descricao = Descricao;
        
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
            
            [self Loading:[NSURL URLWithString:@"http://www.revide.com.br/api_revide/lista_promocoes.php"]];
            break;
        }
        case ReachableViaWWAN: {
            self->internetActive = YES;
             [self Loading:[NSURL URLWithString:@"http://www.revide.com.br/api_revide/lista_promocoes.php"]];
            
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

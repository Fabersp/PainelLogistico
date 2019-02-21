//
//  GessagemTVC.m
//  AppDoAgronomo
//
//  Created by Fabricio Aguiar de Padua on 14/08/14.
//  Copyright (c) 2014 Pro Master Solution. All rights reserved.
//

#import "ColheitaTVC.h"
#import "ColheitaCell.h"
#import "ViewNoticias.h"
#import "Reachability.h"
#import "SWRevealViewController.h"
#import <TSMessages/TSMessageView.h>
#import "MBProgressHUD.h"




@interface ColheitaTVC ()

@end

@implementation ColheitaTVC



@synthesize ViewApper;
@synthesize TitlePurchase;
@synthesize DescriptionPurchase;
@synthesize ValuePurchase;
@synthesize idCategoria;
@synthesize verificaNoticias;
@synthesize UrlMontadada;
@synthesize idViewNoticia, categoriaNoticia;

- (void)viewDidLoad
{
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
    
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.navigationController.navigationBar.translucent = NO;
    
    // Esta carregando tudo dentro da verificacao da internet.
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(Loading) forControlEvents:UIControlEventValueChanged];
    
    
}

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}



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
            [self CarregarTudo];
            break;
        }
        case ReachableViaWWAN: {
            [self CarregarTudo];
            self->internetActive = YES;
            
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

-(void)CarregarTudo{
    [self Loading];

    
}


- (NSManagedObjectContext *) managedObjectContext
{
    NSManagedObjectContext * context = nil;
    id delegate = [[UIApplication sharedApplication]delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) SetarEdicoes_Default{
    
    NSURL * url = [NSURL URLWithString:@"http://www.revide.com.br/api_revide/listaEdicoes_ios.php"];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask * task =
    [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSData * jsonData = [[NSData alloc] initWithContentsOfURL:location];
        ListaIDEdicoes = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            NSUserDefaults * btnDownload = [NSUserDefaults standardUserDefaults];
            
            for (NSInteger i = 0; i < ListaIDEdicoes.count; i ++) {
                
                NSString * Edicao = [[ListaIDEdicoes objectAtIndex:i] objectForKey:@"edicao"];
                NSString * VerificaEdicao = [btnDownload valueForKey:Edicao]; // esta Salvando o numero da ID ex. 1, 2, 3, 4, 5 do tipo bool
                
                if (VerificaEdicao == NULL) {
                    [btnDownload setBool:false forKey:Edicao];
                }
            }
            [btnDownload synchronize];
        });
    }];
    [task resume];
}


-(void)Loading{
    
    if (internetActive){
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.dimBackground = YES;
        
        UrlMontadada = @"http://www.revide.com.br/api_revide/ultimasnoticias_ios.php";
        self.title = @"Últimas notícias";
        
        
         NSURL * url = [NSURL URLWithString:UrlMontadada];
        
        NSURLSession * session = [NSURLSession sharedSession];
        
        NSURLSessionDownloadTask * task =
        [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            NSData * jsonData = [[NSData alloc] initWithContentsOfURL:location];
            noticiasRecentes = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [refreshControl endRefreshing];
                
                [self.tableView reloadData];
                [self SetarEdicoes_Default];
                
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
    return noticiasRecentes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ColheitaCell * cell = (ColheitaCell *)[tableView dequeueReusableCellWithIdentifier:@"CalagemCell"];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = cell.backgroudTexto.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (__bridge id)UIColor.clearColor.CGColor,
                       UIColor.whiteColor.CGColor,
                       UIColor.whiteColor.CGColor,
                       UIColor.clearColor.CGColor,
                       nil];
    gradient.locations = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0],
                          [NSNumber numberWithFloat:1.0/16],
                          [NSNumber numberWithFloat:15.0/16],
                          [NSNumber numberWithFloat:1],
                          nil];
    cell.backgroudTexto.layer.mask = gradient;
    
    NSURL * urlImage = [NSURL URLWithString:[[noticiasRecentes objectAtIndex:indexPath.row] objectForKey:@"imagem"]];
    
    
    cell.ImgFundo.image = [UIImage imageNamed:@"loading_materia"];
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:urlImage completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    ColheitaCell * updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                    if (updateCell)
                        updateCell.ImgFundo.image = image;
                });
            }
        }
    }];
    [task resume];
    
    cell.edCategoria.text      = [NSString stringWithFormat:@" %@  " , [[noticiasRecentes objectAtIndex:indexPath.row] objectForKey:@"categoria"]];
    
    cell.edDetalheNoticias.text = [[noticiasRecentes objectAtIndex:indexPath.row] objectForKey:@"titulo"];
    

    
    return cell;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
        ObjetoJson = [noticiasRecentes objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        
        NSString * idNoticia = [ObjetoJson objectForKey:@"id"];
        
        if ([[segue identifier] isEqualToString:@"segueNoticias"]) {
            ViewNoticias * destViewController = segue.destinationViewController;
            destViewController.idViewNoticia = idNoticia;
            
        }
   }




@end

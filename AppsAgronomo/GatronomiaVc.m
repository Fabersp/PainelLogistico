//
//  GatronomiaVc.m
//  AppsAgronomo
//
//  Created by Fabricio Padua on 11/08/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import "GatronomiaVc.h"
#import "GastronomiaCell.h"

#import <TSMessages/TSMessageView.h>
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "Map.h"

@interface GatronomiaVc ()

@end

@implementation GatronomiaVc

@synthesize table;
@synthesize imageArray;
@synthesize scrollView;
@synthesize pageControl;
@synthesize idView;
@synthesize NumMenu;
@synthesize Endereco;
@synthesize onde;
@synthesize telefone;
@synthesize UrlImagem;
@synthesize estabelecimento;
@synthesize texto;
@synthesize imgView;
@synthesize viewSinopseRest;


- (void)viewDidLoad {
    [super viewDidLoad];
    table.dataSource = self;
    
    self.title = estabelecimento;
    
    NSUInteger characterCount = [texto length];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    NSString *html = texto;
    NSAttributedString *attr = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUTF8StringEncoding]
                                                                options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                          NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)}
                                                     documentAttributes:nil
                                                                  error:nil];
    
    NSString *finalString = [attr string];
    
    
    if (characterCount > 200) {
        
        _txt_SnopseRestaurante.text = finalString;
        
    } else if (characterCount > 100 && characterCount < 200) {
        
        _txt_SnopseRestaurante.text = finalString;
        
        CGRect frame = self.viewSinopseRest.frame;
        frame.size.height = 88;
        self.viewSinopseRest.frame = frame;
    
    } else {
        _txt_SnopseRestaurante.hidden = YES;
        
        CGRect frame = self.viewSinopseRest.frame;
        frame.size.height = 0;
        self.viewSinopseRest.frame = frame;
        
    }
    
    NSString * UrlHoriarios = [NSString stringWithFormat:@"http://www.revide.com.br/api_revide/lista_horarios.php?id=%@", idView];
    
    [self LoadingHorarios:[NSURL URLWithString:UrlHoriarios]];
    
    self.navigationController.navigationBar.translucent = NO;
    
}
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GastronomiaCell *cell = (GastronomiaCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSString * logradouro = [[lista objectAtIndex:indexPath.row]  objectForKey:@"logradouro"];
    NSString * numero = [[lista objectAtIndex:indexPath.row]  objectForKey:@"numero"];
    NSString * Cidade = [[lista objectAtIndex:indexPath.row]  objectForKey:@"cidade"];
    NSString * estado = [[lista objectAtIndex:indexPath.row]  objectForKey:@"estado"];
    
    Endereco = [NSString stringWithFormat:@"%@, %@, %@ - %@", logradouro, numero, Cidade, estado];
    
    
    cell.lbEndereco.text = Endereco;
    
    NSString * fone = [[lista objectAtIndex:indexPath.row] objectForKey:@"telefone"];
    NSString * facebook = [[lista objectAtIndex:indexPath.row] objectForKey:@"facebook"];
    NSString * site = [[lista objectAtIndex:indexPath.row] objectForKey:@"site"];
    
    // preciso fazer um laco que pegue os enderecos para cada linha //
    
    NSString * Id_endereco = [[lista objectAtIndex:indexPath.row] objectForKey:@"id"];
    NSString * txtHorario = @"";
    
//    CGRect frame = self.viewSinopseRest.frame;
//    frame.size.height = 88;
//    self.viewSinopseRest.frame = frame;
    
    
    
    if (horarios.count > 0) {
        
        for (NSInteger i = 0; i < horarios.count; i ++) {
            
            NSString * endereco_id = [[horarios objectAtIndex:i] objectForKey:@"endereco_id"];
            
            if ([Id_endereco isEqualToString:endereco_id]) {
                cell.txtHorarios.hidden = NO;
                
                txtHorario = [NSString stringWithFormat:@"%@ %@ <br>", txtHorario, [[horarios objectAtIndex:i] objectForKey:@"horarios"]];
            }
            
        }
        NSString *html = txtHorario;
        NSAttributedString *attr = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUTF8StringEncoding]
                                                                    options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                              NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)}
                                                         documentAttributes:nil
                                                                      error:nil];
        
        NSString *finalString = [attr string];
        
        NSLog(@"Lista horarios: %@", finalString);
        
        cell.txtHorarios.text = finalString;
        cell.txtHorarios.hidden = NO;
        
    } else {
        cell.txtHorarios.hidden = YES;
    }
    
    cell.btnFacebook.layer.cornerRadius = 5.0f;
    cell.btnFacebook.layer.masksToBounds = YES;
    
    cell.btnSite.layer.cornerRadius = 5.0f;
    cell.btnSite.layer.masksToBounds = YES;
    
    
    cell.btnTelefone.tag = indexPath.row;   // ex.Tag = 0
    [cell.btnTelefone addTarget:self action:@selector(btnTelefoneClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if ([fone  isEqual: @""]) {
        cell.btnTelefone.enabled = YES;
    }
    
    if ([facebook isEqual:@""]) {
        cell.btnFacebook.hidden = YES;
    }
    if ([site isEqual:@""]) {
        cell.btnSite.hidden = YES;
    }
    
    cell.btnFacebook.tag = indexPath.row;   // ex.Tag = 0
    [cell.btnFacebook addTarget:self action:@selector(btnFacebookClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnMap.tag = indexPath.row;   // ex.Tag = 0
    [cell.btnMap addTarget:self action:@selector(btnMapClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnSite.tag = indexPath.row;   // ex.Tag = 0
    [cell.btnSite addTarget:self action:@selector(btnSiteClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
//-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath
//{
//    if ([expandedPaths containsObject:indexPath]) {
//        return 80;
//    } else {
//        return 44;
//    }
//}


- (void)btnFacebookClick:(UIButton *)sender {
    
    NSString * facebook = [[lista objectAtIndex:sender.tag]  objectForKey:@"facebook"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: facebook]];
    
}

- (void)btnSiteClick:(UIButton *)sender {
    
    NSString * site = [[lista objectAtIndex:sender.tag]  objectForKey:@"site"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: site]];
    
}

- (void)btnMapClick:(UIButton *)sender {
    
    NSString * logradouro = [[lista objectAtIndex:sender.tag]  objectForKey:@"logradouro"];
    NSString * numero = [[lista objectAtIndex:sender.tag]  objectForKey:@"numero"];
    NSString * Cidade = [[lista objectAtIndex:sender.tag]  objectForKey:@"cidade"];
    NSString * estado = [[lista objectAtIndex:sender.tag]  objectForKey:@"estado"];
    
    Endereco = [NSString stringWithFormat:@"%@, %@, %@ - %@", logradouro, numero, Cidade, estado];
    
    Map * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"1234"];
    
    vc.endereco = Endereco;
    vc.cinema = estabelecimento;
    //vc.onde = onde;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)btnTelefoneClick:(UIButton *)sender {
    
    NSString * NumTelefone = [NSString stringWithFormat:@"tel:%@",[[lista objectAtIndex:sender.tag] objectForKey:@"telefone"]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:NumTelefone]];
}

-(void) Loading:(NSURL *) urlLista {
    
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask * task =
    [session downloadTaskWithURL:urlLista completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSData * jsonData = [[NSData alloc] initWithContentsOfURL:location];
        lista = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.table reloadData];
            
        });
    }];
    [task resume];
}
-(void) LoadingHorarios:(NSURL *) urlLista {
    
    if (internetActive) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.dimBackground = YES;
        
        NSURLSession * session = [NSURLSession sharedSession];
        
        NSURLSessionDownloadTask * task =
        [session downloadTaskWithURL:urlLista completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            NSData * jsonData = [[NSData alloc] initWithContentsOfURL:location];
            horarios = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString * Urlfotos = [NSString stringWithFormat:@"http://www.revide.com.br/api_revide/lista_galeria.php?id=%@", idView];
                
                [self LoadingFotos:[NSURL URLWithString:Urlfotos]];
                
                NSString * UrlMontadada = [NSString stringWithFormat:@"http://www.revide.com.br/api_revide/detalhe_gastronomia.php?id=%@", idView];
                
                [self Loading:[NSURL URLWithString:UrlMontadada]];
                
                hud.hidden = YES;
                
            });
            
        }];
        [task resume];
    }
    
}

-(void) LoadingFotos:(NSURL *) urlLista {
    
    if (internetActive) {
        
        NSURLSession * session = [NSURLSession sharedSession];
        
        NSURLSessionDownloadTask * task =
        [session downloadTaskWithURL:urlLista completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            NSData * jsonData = [[NSData alloc] initWithContentsOfURL:location];
            fotos = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
               if (fotos == nil || [fotos count] == 0) {
                   pageControl.hidden = YES;
                   
                   CGRect frame;
                   
                   frame.origin.x = scrollView.frame.size.width * 0;
                   frame.origin.y = 0;
                   frame.size = scrollView.frame.size;
                   
                   UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
                   
                   dispatch_async(dispatch_get_global_queue(0,0), ^{
                       NSData * data = [[NSData alloc] initWithContentsOfURL:UrlImagem];
                       if ( data == nil )
                           return;
                       dispatch_async(dispatch_get_main_queue(), ^{
                           // WARNING: is the cell still using the same data by this point??
                           imageView.image = [UIImage imageWithData: data];
                       });
                       
                   });
                   
                   [scrollView addSubview:imageView];
                   
                   scrollView.pagingEnabled = YES;
                   scrollView.delegate = self;
                   scrollView.userInteractionEnabled = YES;
                   scrollView.showsHorizontalScrollIndicator = NO;
                   scrollView.translatesAutoresizingMaskIntoConstraints = NO;
                   
                   pageControl.hidden = YES;
                   pageControl.currentPage = 0;
                   
                   //Set the content size of our scrollview according to the total width of our imageView objects.
                   scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 0, scrollView.frame.size.height);


               } else {
                   
                   
                   for (int i = 0; i < [fotos count]; i++) {
                       //We'll create an imageView object in every 'page' of our scrollView.
                       CGRect frame;
                       
                       frame.origin.x = scrollView.frame.size.width * i;
                       frame.origin.y = 0;
                       frame.size = scrollView.frame.size;
                       
                       UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
                       
                       dispatch_async(dispatch_get_main_queue(), ^{
                           
                           NSURL * urlImage = [NSURL URLWithString:[[fotos objectAtIndex:i] objectForKey:@"imagem"]];
                           
                           NSURLSession * session = [NSURLSession sharedSession];
                           
                           NSURLSessionDownloadTask * task = [session downloadTaskWithURL:urlImage
                                                                        completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                                            
                                                                            NSData * imageData = [[NSData alloc] initWithContentsOfURL:location];
                                                                            UIImage *img = [UIImage imageWithData:imageData];
                                                                            
                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                imageView.image = img;
                                                                                
                                                                                
                                                                            });
                                                                        }];
                           [task resume];
                           
                       });
                       
                       [scrollView addSubview:imageView];
                   }
                   
                   // a page is the width of the scroll view
                   scrollView.pagingEnabled = YES;
                   scrollView.delegate = self;
                   scrollView.userInteractionEnabled = YES;
                   scrollView.showsHorizontalScrollIndicator = NO;
                   scrollView.translatesAutoresizingMaskIntoConstraints = NO;
                   
                   pageControl.hidden = NO;
                   pageControl.numberOfPages = fotos.count;
                   pageControl.currentPage = 0;
                   
                   //Set the content size of our scrollview according to the total width of our imageView objects.
                   scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [fotos count], scrollView.frame.size.height);
                   
               }
            });
            
        }];
        [task resume];
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
            NSString * UrlHoriarios = [NSString stringWithFormat:@"http://www.revide.com.br/api_revide/lista_horarios.php?id=%@", idView];
            
            [self LoadingHorarios:[NSURL URLWithString:UrlHoriarios]];
            
            break;
        }
        case ReachableViaWWAN: {
            self->internetActive = YES;
            NSString * UrlHoriarios = [NSString stringWithFormat:@"http://www.revide.com.br/api_revide/lista_horarios.php?id=%@", idView];
            
            [self LoadingHorarios:[NSURL URLWithString:UrlHoriarios]];
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

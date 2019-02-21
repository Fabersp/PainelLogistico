//
//  Gastronomia.m
//  AppsAgronomo
//
//  Created by Fabricio Padua on 24/07/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import "Gastronomia.h"
#import <TSMessages/TSMessageView.h>
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "Map.h"
#import "GastronomiaCell.h"
#import "GastronomiaHeader.h"

@interface Gastronomia () <UIScrollViewDelegate>

@end

@implementation Gastronomia

@synthesize idView;
@synthesize NumMenu;
@synthesize lbTitulo;
@synthesize lbOnde;
@synthesize lbDetalhes;
@synthesize lbQuando;
@synthesize lbEndereco;
@synthesize TextDetalhes;
@synthesize lbQuanto;
@synthesize obInformacoes;
@synthesize Endereco;
@synthesize onde;
@synthesize telefone;
@synthesize UrlImagem;
@synthesize estabelecimento;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = estabelecimento;
    
    NSString * UrlHoriarios = [NSString stringWithFormat:@"http://www.revide.com.br/api_revide/lista_horarios.php?id=%@", idView];
    
    [self LoadingHorarios:[NSURL URLWithString:UrlHoriarios]];
    self.navigationController.navigationBar.translucent = NO;
}

-(void) Loading:(NSURL *) urlLista {
    
    
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
                
                NSLog(@"%@", fotos);
                
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 186.0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return lista.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GastronomiaCell *cell = (GastronomiaCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
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
    
    if (horarios.count > 0) {
        
        for (NSInteger i = 0; i < horarios.count; i ++) {
            
            if (Id_endereco == [[horarios objectAtIndex:i] objectForKey:@"endereco_id"]){
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
        
        cell.txtHorarios.text = finalString;
        
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


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    GastronomiaHeader * headerCell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
    
    //fotos = [[NSArray alloc] initWithObjects:@"img01.jpg", @"img02.jpg",  @"img03.jpg",  @"img04.jpg",  @"img05.jpg",  @"img06.jpg", nil];
    
    
    
    
//    pageControl.numberOfPages = imageArray.count;
//    pageControl.currentPage = 0;
//    
//    Set the content size of our scrollview according to the total width of our imageView objects.
   //
//    
//    headerCell.imgHeader.image = [UIImage imageNamed:@"loading_materia"];
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        NSURLSession * session = [NSURLSession sharedSession];
//        
//        NSURLSessionDownloadTask * task = [session downloadTaskWithURL:UrlImagem
//                                                     completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
//                                                         
//                                                         NSData * imageData = [[NSData alloc] initWithContentsOfURL:location];
//                                                         UIImage *img = [UIImage imageWithData:imageData];
//                                                         
//                                                         dispatch_async(dispatch_get_main_queue(), ^{
//                                                             headerCell.imgHeader.image = img;
//                                                         });
//                                                     }];
//        [task resume];
//        
//    });
//
//    headerCell.lbEstabelecimento.text = self.title;
    
    if (fotos.count > 1 ){
        
        //    pageControl.numberOfPages = imageArray.count;
        //    pageControl.currentPage = 0;
    
        headerCell.btnFotos.hidden = NO;
        [headerCell.btnFotos addTarget:self action:@selector(btnFotosClick:) forControlEvents:UIControlEventTouchUpInside];
    
    }
    return headerCell;

}
- (void)btnFotosClick:(UIButton *)sender {
    
    NSMutableArray * photos = [[NSMutableArray alloc] init];
    MWPhoto *photo;
    
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = YES;
    BOOL enableGrid = YES;
    BOOL startOnGrid = YES;
    BOOL autoPlayOnAppear = YES;
    
    // buscar e carregar fotos no array abaixo //

    for (NSInteger i = 0; i < fotos.count; i++){
        
        NSURL *fileURL = [NSURL URLWithString:[[fotos objectAtIndex:i]  objectForKey:@"imagem"]];
        // Photos
        photo = [MWPhoto photoWithURL:fileURL];
        photo.caption = [[fotos objectAtIndex:i]  objectForKey:@"legenda"];
        
        [photos addObject:photo];
    }
    
    self.photos = photos;
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = YES;
    browser.autoPlayOnAppear = autoPlayOnAppear;
    [browser setCurrentPhotoIndex:0];
    
    
    // Reset selections
    if (displaySelectionButtons) {
        _selections = [NSMutableArray new];
        for (int i = 0; i < photos.count; i++) {
            [_selections addObject:[NSNumber numberWithBool:NO]];
        }
    }
    
    [self.navigationController pushViewController:browser animated:YES];
}



- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    return [[_selections objectAtIndex:index] boolValue];
}

//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
//    return [NSString stringWithFormat:@"Photo %lu", (unsigned long)index+1];
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
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

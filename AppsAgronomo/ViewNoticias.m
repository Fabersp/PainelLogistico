//
//  ViewNoticias.m
//  AppsAgronomo
//
//  Created by Fabricio Padua on 29/06/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import "ViewNoticias.h"

#import "Reachability.h"
#import <TSMessages/TSMessageView.h>
#import "MBProgressHUD.h"


@interface ViewNoticias ()

@end

@implementation ViewNoticias


@synthesize idViewNoticia;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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

- (IBAction)btnShare:(id)sender {
    
    
    NSURL *urlMateria = URLShare;
    
    NSArray *objectsToShare = @[urlMateria];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    // Exclude all activities
    NSArray *excludedActivities = @[UIActivityTypePostToWeibo,
                                    UIActivityTypeMessage,
                                    UIActivityTypeMail,
                                    UIActivityTypePrint,
                                    UIActivityTypeCopyToPasteboard,
                                    UIActivityTypeAssignToContact,
                                    UIActivityTypeSaveToCameraRoll,
                                    UIActivityTypeAddToReadingList,
                                    UIActivityTypePostToFlickr,
                                    UIActivityTypePostToVimeo,
                                    UIActivityTypePostToTencentWeibo];
    
    controller.excludedActivityTypes = excludedActivities;
    
    // Present the controller
    [self presentViewController:controller animated:YES completion:nil];
}

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

-(void) checkNetworkStatus:(NSNotification *)notice {
    // called after network status changes
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus) {
        case NotReachable: {
            
            self->internetActive = NO;
                [self MensagemErro];
//            _categoria.hidden = YES;
//            _descricao.hidden = YES;
//            _publicadopor.hidden = YES;
//            _dataHora.hidden = YES;
//            _textoMateria.hidden = YES;
//            _imgbg.hidden = YES;
//            _detalhe2.hidden = YES;
//            _imgAvatar.hidden = YES;
//            _imgClock.hidden = YES;
//            _creditoImagem.hidden = YES;
            
            break;
        }
        case ReachableViaWiFi: {
            self->internetActive = YES;
                [self Loading:idViewNoticia];
            break;
        }
        case ReachableViaWWAN: {
        
            self->internetActive = YES;
            [self Loading:idViewNoticia];
            
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





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)Loading:(NSString *) idNoticia{
    
//     NSString * UrlMontadada = [NSString stringWithFormat:@"http://www.omdbapi.com/?t=%@",idNoticia];
    
    if (internetActive){
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.dimBackground = YES;
        
        
        NSString * UrlMontadada = [NSString stringWithFormat:@"http://www.revide.com.br/api_revide/detalhenoticia_ios.php?id=%@", idNoticia];
        
        NSURL * url = [NSURL URLWithString:UrlMontadada];
        
        NSURLSession * session = [NSURLSession sharedSession];
        
        NSURLSessionDownloadTask * task =
        [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            NSData * jsonData = [[NSData alloc] initWithContentsOfURL:location];
            
            detalheNoticia = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSURL * urlImage = [NSURL URLWithString:[[detalheNoticia objectAtIndex:0] objectForKey:@"imagem"]];
                
                NSURLSession * session = [NSURLSession sharedSession];
                
                NSURLSessionDownloadTask * task = [session downloadTaskWithURL:urlImage
                                                             completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                                 
                                                                 NSData * imageData = [[NSData alloc] initWithContentsOfURL:location];
                                                                 UIImage *img = [UIImage imageWithData:imageData];
                                                                 
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                     _imgbg.image = img;
                                                                 });
                                                             }];
                [task resume];
                
                _Categoria2.text = [NSString stringWithFormat:@" %@ " , [[detalheNoticia objectAtIndex:0] objectForKey:@"categoria"]];
                _detalhe2.text = [[detalheNoticia objectAtIndex:0] objectForKey:@"olho"];
                _descricao.text = [[detalheNoticia objectAtIndex:0] objectForKey:@"titulo"];
                _publicadopor.text = [[detalheNoticia objectAtIndex:0] objectForKey:@"nome"];
                
                
                NSString *html = [[detalheNoticia objectAtIndex:0] objectForKey:@"noticia"];
                NSAttributedString *attr = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUTF8StringEncoding]
                                                                            options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                      NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)}
                                                                 documentAttributes:nil
                                                                              error:nil];
//                NSLog(@"html: %@", html);
//                NSLog(@"attr: %@", attr);
//                NSLog(@"string: %@", [attr string]);
                NSString *finalString = [attr string];
                
                _textoMateria.text = finalString;
                
            
                URLShare = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.revide.com.br/noticias/%@", [[detalheNoticia objectAtIndex:0] objectForKey:@"urlNoticia"]]];
                
                 NSLog(@"UrlNoticia: %@", URLShare);
                
                _dataHora.text = [[detalheNoticia objectAtIndex:0] objectForKey:@"alteracao"];
                _creditoImagem.text = [NSString stringWithFormat:@"Crédito da Imagem %@",[[detalheNoticia objectAtIndex:0] objectForKey:@"credito"]];
                _Categoria2.hidden = NO;
                _descricao.hidden = NO;
                _publicadopor.hidden = NO;
                _dataHora.hidden = NO;
                _textoMateria.hidden = NO;
                _imgbg.hidden = NO;
                _detalhe2.hidden = NO;
                _imgAvatar.hidden = NO;
                _imgClock.hidden = NO;
                _creditoImagem.hidden = NO;
                hud.hidden = YES;
                
            });
            
        }];
        [task resume];
        
    } else {
        [self MensagemErro];
        
    }
    
    
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

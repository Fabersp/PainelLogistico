//
//  DetalhesPromocao.m
//  AppsAgronomo
//
//  Created by Fabricio Padua on 16/08/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import "DetalhesPromocao.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import <TSMessages/TSMessageView.h>

@interface DetalhesPromocao ()

@end

@implementation DetalhesPromocao


@synthesize text_Capa;
@synthesize descricao;
@synthesize resenha;
@synthesize UrlImagem;
@synthesize id_Vigencia;
@synthesize lbPromocao;
@synthesize lbDescricao;
@synthesize txNome;
@synthesize txEmail;
@synthesize txIdade;
@synthesize txTelefone;
@synthesize btnParticipar;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    btnParticipar.layer.cornerRadius = 6.0f;
    btnParticipar.layer.masksToBounds = YES;
    
    lbPromocao.text = text_Capa;
    self.title = text_Capa;
    
    self.navigationController.navigationBar.translucent = NO;
    
    NSString *html = descricao;
    NSAttributedString *attr = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUTF8StringEncoding]
                                                                options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                          NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)}
                                                     documentAttributes:nil
                                                                  error:nil];
    
    NSString *finalString = [attr string];
    
    lbDescricao.text = finalString;
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask * task = [session downloadTaskWithURL:UrlImagem
                                                 completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                     
                                                     NSData * imageData = [[NSData alloc] initWithContentsOfURL:location];
                                                     UIImage *img = [UIImage imageWithData:imageData];
                                                     
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         _imgCapa.image = img;
                                                     });
                                                 }];
    [task resume];
    
    lbPromocao.hidden = NO;
    lbDescricao.hidden = NO;
    
    
}


- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (IBAction)btnParticipar:(id)sender {
    
    if (![self validateEmailWithString:txEmail.text]) {
        
        UIAlertController * view =  [UIAlertController
                                     alertControllerWithTitle:@"Erro"
                                     message:@"O e-mail digitado está incorreto!"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * ok = [UIAlertAction
                              actionWithTitle:@"Ok"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action) {
                                  
                                  [view dismissViewControllerAnimated:YES completion:nil];
                                  
                              }];
        
        [view addAction:ok];
        [self presentViewController:view animated:NO completion:nil];
        
    } else {
        
        NSString * UrlMontadada = [NSString stringWithFormat:@"http://www.revide.com.br/api_revide/verifica.php?email=%@&id_vigencia=%@", txEmail.text, id_Vigencia];
        
        NSURL * url = [NSURL URLWithString:UrlMontadada];
        
        [self Loading:url];
    }
}


-(void) Loading:(NSURL *) urlLista {
    
    if (internetActive){
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.dimBackground = YES;
        
        NSURLSession * session = [NSURLSession sharedSession];
        
        NSURLSessionDownloadTask * task =
        [session downloadTaskWithURL:urlLista completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            NSData * jsonData = [[NSData alloc] initWithContentsOfURL:location];
            lista = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([lista count] > 0) {
                    
                    UIAlertController * view =  [UIAlertController
                                                 alertControllerWithTitle:@"Erro"
                                                 message:@"Este e-mail já está participando desta promoção!"
                                                 preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction * ok = [UIAlertAction
                                          actionWithTitle:@"Ok"
                                          style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * action) {
                                              
                                              [view dismissViewControllerAnimated:YES completion:nil];
                                              
                                          }];
                    
                    [view addAction:ok];
                    [self presentViewController:view animated:NO completion:nil];
                    
                } else {
                    
                    NSString *post = [NSString stringWithFormat:@"nome=%@&idade=%@&email=%@&telefone=%@&id_vigencia=%@", txNome.text, txIdade.text,txEmail.text, txTelefone.text, id_Vigencia];
                    
                    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                    
                    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
                    
                    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.revide.com.br/api_revide/inserir.php"]]];
                    
                    [request setHTTPMethod:@"POST"];
                    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
                    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
                    [request setHTTPBody:postData];
                    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
                    if(conn)
                    {
                        UIAlertController * view =  [UIAlertController
                                                     alertControllerWithTitle:@"Mensagem"
                                                     message:@"Sua participação foi cadastrada com sucesso!"
                                                     
                                                     preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction * ok = [UIAlertAction
                                              actionWithTitle:@"Ok"
                                              style:UIAlertActionStyleDefault
                                              handler:^(UIAlertAction * action) {
                                                  // retorna para o View //
                                                  
                                                  
                                                  
                                                  [view dismissViewControllerAnimated:YES completion:nil];
                                                  
                                                  [self.navigationController popViewControllerAnimated:NO];
                                                  
                                                  
                                              }];
                        
                        [view addAction:ok];
                        [self presentViewController:view animated:NO completion:nil];
                        
                    }
                    else
                    {
                        UIAlertController * view =  [UIAlertController
                                                     alertControllerWithTitle:@"Erro"
                                                     message:@"Houve um erro com o servidor, tente mais tarde!"
                                                     
                                                     preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction * ok = [UIAlertAction
                                              actionWithTitle:@"Ok"
                                              style:UIAlertActionStyleDefault
                                              handler:^(UIAlertAction * action) {
                                                  // retorna para o View //
                                                  
                                                  
                                                  
                                                  [view dismissViewControllerAnimated:YES completion:nil];
                                                  
                                                  [self.navigationController popViewControllerAnimated:NO];
                                                  
                                                  
                                              }];
                        
                        [view addAction:ok];
                        [self presentViewController:view animated:NO completion:nil];
                    }
                    
                }
                
                hud.hidden = YES;
                
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
            
            break;
        }
        case ReachableViaWWAN: {
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


@end

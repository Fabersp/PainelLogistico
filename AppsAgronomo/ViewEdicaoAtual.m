//
//  ViewEdicaoAtual.m
//  AppsAgronomo
//
//  Created by Fabricio Padua on 30/06/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import "ViewEdicaoAtual.h"
#import "SWRevealViewController.h"
#import "MBProgressHUD.h"
#import <Photos/Photos.h>
#import "Reachability.h"
#import <TSMessages/TSMessageView.h>




@interface ViewEdicaoAtual ()


@end

@implementation ViewEdicaoAtual

@synthesize pageImages;
@synthesize pastaEdicao;
@synthesize ObjetoJson;
@synthesize imgCapa;
@synthesize ID_Edicao;
@synthesize Edicao;
@synthesize btnDownload;
@synthesize btnExcluirEdAtual;

@synthesize ViewApper;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view.
    [self.navigationController.view addSubview:ViewApper];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

    btnDownload.layer.cornerRadius = 6.0f;
    btnDownload.layer.masksToBounds = YES;
    
    //
    //imgCapa
    
    if ((int)[[UIScreen mainScreen] bounds].size.height == 480)
    {
        // This is iPhone 4/4s screen
        NSLog(@"// This is iPhone 4/4s screen");
        
    }
    
    
        
    // verificar se ja foi feito o download //
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [imgCapa setUserInteractionEnabled:YES];
    [imgCapa addGestureRecognizer:singleTap];
}

- (IBAction)btnExcluirEdAtual:(id)sender {
    
    // perguntar se quer apagar a Edicao Atual //
    // Perguntar se quer apagar ou não //
    // criar a string onde está a edicao atual //
    
    NSString * pthEdiAtual =  [NSString stringWithFormat:@"Revista/%@", Edicao];
    
    if ([self checkIfDirectoryAlreadyExists:pthEdiAtual]) {
        
        UIAlertController * view =  [UIAlertController
                                     alertControllerWithTitle:@"Mensagem"
                                     message:@"Deseja excluir esta Edição?"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * ok = [UIAlertAction
                              actionWithTitle:@"Sim"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action) {
                                  
                                  [self removeImage:pthEdiAtual];
                                  
                                 
                                  NSUserDefaults * edicoesdefout = [NSUserDefaults standardUserDefaults];
                                  
                                  [edicoesdefout setBool:false forKey:Edicao];
                                  
                                  [edicoesdefout synchronize];
                                  
                                  [btnDownload setTitle:@"Download" forState:UIControlStateNormal];
                                  btnExcluirEdAtual.enabled = false;
                                 // [self LoadingPaginas];
                                  
                                  [view dismissViewControllerAnimated:YES completion:nil];
                                  
                              }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Não"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [view addAction:ok];
        [view addAction:cancel];
        [self presentViewController:view animated:NO completion:nil];
        
    } else {
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@"Mensagem"
                                     message:@"Não existem edições para ser excluída"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * ok = [UIAlertAction
                              actionWithTitle:@"OK"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  
                                  [view dismissViewControllerAnimated:YES completion:nil];
                                  
                              }];
        [view addAction:ok];
        [self presentViewController:view animated:NO completion:nil];
    }


}

- (void)removeImage:(NSString *)filename
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:filename];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        NSLog(@"Pasta Apagada %@ ", filename);
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}





- (IBAction)btnDownload:(id)sender {
    
    NSUserDefaults * VerificaEdicao = [NSUserDefaults standardUserDefaults];
    bool Verificar = [VerificaEdicao boolForKey:Edicao];
    
    NSString * pasta    = [NSString stringWithFormat:@"Revista/%@",[[EdicaoAtual objectAtIndex:0] objectForKey:@"PASTA"]];
    NSString * URL      = [[EdicaoAtual objectAtIndex:0]  objectForKey:@"URLREVISTA"];
    NSInteger Paginas   = [[[EdicaoAtual objectAtIndex:0]  objectForKey:@"NUM_PAGINAS"] integerValue];
    
    
    if (!Verificar){
        if (internetActive){
            
            UIAlertController * view =  [UIAlertController
                                         alertControllerWithTitle:@"Mensagem"
                                         message:@"Deseja realizar o download desta edição?"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * ok = [UIAlertAction
                                  actionWithTitle:@"Sim"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action) {
                                      
                                      // verifica qual é o ID que será setado na memória //
                                      if (![self checkIfDirectoryAlreadyExists:@"Revista"]) {
                                          [self criarPasta:@"Revista"];
                                      }
                                      
                                      if (![self checkIfDirectoryAlreadyExists:pasta]) {
                                          [self criarPasta:pasta];
                                          
                                          MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                                          
                                          hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
                                          hud.labelText = @"Carregando...";
                                          
                                          hud.dimBackground = YES;
                                          
                                          dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                                              
                                             [self downloadImage2:pasta :URL :Paginas];
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  hud.hidden = YES;
                                                  [btnDownload setTitle:@"Visualizar" forState:UIControlStateNormal];
                                                  
                                                  NSUserDefaults * VerificaEdicao = [NSUserDefaults standardUserDefaults];
                                                  [VerificaEdicao setBool:true forKey:Edicao];
                                                  [VerificaEdicao synchronize];
                                                  [self VisualizarEdicao:pasta];
                                                  
                                                  
                                              });
                                          });
                                      }
                                      [view dismissViewControllerAnimated:YES completion:nil];
                                      
                                  }];
            UIAlertAction* cancel = [UIAlertAction
                                     actionWithTitle:@"Não"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [view dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
            
            [view addAction:ok];
            [view addAction:cancel];
            [self presentViewController:view animated:NO completion:nil];
        }else {
            [self MensagemErro];
        }
        
    } else {
        [self VisualizarEdicao:pasta];
      //  NSUserDefaults * VerificaEdicao = [NSUserDefaults standardUserDefaults];
       // bool Verificar = [VerificaEdicao boolForKey:Edicao]; // recebe o valor  true or false;
        
      //  if (Verificar) {
      //      imgCapa.alpha = 1.0;
      //  }
        
    }

    
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

-(void) SetarEdicoes_Default{
    
    NSURL * url = [NSURL URLWithString:@"http://www.promastersolution.com.br/x7890_IOS/revistas/api/lista_todas_edicoes.php?tipo_os=IOS&cli=2"];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask * task =
    [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSData * jsonData = [[NSData alloc] initWithContentsOfURL:location];
        ListaIDEdicoes = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSUserDefaults * Download = [NSUserDefaults standardUserDefaults];
            
            for (NSInteger i = 0; i < ListaIDEdicoes.count; i ++) {
                
                NSString * VerificaEdicao = [Download valueForKey:Edicao]; // esta Salvando o numero da ID ex. 1, 2, 3, 4, 5 do tipo bool
                
                if (VerificaEdicao == NULL) {
                    [Download setBool:false forKey:Edicao];
                }
            }
            [Download synchronize];
        });
    }];
    [task resume];
}



-(void)tapDetected{
    
        NSUserDefaults * VerificaEdicao = [NSUserDefaults standardUserDefaults];
        bool Verificar = [VerificaEdicao boolForKey:Edicao];
    
    NSString * pasta    = [NSString stringWithFormat:@"Revista/%@",[[EdicaoAtual objectAtIndex:0] objectForKey:@"PASTA"]];
    NSString * URL      = [[EdicaoAtual objectAtIndex:0]  objectForKey:@"URLREVISTA"];
    NSInteger Paginas   = [[[EdicaoAtual objectAtIndex:0]  objectForKey:@"NUM_PAGINAS"] integerValue];
    
    
        if (!Verificar){
            if (internetActive){
                
                
                
                UIAlertController * view =  [UIAlertController
                                             alertControllerWithTitle:@"Mensagem"
                                             message:@"Deseja realizar o download desta edição?"
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction * ok = [UIAlertAction
                                      actionWithTitle:@"Sim"
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction * action) {
                                          
                                          // verifica qual é o ID que será setado na memória //
                                          if (![self checkIfDirectoryAlreadyExists:@"Revista"]) {
                                              [self criarPasta:@"Revista"];
                                          }
                                          
                                          if (![self checkIfDirectoryAlreadyExists:pasta]) {
                                              [self criarPasta:pasta];
                                              
                                              MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                                              
                                              hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
                                              hud.labelText = @"Carregando...";
                                              
                                              hud.dimBackground = YES;
                                              
                                              dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                                            
                                                   [self downloadImage2:pasta :URL :Paginas];
                                                  
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      
                                                      hud.hidden = YES;
                                                      [btnDownload setTitle:@"Visualizar" forState:UIControlStateNormal];
                                                  
                                                      NSUserDefaults * VerificaEdicao = [NSUserDefaults standardUserDefaults];
                                                      [VerificaEdicao setBool:true forKey:Edicao];
                                                      [VerificaEdicao synchronize];
                                                      
                                                  });
                                              });
                                          }
                                          [view dismissViewControllerAnimated:YES completion:nil];
                                          
                                      }];
                UIAlertAction* cancel = [UIAlertAction
                                         actionWithTitle:@"Não"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             [view dismissViewControllerAnimated:YES completion:nil];
                                             
                                         }];
                
                [view addAction:ok];
                [view addAction:cancel];
                [self presentViewController:view animated:NO completion:nil];
            }else {
                [self MensagemErro];
            }
                
        } else {
            [self VisualizarEdicao:pasta];
            NSUserDefaults * VerificaEdicao = [NSUserDefaults standardUserDefaults];
            bool Verificar = [VerificaEdicao boolForKey:Edicao]; // recebe o valor  true or false;
            
            if (Verificar) {
                imgCapa.alpha = 1.0;
                [btnDownload setTitle:@"Visualizar" forState:UIControlStateNormal];
            }

        }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) criarPasta:(NSString * ) pasta {
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:pasta];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
}




-(BOOL)checkIfDirectoryAlreadyExists:(NSString *)name{
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:name];
    
    BOOL isDir;
    BOOL fileExists = [fileManager fileExistsAtPath:dataPath isDirectory:&isDir];
    
    if (fileExists){
        NSLog(@"Existe Arquivo...");
        
        if (isDir) {
            NSLog(@"Folder already exists...");
        }
    }
    return fileExists;
}

-(void) BucarDadosPasta :(NSString *) Pasta{
    
    pageImages = [[NSMutableArray alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:Pasta];
    
    NSArray * dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dataPath error:NULL];
    [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *filename = (NSString *)obj;
        NSString *extension = [[filename pathExtension] lowercaseString];
        if ([extension isEqualToString:@"jpg"]) {
            [pageImages addObject:[dataPath stringByAppendingPathComponent:filename]];
        }
    }];
    
    NSLog(@"Array: %@ ", pageImages);
    
    
}



-(void) downloadImage2 :(NSString *) pasta :(NSString *) URL :(NSInteger ) Paginas {
    
    // montar o array das urls das imagens //
    for ( NSInteger i = 0; i < Paginas; i++){
        
        NSString * Contador = [NSString stringWithFormat:@"%.3ld", (long)i + 1];
        NSString * UrlMontadada = [NSString stringWithFormat:@"%@/%@.jpg", URL, Contador];
        
        NSURL  *url = [NSURL URLWithString:UrlMontadada];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        if ( urlData ) {
            // pega o nome do arquivo //
            NSArray *parts = [UrlMontadada componentsSeparatedByString:@"/"];
            NSString *filename = [parts lastObject];
            
            // busca a pasta oficial do App //
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            // add na frente da pasta ofical o caminho ex: /Revista/Edicao22  //
            NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:pasta];
            // monta o caminho para ser salvo os aquivos //
            NSString *filePath = [NSString stringWithFormat:@"%@/%@", dataPath, filename];
            // salva os aquivos na pasta //
            //saving is done on main thread
            float ratio = (float)i  / (float)Paginas;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Instead we could have also passed a reference to the HUD
                // to the HUD to myProgressTask as a method parameter.
                [MBProgressHUD HUDForView:self.navigationController.view].progress = (float)ratio;
            });
            usleep(50000);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [urlData writeToFile:filePath atomically:YES];
                
            });
            
        }
    }
}




-(void)Loading{
    
    if (internetActive){
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.dimBackground = YES;
        
        // Buscar as informacoes da edicao atual //
        NSURL * url = [NSURL URLWithString:@"http://www.promastersolution.com.br/x7890_IOS/revistas/api/ultimaedicao.php?tipo_os=IOS&cli=2"];
        
        NSURLSession * session = [NSURLSession sharedSession];
        
        NSURLSessionDownloadTask * task =
        [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            NSData * jsonData = [[NSData alloc] initWithContentsOfURL:location];
            
            EdicaoAtual = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // aqui eu verifico se esta edição está setanda com False
                
                Edicao = [[EdicaoAtual objectAtIndex:0] objectForKey:@"PASTA"]; // ex. ID = 1
                // abrir NSUserDefaults * btnDownload pra ver se foi setado o valor true
                
                ID_Edicao = [[EdicaoAtual objectAtIndex:0] objectForKey:@"EDICAO"];
                
                [self SetarEdicoes_Default];
                
                NSUserDefaults * VerificaEdicao = [NSUserDefaults standardUserDefaults];
                bool Verificar = [VerificaEdicao boolForKey:Edicao]; // recebe o valor  true or false;

                self.title =  [NSString stringWithFormat:@"Edição %@",[[EdicaoAtual objectAtIndex:0] objectForKey:@"EDICAO"]];
                
                
                btnExcluirEdAtual.enabled = Verificar;
               
                
                NSURL * urlImage = [NSURL URLWithString:[[EdicaoAtual objectAtIndex:0] objectForKey:@"URLIMAGEM"]];
                
                NSURLSession * session = [NSURLSession sharedSession];
                
                NSURLSessionDownloadTask * task = [session downloadTaskWithURL:urlImage
                                                             completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                                 
                                                                 NSData * imageData = [[NSData alloc] initWithContentsOfURL:location];
                                                                 UIImage *img = [UIImage imageWithData:imageData];
                                                                 
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                     imgCapa.image = img;
                                                                     
                                                        
                                                                 });
                                                             }];
                
                btnDownload.hidden = NO;
                [task resume];
                
                if (Verificar) {
                    imgCapa.alpha = 1.0;
                    [btnDownload setTitle:@"Visualizar" forState:UIControlStateNormal];

                    
                } else {
                    //[self LoadingPaginas];
                    [btnDownload setTitle:@"Download" forState:UIControlStateNormal];
                   
                }
                
            });
        }];
        [task resume];
        hud.hidden = YES;
    
        imgCapa.hidden = NO;
        
    }
}

-(void) VisualizarEdicao:(NSString * )Pasta {

    NSMutableArray * photos = [[NSMutableArray alloc] init];
    //MWPhoto *photo;
    
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = NO;
    BOOL startOnGrid = NO;
    BOOL autoPlayOnAppear = NO;
    
    // buscar e carregar fotos no array abaixo //
    
    [self BucarDadosPasta:Pasta];
    
    for (NSInteger i = 0; i < pageImages.count; i++){
        
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:pageImages[i]];
        
        [photos addObject:[MWPhoto photoWithURL:fileURL]];
    }
    
    // Options
    enableGrid = NO;
    
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
    browser.enableSwipeToDismiss = NO;
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




@end

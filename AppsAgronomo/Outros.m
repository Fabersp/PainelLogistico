//
//  Teatro.m
//  AppsAgronomo
//
//  Created by Fabricio Padua on 21/07/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import "Outros.h"
#import <TSMessages/TSMessageView.h>
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "Map.h"
#import <EventKit/EventKit.h>

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@interface Outros ()

// EKEventStore instance associated with the current Calendar application
@property (nonatomic, strong) EKEventStore *eventStore;

// Default calendar associated with the above event store
@property (nonatomic, strong) EKCalendar *defaultCalendar;

// Array of all events happening within the next 24 hours
@property (nonatomic, strong) NSMutableArray *eventsList;

@property NSMutableArray *datas;

@end


int addEventGranted;

@implementation Outros

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
@synthesize hora;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    
    if ([NumMenu isEqual: @"1"]){
        NSLog(@"Teatro");
         NSString * UrlMontadada = [NSString stringWithFormat:@"http://www.revide.com.br/api_revide/detalhes_teatro.php?id=%@", idView];
        
        [self Loading:[NSURL URLWithString:UrlMontadada]];

    } else if ([NumMenu  isEqual: @"2"]){
        NSLog(@"Musica");
        NSString * UrlMontadada = [NSString stringWithFormat:@"http://www.revide.com.br/api_revide/detalhes_teatro.php?id=%@", idView];
        
        [self Loading:[NSURL URLWithString:UrlMontadada]];
        
    } else if ([NumMenu  isEqual: @"3"]){
        NSLog(@"Evento");

        NSString * UrlMontadada = [NSString stringWithFormat:@"http://www.revide.com.br/api_revide/detalhes_teatro.php?id=%@", idView];
        [self Loading:[NSURL URLWithString:UrlMontadada]];
        
    } else if ([NumMenu  isEqual: @"4"]){
        NSLog(@"Literiatura");
        NSString * UrlMontadada = [NSString stringWithFormat:@"http://www.revide.com.br/api_revide/detalhes_teatro.php?id=%@", idView];
        [self Loading:[NSURL URLWithString:UrlMontadada]];
    }

}

-(void) Loading:(NSURL *) urlLista {
    
    if (!internetActive){
    
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.dimBackground = YES;
        
        NSURLSession * session = [NSURLSession sharedSession];
        
        NSURLSessionDownloadTask * task =
        [session downloadTaskWithURL:urlLista completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            NSData * jsonData = [[NSData alloc] initWithContentsOfURL:location];
            lista = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                lbTitulo.text = [[lista objectAtIndex:0] objectForKey:@"descricao"];
                
                NSString *html = [[lista objectAtIndex:0] objectForKey:@"detalhes"];
                NSAttributedString *attr = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUTF8StringEncoding]
                                                                            options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                      NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)}
                                                                 documentAttributes:nil
                                                                              error:nil];
                NSString *finalString = [attr string];
                
                TextDetalhes.text = finalString;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSURL * urlImage = [NSURL URLWithString:[[lista objectAtIndex:0] objectForKey:@"imagem"]];
                    
                    NSURLSession * session = [NSURLSession sharedSession];
                    
                    NSURLSessionDownloadTask * task = [session downloadTaskWithURL:urlImage
                                                                 completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                                     
                                                                     NSData * imageData = [[NSData alloc] initWithContentsOfURL:location];
                                                                     UIImage *img = [UIImage imageWithData:imageData];
                                                                     
                                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                                         _ImgCapa.image = img;
                                                                         
                                                                         _ImgCapa.hidden = NO;
                                                                         lbQuando.hidden = NO;
                                                                         lbQuanto.hidden = NO;
                                                                         lbEndereco.hidden = NO;
                                                                         TextDetalhes.hidden = NO;
                                                                         lbTitulo.hidden = NO;
                                                                         lbOnde.hidden = NO;
                                                                         obInformacoes.hidden = NO;
                                                                         _btnMapa.hidden = NO;
                                                                         _btnfone.hidden = NO;
                                                                         _btnAddEvento.hidden = NO;
                                                                         
                                                                         hud.hidden = YES;

                                                                     });
                                                                 }];
                    [task resume];
                    
                });
                
                lbQuando.text = [NSString stringWithFormat:@"Quando: %@", [[lista objectAtIndex:0] objectForKey:@"data"]];
                lbOnde.text = [NSString stringWithFormat:@"Onde: %@", [[lista objectAtIndex:0] objectForKey:@"onde"]];
                
                onde = [[lista objectAtIndex:0] objectForKey:@"onde"];
                
                lbQuanto.text = [NSString stringWithFormat:@"Quanto: %@",[[lista objectAtIndex:0] objectForKey:@"preco"]];
                
                telefone = [[lista objectAtIndex:0] objectForKey:@"telefone"];
                
                NSString * logradouro = [[lista objectAtIndex:0]  objectForKey:@"logradouro"];
                NSString * numero = [[lista objectAtIndex:0]  objectForKey:@"numero"];
                NSString * Cidade = [[lista objectAtIndex:0]  objectForKey:@"cidade"];
                NSString * estado = [[lista objectAtIndex:0]  objectForKey:@"estado"];
                
                Endereco = [NSString stringWithFormat:@"%@, %@, %@ - %@", logradouro, numero, Cidade, estado];
                
                
                
               // NSLog(@"Endereco: %@", Endereco);

                lbEndereco.text = Endereco;
                
                
            });
            
        }];
        [task resume];
        
    }
}

- (IBAction)btnMap:(id)sender {
    
    Map * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"1234"];
    
    vc.endereco = Endereco;
    vc.cinema = onde;
    vc.onde = onde;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)btntelefone:(id)sender {
    
    NSString * strTrim = [[telefone componentsSeparatedByCharactersInSet:
                           [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                          componentsJoinedByString:@""];
    
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", strTrim]]];

    
}

- (int)daysBetween:(NSDate *)dt1 and:(NSDate *)dt2 {
    NSUInteger unitFlags = NSCalendarUnitDay;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    
    return (int)[components day]+1;
    
    
}

-(NSDate * )strToDateFull:(NSString *)dataStr formato:(NSString *)format{
    
    //Identefica qual o formato do objeto da data//
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:-3]];
    NSDate * date = [dateFormat dateFromString:dataStr];
    
    return date;
    
}


- (IBAction)btnAddEvento:(id)sender {
    
    NSString * strDataInicio = [[lista objectAtIndex:0]  objectForKey:@"data_inicial"];
    NSString * strDataFinal = [[lista objectAtIndex:0]  objectForKey:@"data_final"];
    hora = [[lista objectAtIndex:0]  objectForKey:@"hora"];
    NSDate * dtHoje = [NSDate date];
    
    if ([strDataInicio isEqualToString:@""]){
        
        NSDate * data_escolhida = [self strToDateFull:strDataFinal formato:@"yyyy-MM-dd HH:mm:ss"];
        
        NSLog(@"%@",data_escolhida);
        
        [self addEvent:data_escolhida];
        
        
    
    } else {
        
        NSDate * dateInicial = [self strToDateFull:strDataInicio formato:@"yyyy-MM-dd HH:mm:ss"];
        NSDate * dateFinal = [self strToDateFull:strDataFinal formato:@"yyyy-MM-dd HH:mm:ss"];
        
        if( [dateInicial timeIntervalSinceDate:dtHoje] > 0 ) {
        
            dtInicio = dateInicial;
            
        } else {
            dtInicio = dtHoje;
        }
        
        // montar o Array com as datas //
        NSInteger qtdeDias = [self daysBetween:dtInicio and:dateFinal];
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        onlyDate = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < qtdeDias; i ++) {
        
            NSDate *newDate = [dtInicio dateByAddingTimeInterval:60*60*24*i];
        
            NSString * strData = [NSString stringWithFormat:@"%@ - %@h",[self retornaDataString_pt:newDate], hora];
            NSString * strOnlyDate = [self retornaDataString_en:newDate];
                
            [mutableArray addObject:strData];
            [onlyDate addObject:strOnlyDate];
            
        }
        NSLog(@"array %@", mutableArray);
        NSLog(@"Onlydate %@", onlyDate);
        
        self.datas = [mutableArray copy];
        
        CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Datas disponíveis" cancelButtonTitle:@"Cancelar" confirmButtonTitle:@"Confirmar"];
        picker.delegate = self;
        picker.dataSource = self;
        picker.needFooterView = YES;
        picker.headerBackgroundColor = [UIColor whiteColor];
        picker.headerTitleColor = Rgb2UIColor(5, 105, 215);
        picker.cancelButtonBackgroundColor = [UIColor whiteColor];
        picker.cancelButtonNormalColor = Rgb2UIColor(5, 105, 215);
        picker.confirmButtonBackgroundColor = Rgb2UIColor(5, 105, 215);
        
        
        [picker show];
    }
}

-(NSString *)retornaDataString_pt:(NSDate * ) data{
    
    NSDate *date = data;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/YY EE"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"pt_BR"]];
    
    NSString *dateString = [dateFormatter stringFromDate:date];
   
    return dateString;
}

-(NSString *)retornaDataString_en:(NSDate * ) data{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateString = [dateFormatter stringFromDate:data];
    
    return dateString;
}


- (NSString *)czpickerView:(CZPickerView *)pickerView
               titleForRow:(NSInteger)row{
    return self.datas[row];
}

- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
    return self.datas.count;
}

- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row{
    NSLog(@"%@ is chosen!", self.datas[row]);
    
    NSString * dataOnly = [NSString stringWithFormat:@"%@ %@", [onlyDate objectAtIndex:row], hora];
    
    NSDate * data_escolhida = [self strToDateFull:dataOnly formato:@"yyyy-MM-dd HH:mm"];
    
    NSLog(@"%@",data_escolhida);
    
    [self addEvent:data_escolhida];

}

- (void)czpickerViewDidClickCancelButton:(CZPickerView *)pickerView{
    NSLog(@"Canceled.");
}


-(void)addEvent:(NSDate *)dataEscolhida {
    
    UIAlertController * view =  [UIAlertController
                                 alertControllerWithTitle:@"Mensagem"
                                 message:@"Deseja adicionar este evento ao Calendário?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * ok = [UIAlertAction
                          actionWithTitle:@"Sim"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action) {
                              
                              NSTimeInterval secondsInEightHours = 3 * 60 * 60;
                              NSDate *dateEightHoursAhead = [dataEscolhida dateByAddingTimeInterval:secondsInEightHours];
                              
                              NSLog(@"data escolhida %@", dateEightHoursAhead);
                              
                              // NSTimeInterval duashoras = 2 * 60 * 60;
                              
                              EKEventStore * eventStore = [[EKEventStore alloc]init];
                              if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]){
                                  [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
                                      if (granted){
                                          addEventGranted = 1;
                                          EKEvent * event = [EKEvent eventWithEventStore:eventStore];
                                          
                                          [event setTitle:lbTitulo.text];
                                          [event setStartDate:dateEightHoursAhead];
                                          [event setEndDate:dateEightHoursAhead];
                                          [event setLocation:Endereco];
                                          [event setNotes:TextDetalhes.text];
                                          
                                          NSTimeInterval alarmOffset = -1*1440*60;
                                          EKAlarm * alarm = [EKAlarm alarmWithRelativeOffset:alarmOffset];
                                          [event addAlarm:alarm];
                                          
                                          [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                                          NSError * err;
                                          [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                                          
                                          [self performSelector:@selector(Alert) withObject:nil afterDelay:0.3];
                                      }
                                  }];
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
    
}

-(void) Alert {
    if (addEventGranted == 1){
        UIAlertView * alert = [[UIAlertView alloc]
                               initWithTitle:@"Mensagem"
                               message:@"Evento foi inserido com sucesso"  delegate:self
                               cancelButtonTitle:@"Ok"
                               otherButtonTitles:nil];
        [alert show];
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
           // [self Loading:[NSURL URLWithString:@"http://www.revide.com.br/api_revide/listamovies_ios.php"]];
            
            break;
        }
        case ReachableViaWWAN: {
            self->internetActive = YES;
           // [self Loading:[NSURL URLWithString:@"http://www.revide.com.br/api_revide/listamovies_ios.php"]];
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

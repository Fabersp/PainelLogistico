//
//  CinemaTable.m
//  AppsAgronomo
//
//  Created by Fabricio Padua on 12/08/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import "CinemaTable.h"
#import "Map.h"
#import "MBProgressHUD.h"
#import <TSMessages/TSMessageView.h>

#import "CinemaTVCell.h"
#import <QuartzCore/QuartzCore.h>




@interface CinemaTable ()




@end


@implementation CinemaTable

@synthesize idViewMovie;
@synthesize descricao;
@synthesize IdVideo;
@synthesize Endereco;
@synthesize Cinema;
@synthesize Onde;
@synthesize viewTop;
@synthesize lbNomeFilme;
@synthesize lbDescricaoFilme;
@synthesize hora;
@synthesize nomeFilme;



- (void)viewDidLoad {
    [super viewDidLoad];
    
   // [self.navigationItem.backBarButtonItem setTitle:@" "];
   // self.navigationController.navigationBar.topItem.title = @"";
    
    CGRect frame;
    
    self.title = nomeFilme;
    
    CGFloat varWidth = [UIScreen mainScreen].bounds.size.width;
    
    frame.size.width = varWidth;
    frame.size.height = 358;
    [self.viewTop setFrame:frame];
    _imgCapa.image = [UIImage imageNamed:@"loading_materia"];
    self.navigationController.navigationBar.translucent = NO;
    
}

- (IBAction)btnYoutube:(id)sender {
    
     NSString * UrlMontadada = [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@", IdVideo];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UrlMontadada]];
    
}

-(void) Loading {
    
    if (internetActive){
        
        NSString * UrlMontadada = [NSString stringWithFormat:@"http://www.revide.com.br/api_revide/detalhesmovies_ios.php?id=%@", idViewMovie];
        
        NSURL * url = [NSURL URLWithString:UrlMontadada];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.dimBackground = YES;
        
        NSURLSession * session = [NSURLSession sharedSession];
        
        NSURLSessionDownloadTask * task =
        [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            NSData * jsonData = [[NSData alloc] initWithContentsOfURL:location];
            ListaCinemas = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                [_ViewTrailer loadWithVideoId:IdVideo];
                
                lbNomeFilme.text = [[ListaCinemas objectAtIndex:0] objectForKey:@"nomeFilme"];
                
               
                
                
                NSString *html = [[ListaCinemas objectAtIndex:0] objectForKey:@"descricao"];
                NSAttributedString *attr = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUTF8StringEncoding]
                                                                            options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                      NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)}
                                                                 documentAttributes:nil
                                                                              error:nil];
                NSString *finalString = [attr string];
                
                lbDescricaoFilme.text = finalString;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSURL * urlImage = [NSURL URLWithString:[[ListaCinemas objectAtIndex:0] objectForKey:@"imagem"]];
                    
                    NSURLSession * session = [NSURLSession sharedSession];
                    
                    NSURLSessionDownloadTask * task = [session downloadTaskWithURL:urlImage
                                                                 completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                                     
                                                                     NSData * imageData = [[NSData alloc] initWithContentsOfURL:location];
                                                                     UIImage *img = [UIImage imageWithData:imageData];
                                                                     
                                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                                         _imgCapa.image = img;
                                                                     });
                                                                 }];
                    [task resume];
                    
                });

                [self.tableView reloadData];
                
                lbDescricaoFilme.hidden = NO;
                lbNomeFilme.hidden = NO;
                
                hud.hidden = YES;
                
            });
            
        }];
        [task resume];
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return ListaCinemas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CinemaTVCell *cell = (CinemaTVCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.txCinema.text = [[ListaCinemas objectAtIndex:indexPath.row] objectForKey:@"cine"];
    cell.txOnde.text = [[ListaCinemas objectAtIndex:indexPath.row] objectForKey:@"onde"];
    cell.txSessao.text = [[ListaCinemas objectAtIndex:indexPath.row] objectForKey:@"detalhes"];
    
    cell.txCinema.hidden = NO;
    cell.txOnde.hidden = NO;
    cell.txSessao.hidden = NO;
    cell.tituloCinema.hidden = NO;
    cell.tituloOnde.hidden = NO;
    cell.tituloSessao.hidden = NO;
    
    
    cell.btnLocation.tag = indexPath.row;
    [cell.btnLocation addTarget:self action:@selector(btnComoChegarClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnLocation.hidden = NO;
    
//    cell.btnEvento.tag = indexPath.row;
//    [cell.btnEvento addTarget:self action:@selector(btnEventoClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnPhone.tag = indexPath.row;
    [cell.btnPhone addTarget:self action:@selector(btnFoneClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnPhone.hidden = NO;
    
    return cell;
}



- (void)btnFoneClick:(UIButton *)sender {
    
    NSString * numPhone = [[ListaCinemas objectAtIndex:sender.tag]  objectForKey:@"telefone"];
    
    NSString * strTrim = [[numPhone componentsSeparatedByCharactersInSet:
                                                 [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                                componentsJoinedByString:@""];
    
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", strTrim]]];
}

- (void)btnComoChegarClick:(UIButton *)sender {
    
    NSString * logradouro = [[ListaCinemas objectAtIndex:sender.tag]  objectForKey:@"logradouro"];
    NSString * numero = [[ListaCinemas objectAtIndex:sender.tag]  objectForKey:@"numero"];
    NSString * Cidade = [[ListaCinemas objectAtIndex:sender.tag]  objectForKey:@"cidade"];
    NSString * estado = [[ListaCinemas objectAtIndex:sender.tag]  objectForKey:@"estado"];
    
    Cinema = [[ListaCinemas objectAtIndex:sender.tag]  objectForKey:@"cine"];
    Onde = [[ListaCinemas objectAtIndex:sender.tag]  objectForKey:@"onde"];
    
    Endereco = [NSString stringWithFormat:@"%@, %@, %@ - %@", logradouro, numero, Cidade, estado];
    
    NSLog(@"Endereco: %@", Endereco);
    
    Map * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"1234"];
    
    vc.endereco = Endereco;
    vc.cinema = Cinema;
    //vc.onde = Onde;
    [self.navigationController pushViewController:vc animated:YES];
}

//- (int)daysBetween:(NSDate *)dt1 and:(NSDate *)dt2 {
//    NSUInteger unitFlags = NSCalendarUnitDay;
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSDateComponents *components = [calendar components:unitFlags fromDate:dt1 toDate:dt2 options:0];
//    
//    return (int)[components day]+1;
//    
//    
//}
//
//-(NSDate * )strToDateFull:(NSString *)dataStr formato:(NSString *)format{
//    
//    //Identefica qual o formato do objeto da data//
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:format];
//    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:-3]];
//    NSDate * date = [dateFormat dateFromString:dataStr];
//    
//    return date;
//    
//}


//- (void)btnEventoClick:(UIButton *)sender {
//    
//    NSString * strDataInicio = [[ListaCinemas objectAtIndex:sender.tag]  objectForKey:@"data_inicial"];
//    NSString * strDataFinal = [[ListaCinemas objectAtIndex:sender.tag]  objectForKey:@"data_final"];
//    hora = [[ListaCinemas objectAtIndex:sender.tag]  objectForKey:@"hora"];
//    NSDate * dtHoje = [NSDate date];
//    
//    if ([strDataInicio isEqualToString:@""]){
//        
//        
//        NSDate * data_escolhida = [self strToDateFull:strDataFinal formato:@"yyyy-MM-dd HH:mm:ss"];
//        
//        NSLog(@"%@",data_escolhida);
//        
//        [self addEvent:data_escolhida];
//        [self performSelector:@selector(Alert) withObject:nil afterDelay:0.3];
//        
//        
//    } else {
//        
//        NSDate * dateInicial = [self strToDateFull:strDataInicio formato:@"yyyy-MM-dd HH:mm:ss"];
//        NSDate * dateFinal = [self strToDateFull:strDataFinal formato:@"yyyy-MM-dd HH:mm:ss"];
//        
//        if( [dateInicial timeIntervalSinceDate:dtHoje] > 0 ) {
//            
//            dtInicio = dateInicial;
//            
//        } else {
//            dtInicio = dtHoje;
//        }
//        
//        // montar o Array com as datas //
//        NSInteger qtdeDias = [self daysBetween:dtInicio and:dateFinal];
//        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
//        onlyDate = [[NSMutableArray alloc] init];
//        
//        for (NSInteger i = 0; i < qtdeDias; i ++) {
//            
//            NSDate *newDate = [dtInicio dateByAddingTimeInterval:60*60*24*i];
//            
//            NSString * strData = [NSString stringWithFormat:@"%@ - %@h",[self retornaDataString_pt:newDate], hora];
//            NSString * strOnlyDate = [self retornaDataString_en:newDate];
//            
//            [mutableArray addObject:strData];
//            [onlyDate addObject:strOnlyDate];
//            
//        }
//        NSLog(@"array %@", mutableArray);
//        NSLog(@"Onlydate %@", onlyDate);
//        
//        self.datas = [mutableArray copy];
//        
//        CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Datas disponíveis" cancelButtonTitle:@"Cancelar" confirmButtonTitle:@"Confirmar"];
//        picker.delegate = self;
//        picker.dataSource = self;
//        picker.needFooterView = YES;
//        picker.headerBackgroundColor = [UIColor grayColor];
//        picker.headerTitleColor = [UIColor whiteColor];
//        picker.cancelButtonBackgroundColor = [UIColor whiteColor];
//        picker.cancelButtonNormalColor = [UIColor grayColor];
//        picker.confirmButtonBackgroundColor = [UIColor grayColor];
//        
//        [picker show];
//    }
//}
//
//-(NSString *)retornaDataString_pt:(NSDate * ) data{
//    
//    NSDate *date = data;
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"dd/MM/YY EE"];
//    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"pt_BR"]];
//    
//    NSString *dateString = [dateFormatter stringFromDate:date];
//    
//    return dateString;
//}
//
//-(NSString *)retornaDataString_en:(NSDate * ) data{
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    
//    NSString *dateString = [dateFormatter stringFromDate:data];
//    
//    return dateString;
//}
//
//
//- (NSString *)czpickerView:(CZPickerView *)pickerView
//               titleForRow:(NSInteger)row{
//    return self.datas[row];
//}
//
//- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
//    return self.datas.count;
//}
//
//- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row{
//    NSLog(@"%@ is chosen!", self.datas[row]);
//    
//    NSString * dataOnly = [NSString stringWithFormat:@"%@ %@", [onlyDate objectAtIndex:row], hora];
//    
//    NSDate * data_escolhida = [self strToDateFull:dataOnly formato:@"yyyy-MM-dd HH:mm"];
//    
//    NSLog(@"%@",data_escolhida);
//    
//    [self addEvent:data_escolhida];
//    [self performSelector:@selector(Alert) withObject:nil afterDelay:0.3];
//    
//    
//}
//
//- (void)czpickerViewDidClickCancelButton:(CZPickerView *)pickerView{
//    NSLog(@"Canceled.");
//}
//
//
//-(void)addEvent:(NSDate *)dataEscolhida {
//    
//    
//    NSTimeInterval secondsInEightHours = 3 * 60 * 60;
//    NSDate *dateEightHoursAhead = [dataEscolhida dateByAddingTimeInterval:secondsInEightHours];
//    
//    NSLog(@"data escolhida %@", dateEightHoursAhead);
//    
//    // NSTimeInterval duashoras = 2 * 60 * 60;
//    
//    EKEventStore * eventStore = [[EKEventStore alloc]init];
//    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]){
//        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
//            if (granted){
//                addEventGranted = 1;
//                EKEvent * event = [EKEvent eventWithEventStore:eventStore];
//                
//                [event setTitle:lbNomeFilme.text];
//                [event setStartDate:dateEightHoursAhead];
//                [event setEndDate:dateEightHoursAhead];
//                [event setLocation:Endereco];
//                [event setNotes:lbDescricaoFilme.text];
//                
//                NSTimeInterval alarmOffset = -1*1440*60;
//                EKAlarm * alarm = [EKAlarm alarmWithRelativeOffset:alarmOffset];
//                [event addAlarm:alarm];
//                
//                [event setCalendar:[eventStore defaultCalendarForNewEvents]];
//                NSError * err;
//                [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
//            }
//        }];
//    }
//}
//
//-(void) Alert {
//    if (addEventGranted == 1){
//        UIAlertView * alert = [[UIAlertView alloc]
//                               initWithTitle:@"Mensagem"
//                               message:@"Evento foi inserido com sucesso"  delegate:self
//                               cancelButtonTitle:@"Ok"
//                               otherButtonTitles:nil];
//        [alert show];
//    }
//}








//--------------- Verificar a internet -----------------//
-(void) viewWillAppear:(BOOL)animated {
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    hostReachable = [Reachability reachabilityWithHostName:@"www.revide.com.br"];
    [hostReachable startNotifier];
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





@end

//
//  MenuCultural.m
//  AppsAgronomo
//
//  Created by Fabricio Padua on 16/07/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import "MenuCultural.h"
#import <TSMessages/TSMessageView.h>
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "MenuCulturalCell.h"
#import "SWRevealViewController.h"

#import "Outros.h"
#import "CinemaTable.h"


#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]


@interface MenuCultural ()


@property (nonatomic, strong) HMSegmentedControl *segmentedControl4;


@end

@implementation MenuCultural

@synthesize ViewApper;
@synthesize viewTop;


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
    
    self.title = @"Guia Cultural";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self addSeguiment];
    
    self.navigationController.navigationBar.translucent = NO;
    
}

-(void) Loading:(NSURL *) urlLista {
    
    if (internetActive){
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.dimBackground = YES;
        
        NSURLSession * session = [NSURLSession sharedSession];
        
        NSURLSessionDownloadTask * task =
        [session downloadTaskWithURL:urlLista completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            NSData * jsonData = [[NSData alloc] initWithContentsOfURL:location];
            ListaCultural = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            
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
    return ListaCultural.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCulturalCell *cell = (MenuCulturalCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSURL * urlImage = [NSURL URLWithString:[[ListaCultural objectAtIndex:indexPath.row] objectForKey:@"imagem"]];
    
    cell.imgCultural.image = [UIImage imageNamed:@"loading_materia"];
    
    
    if (numMenu == 0) {
        cell.VisualEfectMenu.hidden = YES;
        cell.descricao.hidden = YES;
    } else {
        cell.descricao.text = [[ListaCultural objectAtIndex:indexPath.row] objectForKey:@"descricao"];
        cell.VisualEfectMenu.hidden = NO;
        cell.descricao.hidden = NO;
    }
    
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:urlImage completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    MenuCulturalCell * updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                    if (updateCell)
                        updateCell.imgCultural.image = image;
                });
            }
        }
    }];
    [task resume];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ObjetoJson = [ListaCultural objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
    NSString * idViewMovie = [ObjetoJson objectForKey:@"id"];
    
    if (numMenu == 0) {
    
        NSString * slug = [ObjetoJson objectForKey:@"descricao"];
        
        NSString * UrlCinema = [NSString stringWithFormat:@"http://www.revide.com.br/saia-de-casa/cinema/%@", slug];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UrlCinema]];
        
    } else {
        
        Outros * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"outros"];
        vc.idView = idViewMovie;
        vc.NumMenu = [NSString stringWithFormat: @"%ld", (long)numMenu];
      
        [self.navigationController pushViewController:vc animated:YES];

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
            if (numMenu == 0) {
                [self Loading:[NSURL URLWithString:@"http://www.revide.com.br/api_revide/listamovies_ios.php"]];
            } else if (numMenu == 1) {
                 [self Loading:[NSURL URLWithString:@"http://www.revide.com.br/api_revide/lista_teatro.php"]];
            } else if (numMenu == 2) {
                [self Loading:[NSURL URLWithString:@"http://www.revide.com.br/api_revide/lista_musicas.php"]];
            } else if (numMenu == 3) {
               [self Loading:[NSURL URLWithString:@"http://www.revide.com.br/api_revide/lista_eventos.php"]];
            } else if (numMenu == 3) {
               [self Loading:[NSURL URLWithString:@"http://www.revide.com.br/api_revide/lista_literaratura.php"]];
            }
            
            break;
        }
        case ReachableViaWWAN: {
            self->internetActive = YES;
            if (numMenu == 0) {
                [self Loading:[NSURL URLWithString:@"http://www.revide.com.br/api_revide/listamovies_ios.php"]];
            } else if (numMenu == 1) {
                [self Loading:[NSURL URLWithString:@"http://www.revide.com.br/api_revide/lista_teatro.php"]];
            } else if (numMenu == 2) {
                [self Loading:[NSURL URLWithString:@"http://www.revide.com.br/api_revide/lista_musicas.php"]];
            } else if (numMenu == 3) {
                [self Loading:[NSURL URLWithString:@"http://www.revide.com.br/api_revide/lista_eventos.php"]];
            } else if (numMenu == 3) {
                [self Loading:[NSURL URLWithString:@"http://www.revide.com.br/api_revide/lista_literaratura.php"]];
            }

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



//------------- rotina de add seguimento ------------------//
-(void) addSeguiment {
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    
    viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    [viewHeader setBackgroundColor:[UIColor clearColor]];
    
    // Tying up the segmented control to a scroll view
//    self.segmentedControl4 = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    
    self.segmentedControl4  = [[HMSegmentedControl alloc] initWithSectionImages:
                               @[[UIImage imageNamed:@"iconCinema"],
                                 [UIImage imageNamed:@"iconTeatro"],
                                 [UIImage imageNamed:@"iconMusica"],
                                 [UIImage imageNamed:@"iconEvento"],
                                 [UIImage imageNamed:@"iconLiteratura"]]
            sectionSelectedImages:
                                @[[UIImage imageNamed:@"iconCinemaSelec"],
                                  [UIImage imageNamed:@"iconTeatroSelec"],
                                  [UIImage imageNamed:@"iconMusicaSelec"],
                                  [UIImage imageNamed:@"iconEventoSelec"],
                                  [UIImage imageNamed:@"iconLiteraturaSelec"]]];
    
    self.segmentedControl4 .frame = CGRectMake(0, 0, viewWidth, 50);
    
    self.segmentedControl4.selectedSegmentIndex = 0;
    self.segmentedControl4.backgroundColor = Rgb2UIColor(153, 153, 153);
    
    self.segmentedControl4.selectionIndicatorColor = Rgb2UIColor(255, 163, 38);
    
    self.segmentedControl4.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedControl4.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl4.tag = 3;
    [self.segmentedControl4 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    [viewHeader addSubview:self.segmentedControl4];
    
    self.tableView.tableHeaderView = viewHeader;
    }

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    if (segmentedControl.selectedSegmentIndex == 0) {
        [self Loading:[NSURL URLWithString:@"http://www.revide.com.br/api_revide/listamovies_ios.php"]];
        numMenu = 0;
    } else if (segmentedControl.selectedSegmentIndex == 1) {
        [self Loading:[NSURL URLWithString:@"http://www.revide.com.br/api_revide/lista_teatro.php"]];
        numMenu = 1;
    } else if (segmentedControl.selectedSegmentIndex == 2) {
        [self Loading:[NSURL URLWithString:@"http://www.revide.com.br/api_revide/lista_musicas.php"]];
        numMenu = 2;
    } else if (segmentedControl.selectedSegmentIndex == 3) {
        [self Loading:[NSURL URLWithString:@"http://www.revide.com.br/api_revide/lista_eventos.php"]];
        numMenu = 3;
    } else if (segmentedControl.selectedSegmentIndex == 4) {
        [self Loading:[NSURL URLWithString:@"http://www.revide.com.br/api_revide/lista_literaratura.php"]];
        numMenu = 4;
    }
}




@end

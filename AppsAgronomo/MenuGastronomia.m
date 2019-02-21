//
//  MenuGastronomia.m
//  AppsAgronomo
//
//  Created by Fabricio Padua on 24/07/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import "MenuGastronomia.h"

#import <TSMessages/TSMessageView.h>
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "SWRevealViewController.h"
#import "MenuGastronomiaCell.h"
#import "DetalheGastronomia.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface MenuGastronomia () {
    
    NSMutableArray<NSDictionary *> *_cellColors;
}


@end

@implementation MenuGastronomia

@synthesize ViewApper;
@synthesize ObjetoJson;
@synthesize Id_Menu;


static NSString * const reuseIdentifier = @"Cell";

const CGFloat leftAndRightPaddings_3 = 10.0;
const CGFloat numberOfItemsPerRow_3 = 4.0;
const CGFloat heigthAdjustment_3 = 8.0;

CGFloat width_3 = 0.0;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat varWidth = [UIScreen mainScreen].bounds.size.width;
    width_3 = ((varWidth - leftAndRightPaddings_3) / numberOfItemsPerRow_3);
    
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
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


-(void)Loading{
    
    if (internetActive){
        
        NSURL  *url = [NSURL URLWithString:@"http://www.revide.com.br/api_revide/lista_CategoriaGastronomia.php"];
        
        NSURLSession * session = [NSURLSession sharedSession];
        
        NSURLSessionDownloadTask * task =
        [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            NSData * jsonData = [[NSData alloc] initWithContentsOfURL:location];
            
            listaManu = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
                //hud.hidden = YES;
                
            });

            
        }];
        
        [task resume];
    }
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return listaManu.count;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ObjetoJson = [listaManu objectAtIndex:indexPath.row];
    NSString * idView = [ObjetoJson objectForKey:@"id"];
    NSString * categoria  = [ObjetoJson objectForKey:@"nome"];
    
    DetalheGastronomia * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Gastronomia"];
    vc.id_Categoria = idView;
    vc.Categoria = categoria;
    
    [self.navigationController pushViewController:vc animated:YES];

}




- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MenuGastronomiaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
   
    cell.lbTextoMenu.text = [[listaManu objectAtIndex:indexPath.row] objectForKey:@"nome"];
    
    NSURL * urlImage = [NSURL URLWithString:[[listaManu objectAtIndex:indexPath.row] objectForKey:@"imagem"]];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask * task = [session downloadTaskWithURL:urlImage
                                                 completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                     
                                                     NSData * imageData = [[NSData alloc] initWithContentsOfURL:location];
                                                     UIImage *img = [UIImage imageWithData:imageData];
                                                     
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         cell.imgGastronimia.image = img;
                                                         
                                                         
                                                     });
                                                 }];
    [task resume];
    
    
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = CGRectGetWidth(collectionView.bounds);
    
    CGFloat cellSapceWidth = 5.0f;
    
    CGFloat numberOfCellInRow = 2.0f;
    
    CGFloat cellWidth = (width - cellSapceWidth) / numberOfCellInRow - cellSapceWidth;
    
    return CGSizeMake(cellWidth, cellWidth);
}



@end

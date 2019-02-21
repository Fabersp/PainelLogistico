//
//  GessagemTVC.h
//  AppDoAgronomo
//
//  Created by Fabricio Aguiar de Padua on 14/08/14.
//  Copyright (c) 2014 Pro Master Solution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import "Reachability.h"






@interface ColheitaTVC : UITableViewController{
    
    __weak IBOutlet UIBarButtonItem *Add;
    NSString * TitlePurchase;
    NSString * DescriptionPurchase;
    NSString * ValuePurchase;
    NSArray * noticiasRecentes;
    NSArray * ListaIDEdicoes;
    NSDictionary * ObjetoJson;
    UIRefreshControl * refreshControl;
    Reachability* internetReachable;
    Reachability* hostReachable;
    bool internetActive;
    bool hostActive;
    NSString * verificaNoticias;
    NSString *  idCategoria;
    NSString * UrlMontadada;



}

-(void) checkNetworkStatus:(NSNotification *)notice;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIView *ViewApper;
@property(nonatomic, weak) IBOutlet UIActivityIndicatorView *loadingSpinner;


@property (strong, nonatomic) NSString *productID,  *  idCategoria, *UrlMontadada, *verificaNoticias, * idViewNoticia, * categoriaNoticia;

@property (strong, nonatomic) NSString *colunaID;
@property (nonatomic, retain) NSString * TitlePurchase, * DescriptionPurchase, * ValuePurchase;




@end

//
//  ViewNoticias.h
//  AppsAgronomo
//
//  Created by Fabricio Padua on 29/06/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "Reachability.h"

@interface ViewNoticias : UIViewController {
    
    NSArray * detalheNoticia;
    NSString * idViewNoticia;
    NSURL * URLShare;
    Reachability* internetReachable;
    Reachability* hostReachable;
    bool internetActive;
    bool hostActive;
        
    
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnShare;

@property (weak, nonatomic) IBOutlet UILabel *Categoria2;


@property (nonatomic, retain) NSString * idViewNoticia;

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *imgClock;

@property (weak, nonatomic) IBOutlet UILabel *categoria;

@property (weak, nonatomic) IBOutlet UILabel *descricao;

@property (weak, nonatomic) IBOutlet UILabel *publicadopor;
@property (weak, nonatomic) IBOutlet UILabel *dataHora;
@property (weak, nonatomic) IBOutlet UILabel *textoMateria;

@property (weak, nonatomic) IBOutlet UIImageView *imgbg;

@property (weak, nonatomic) IBOutlet UILabel *detalhe2;

@property (weak, nonatomic) IBOutlet UILabel *creditoImagem;

@end

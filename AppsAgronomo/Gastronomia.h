//
//  Gastronomia.h
//  AppsAgronomo
//
//  Created by Fabricio Padua on 24/07/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "MWPhotoBrowser.h"

@interface Gastronomia : UITableViewController <MWPhotoBrowserDelegate>{
    
    NSString * idView, * NumMenu, * Endereco, * onde, * telefone, *estabelecimento;
    
    NSArray * lista, * horarios, * fotos;
    
    Reachability* internetReachable;
    Reachability* hostReachable;
    bool internetActive;
    bool hostActive;
    NSMutableArray * _selections;
    NSURL * UrlImagem;
    
}

@property (nonatomic, retain) NSString * idView, * NumMenu, * Endereco, * onde, * telefone, * estabelecimento;

@property (nonatomic, retain) NSURL * UrlImagem;

@property (weak, nonatomic) IBOutlet UIImageView *ImgCapa;
@property (weak, nonatomic) IBOutlet UITextView *TextDetalhes;


@property (weak, nonatomic) IBOutlet UILabel *lbTitulo;

@property (weak, nonatomic) IBOutlet UILabel *lbDetalhes;
@property (weak, nonatomic) IBOutlet UILabel *lbQuando;

@property (weak, nonatomic) IBOutlet UILabel *lbOnde;

@property (weak, nonatomic) IBOutlet UIButton *obInformacoes;

@property (weak, nonatomic) IBOutlet UILabel *lbEndereco;
@property (weak, nonatomic) IBOutlet UIButton *btnMapa;
@property (weak, nonatomic) IBOutlet UILabel *lbQuanto;

@property (nonatomic, strong) NSMutableArray *photos;

@end

//
//  DetalhesPromocao.h
//  AppsAgronomo
//
//  Created by Fabricio Padua on 16/08/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface DetalhesPromocao : UIViewController {
    
    NSString * id_Vigencia;
    NSArray * lista;
    NSString * descricao;
    NSString * resenha;
    Reachability* internetReachable;
    Reachability* hostReachable;
    bool internetActive;
    bool hostActive;
    NSString * text_Capa;
    
    NSURL * UrlImagem;

    
}

@property (nonatomic, retain) NSString * text_Capa, * id_Vigencia, * descricao, * resenha;
@property (nonatomic, retain) NSURL * UrlImagem;


@property (weak, nonatomic) IBOutlet UIImageView *imgCapa;

@property (weak, nonatomic) IBOutlet UILabel *lbPromocao;

@property (weak, nonatomic) IBOutlet UIButton *btnParticipar;


@property (weak, nonatomic) IBOutlet UILabel *lbDescricao;

@property (weak, nonatomic) IBOutlet UITextField *txNome;

@property (weak, nonatomic) IBOutlet UITextField *txIdade;

@property (weak, nonatomic) IBOutlet UITextField *txTelefone;

@property (weak, nonatomic) IBOutlet UITextField *txEmail;

@end

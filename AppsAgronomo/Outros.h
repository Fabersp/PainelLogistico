//
//  Teatro.h
//  AppsAgronomo
//
//  Created by Fabricio Padua on 21/07/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <CZPicker.h>

@interface Outros : UIViewController <CZPickerViewDataSource, CZPickerViewDelegate>{
    
    NSString * idView, * NumMenu, * Endereco, * onde, * telefone, * hora;
    
    NSArray * lista;
    
    NSDate * dtInicio;
    
    Reachability* internetReachable;
    Reachability* hostReachable;
    bool internetActive;
    bool hostActive;
    NSMutableArray *onlyDate;

}

@property (nonatomic, retain) NSString * idView, * NumMenu, * Endereco, * onde, * telefone, * hora;
@property (weak, nonatomic) IBOutlet UIImageView *ImgCapa;
@property (weak, nonatomic) IBOutlet UITextView *TextDetalhes;

@property (weak, nonatomic) IBOutlet UILabel *lbInicialQuando;
@property (weak, nonatomic) IBOutlet UILabel *lbInicialQuanto;

@property (weak, nonatomic) IBOutlet UILabel *lbInicialOnde;



@property (weak, nonatomic) IBOutlet UILabel *lbTitulo;

@property (weak, nonatomic) IBOutlet UILabel *lbDetalhes;
@property (weak, nonatomic) IBOutlet UILabel *lbQuando;

@property (weak, nonatomic) IBOutlet UILabel *lbOnde;

@property (weak, nonatomic) IBOutlet UIButton *obInformacoes;

@property (weak, nonatomic) IBOutlet UILabel *lbEndereco;
@property (weak, nonatomic) IBOutlet UIButton *btnMapa;
@property (weak, nonatomic) IBOutlet UILabel *lbQuanto;

@property (weak, nonatomic) IBOutlet UIButton *btnfone;

@property (weak, nonatomic) IBOutlet UIButton *btnAddEvento;



@end

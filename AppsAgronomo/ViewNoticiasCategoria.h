//
//  ViewNoticias.h
//  AppsAgronomo
//
//  Created by Fabricio Padua on 29/06/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewNoticiasCategoria : UITableViewController {
    
   
    NSArray * detalheNoticia;
    NSString * idViewNoticia;
}

@property (nonatomic, retain) NSString * idViewNoticia;


@property (weak, nonatomic) IBOutlet UILabel *categoria;

@property (weak, nonatomic) IBOutlet UILabel *descricao;

@property (weak, nonatomic) IBOutlet UILabel *publicadopor;
@property (weak, nonatomic) IBOutlet UILabel *dataHora;
@property (weak, nonatomic) IBOutlet UILabel *textoMateria;

@property (weak, nonatomic) IBOutlet UIImageView *imgbg;

@property (weak, nonatomic) IBOutlet UILabel *detalhe2;

@end

//
//  CalagemCellTableViewCell.h
//  Calagem
//
//  Created by Fabricio Aguiar de Padua on 30/05/14.
//  Copyright (c) 2014 Pro Master Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColheitaCell : UITableViewCell {
    
    
}

@property (weak, nonatomic) IBOutlet UILabel *edCategoria;

@property (weak, nonatomic) IBOutlet UIImageView *ImgFundo;

@property (weak, nonatomic) IBOutlet UILabel *edDetalheNoticias;

@property (weak, nonatomic) IBOutlet UILabel *lbIdNoticia;
@property (weak, nonatomic) IBOutlet UILabel *backgroudTexto;

@end

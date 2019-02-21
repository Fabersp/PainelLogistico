//
//  CinemaTVCell.h
//  AppsAgronomo
//
//  Created by Fabricio Padua on 16/07/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CinemaTVCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *txCinema;
@property (weak, nonatomic) IBOutlet UILabel *tituloCinema;


@property (weak, nonatomic) IBOutlet UILabel *txOnde;
@property (weak, nonatomic) IBOutlet UILabel *tituloOnde;


@property (weak, nonatomic) IBOutlet UILabel *txSessao;
@property (weak, nonatomic) IBOutlet UILabel *tituloSessao;


@property (weak, nonatomic) IBOutlet UIButton *btnPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnLocation;

@end

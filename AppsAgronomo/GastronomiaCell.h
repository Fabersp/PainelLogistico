//
//  GastronomiaCell.h
//  AppsAgronomo
//
//  Created by Fabricio Padua on 25/07/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GastronomiaCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbEndereco;

@property (weak, nonatomic) IBOutlet UITextView *txtHorarios;

@property (weak, nonatomic) IBOutlet UIButton *btnTelefone;

@property (weak, nonatomic) IBOutlet UIButton *btnMap;

@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;

@property (weak, nonatomic) IBOutlet UIButton *btnSite;

@end

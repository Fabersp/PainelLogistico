//
//  CinemaTable.h
//  AppsAgronomo
//
//  Created by Fabricio Padua on 12/08/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <YTPlayerView.h>


@interface CinemaTable : UITableViewController {
    
    
    NSString * idViewMovie, * descricao, * IdVideo, * hora;
    NSString * Cinema;
    NSString * Onde;
    NSString * Endereco;
    NSArray * ListaCinemas;
    Reachability* internetReachable;
    Reachability* hostReachable;
    bool internetActive;
    bool hostActive;
    
    NSDate * dtInicio;
    NSMutableArray *onlyDate;
    
}


@property (nonatomic, retain) NSString * idViewMovie, * descricao, * IdVideo, * Cinema, * Onde, * Endereco, * hora, * nomeFilme;
@property (weak, nonatomic) IBOutlet UIView *viewTop;

@property (weak, nonatomic) IBOutlet UIImageView *imgCapa;


@property (weak, nonatomic) IBOutlet YTPlayerView *ViewTrailer;

@property (weak, nonatomic) IBOutlet UILabel *lbNomeFilme;

@property (weak, nonatomic) IBOutlet UITextView *lbDescricaoFilme;


@end

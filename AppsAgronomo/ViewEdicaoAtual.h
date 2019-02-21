//
//  ViewEdicaoAtual.h
//  AppsAgronomo
//
//  Created by Fabricio Padua on 30/06/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import "Reachability.h" 

@interface ViewEdicaoAtual : UIViewController <MWPhotoBrowserDelegate> {


    NSArray * EdicaoAtual, * PathsPaginas;
    
    NSDictionary * ObjetoJson;
    NSMutableArray * _selections;
    NSString * Edicao, * ID_Edicao;
    Reachability * internetReachable;
    Reachability * hostReachable;
    bool internetActive;
    bool hostActive;
   NSArray * ListaIDEdicoes;
   

}

-(void)MensagemErro;
-(void) criarPasta:(NSString * ) pasta;
-(BOOL) checkIfDirectoryAlreadyExists:(NSString *)name;
-(void) BucarDadosPasta :(NSString *) Pasta;
-(void) downloadImage2 :(NSString *) pasta :(NSString *) URL :(NSInteger ) Paginas;
-(void) VisualizarEdicao:(NSString * )Pasta;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnExcluirEdAtual;


@property (weak, nonatomic) IBOutlet UILabel *lbEdicao;

@property (nonatomic, retain) NSDictionary * ObjetoJson;
@property (strong, nonatomic) NSMutableArray *pageImages;
@property (strong, nonatomic) NSString * pastaEdicao, * pasta, * ID_Edicao, * Edicao;

@property (nonatomic, strong) NSMutableArray *photos;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIView *ViewApper;


@property (weak, nonatomic) IBOutlet UIImageView *imgCapa;

@property (weak, nonatomic) IBOutlet UIButton *btnDownload;

@end

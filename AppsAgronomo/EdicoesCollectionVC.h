//
//  EdicoesCollectionVC.h
//  AppsAgronomo
//
//  Created by Fabricio Padua on 12/07/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import "Reachability.h"
#import "HMSegmentedControl.h"

@interface EdicoesCollectionVC : UICollectionViewController <MWPhotoBrowserDelegate> {
    
    NSArray * EdicaoParaBaixar, * PathsPaginas, *ListarNumEdicoes;
    NSDictionary * ObjetoJson;
    NSMutableArray * _selections;
    NSString * Edicao, * ID_Edicao, * concatcedicao;
    NSString * VarAno;
    
    
    Reachability * internetReachable;
    Reachability * hostReachable;
    bool internetActive;
    bool hostActive;
    
    UIView * viewHeader;
    
}

@property (nonatomic, retain) NSDictionary * ObjetoJson;
@property (strong, nonatomic) NSMutableArray *pageImages;
@property (strong, nonatomic) NSString * pastaEdicao, * pasta, * ID_Edicao, *VarAno, * Edicao, * concatcedicao;
@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, strong) HMSegmentedControl *segmentedControl4;


@property (weak, nonatomic) IBOutlet UIBarButtonItem * btnExcluirEdicao;

@end

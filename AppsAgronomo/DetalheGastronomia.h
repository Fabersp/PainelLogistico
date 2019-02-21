//
//  DetalheGastronomia.h
//  AppsAgronomo
//
//  Created by Fabricio Padua on 24/07/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface DetalheGastronomia : UITableViewController {
    
    NSArray * lista;
    NSString * id_Categoria, * Categoria;
    NSURL * urlImage;
    
    Reachability * internetReachable;
    Reachability * hostReachable;
    bool internetActive;
    bool hostActive;
}

@property (nonatomic, retain) NSString * id_Categoria, * Categoria;

@end

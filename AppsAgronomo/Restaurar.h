//
//  ViewContato.h
//  SidebarDemo
//
//  Created by Fabricio Aguiar de Padua on 08/05/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <StoreKit/StoreKit.h>

@interface Restaurar : UIViewController  <SKPaymentTransactionObserver,SKProductsRequestDelegate>{
    NSString * TitlePurchase;
    NSString * DescriptionPurchase;
    NSString * ValuePurchase;
    NSString * Modulo,  *Produto;
}


@property (strong, nonatomic) SKProduct *product;
@property (strong, nonatomic) NSString *productID, * Modulo, *Produto;
@property (strong, nonatomic) NSString *colunaID;
@property (nonatomic, retain) NSString * TitlePurchase, * DescriptionPurchase, * ValuePurchase;
@property (weak, nonatomic) IBOutlet UIButton *btnRestaurar;

@end

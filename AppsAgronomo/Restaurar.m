//
//  ViewContato.m
//  SidebarDemo
//
//  Created by Fabricio Aguiar de Padua on 08/05/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "Restaurar.h"




@interface Restaurar ()

@end

@implementation Restaurar

@synthesize TitlePurchase;
@synthesize DescriptionPurchase;
@synthesize ValuePurchase;
@synthesize btnRestaurar;
@synthesize Modulo;
@synthesize Produto;

- (void)viewDidLoad {
    [super viewDidLoad];
    btnRestaurar.layer.cornerRadius = 10.0f;
    btnRestaurar.layer.masksToBounds = YES;
    
    if ([Modulo isEqualToString:@"Calagem"]){
        Produto = @"com.master.AppsAgronomo.Calagem";
    }
    if ([Modulo isEqualToString:@"Gessagem"]){
        Produto = @"com.master.AppsAgronomo.Gessagem";
    }
    
    
}

-(void) callPaymentQueue {
    _productID = Produto;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    if ([SKPaymentQueue canMakePayments]) {
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:self.productID]];
        request.delegate = self;
        [request start];
    } else  {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro"
                                                        message:@"Ative sua compra de Apps nas configurações"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void) purchase {
    SKPayment *payment = [SKPayment paymentWithProduct:_product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    [self UnlockPurchase];
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *products = response.products;
    if (products.count != 0) {
        _product = products[0];
        TitlePurchase = _product.localizedTitle;
        DescriptionPurchase = _product.localizedDescription;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:TitlePurchase
                                                        message:DescriptionPurchase
                                                       delegate:self
                                              cancelButtonTitle:@"Cancelar"
                                              otherButtonTitles:@"Comprar", nil];
        [alert show];
        
    } else {
        //_productTitle.text = @"Product Not Found";
    }
    products = response.invalidProductIdentifiers;
    for (SKProduct *product in products) {
        NSLog(@"Product not Found: %@", product);
    }
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            
            case SKPaymentTransactionStatePurchased:[self UnlockPurchase];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                break;
            case SKPaymentTransactionStateFailed:NSLog(@"Transaction Failed");
                [self failedTransaction:transaction];
                
            case SKPaymentTransactionStateRestored:NSLog(@"Restaurado");
                [self restoreTransaction:transaction];
                [self SalvarCompras];
                [self MessagemRestore];
            default:
                break;
        }
    }
}

- (void)provideContent:(NSString *)productIdentifier {
    
    NSLog(@"Toggling flag for: %@", productIdentifier);
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //[_purchasedProducts addObject:productIdentifier];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Modulo object:productIdentifier];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"restoreTransaction...");
    
    //[self recordTransaction: transaction];
    [self provideContent: transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

-(void)SalvarCompras{
    NSUserDefaults * SaveApp = [NSUserDefaults standardUserDefaults];
    [SaveApp setBool:TRUE forKey:Modulo];
    [SaveApp synchronize];
}

- (IBAction)restoreCompletedTransactions:(id)sender {
    
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
- (void) MessagemRestore{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString  stringWithFormat:@"Modulo %@", Modulo]
                                                    message:@"Modulo desabilitado!"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancelar"
                                          otherButtonTitles:nil];
    [alert show];

}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

-(void)UnlockPurchase {
    // [_homeViewController Purchased];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)restoreThePurchase {
    
    // verify/refresh receipt here (even though Apple doesn't say how)
    
    // restore the purchase
    [[SKPaymentQueue defaultQueue]restoreCompletedTransactions];
    
    return YES;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

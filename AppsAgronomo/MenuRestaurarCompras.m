//
//  ViewContato.m
//  SidebarDemo
//
//  Created by Fabricio Aguiar de Padua on 08/05/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "MenuRestaurarCompras.h"
#import "Restaurar.h"


@interface MenuRestaurarCompras ()

@end

@implementation MenuRestaurarCompras

@synthesize BtnCalagem;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    BtnCalagem.layer.cornerRadius = 10.0f;
    BtnCalagem.layer.masksToBounds = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"Calagem"]) {
        
        Restaurar * destViewController = segue.destinationViewController;
        destViewController.Modulo = @"Calagem";
        destViewController.title = @"Calagem";
    }
    if ([[segue identifier] isEqualToString:@"Gessagem"]) {
        
        Restaurar * destViewController = segue.destinationViewController;
        destViewController.Modulo = @"Gessagem";
        destViewController.title = @"Gessagem";
    }

    
    
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

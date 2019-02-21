//
//  ViewContato.m
//  SidebarDemo
//
//  Created by Fabricio Aguiar de Padua on 08/05/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "ViewContato.h"
#import "SWRevealViewController.h"
#import <sys/utsname.h>
#import "Map.h"


@interface ViewContato ()

@end

@implementation ViewContato

@synthesize contato;
@synthesize contarumamigo;
@synthesize site;

@synthesize ViewApper;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    
    [ViewApper setFrame:[[UIScreen mainScreen] bounds]];
    
    [self.navigationController.view addSubview:ViewApper];
    
    // [self.view addSubview:ViewApper];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

- (IBAction)btnMap:(id)sender {
    NSString * Endereco = @"Rua Galileu Galilei, 1127, Jardim Irajá, Ribeirão Preto - SP";
    
    Map * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"1234"];
    
    vc.endereco = Endereco;
    vc.cinema = @"ProMaster Solution";
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)btnEmail:(id)sender {
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        // [[mailer navigationBar] setTintColor:[UIColor whiteColor]];
        
        [mailer setSubject:@"Contato - App Mais Equilíbrio - iOS"];
        
        NSArray *toRecipients = [NSArray arrayWithObjects:@"comercial@promastersolution.com.br", nil];
        [mailer setToRecipients:toRecipients];
        // only for iPad
        mailer.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentViewController:mailer animated:YES completion:^{NSLog (@"Action Completed");}];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Falha"
                                                        message:@"Este dispositivo não suporta o envio de e-mail."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}
- (IBAction)btnFacebook:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/promastersolution/"]];
    
}

- (IBAction)btnHome:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.promastersolution.com.br/"]];
}


- (IBAction)btnTelefone:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:16992318863"]];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
    //	[self dismissModalViewControllerAnimated:YES];
    [self becomeFirstResponder];
    [self dismissViewControllerAnimated:NO completion:nil];
}






@end

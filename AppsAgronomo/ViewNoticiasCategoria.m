//
//  ViewNoticias.m
//  AppsAgronomo
//
//  Created by Fabricio Padua on 29/06/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import "ViewNoticiasCategoria.h"


@interface ViewNoticiasCategoria ()

@end

@implementation ViewNoticiasCategoria


@synthesize idViewNoticia;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self Loading:idViewNoticia];
    self.navigationController.navigationBar.translucent = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)Loading:(NSString *) idNoticia{
    
//     NSString * UrlMontadada = [NSString stringWithFormat:@"http://www.omdbapi.com/?t=%@",idNoticia];
    
    
    NSString * UrlMontadada = [NSString stringWithFormat:@"http://www.revide.com.br/api_revide/detalhenoticia_ios.php?id=%@", idNoticia];
    
    NSURL * url = [NSURL URLWithString:UrlMontadada];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask * task =
    [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSData * jsonData = [[NSData alloc] initWithContentsOfURL:location];
        
        detalheNoticia = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSURL * urlImage = [NSURL URLWithString:[[detalheNoticia objectAtIndex:0] objectForKey:@"imagem"]];

            
            NSURLSession * session = [NSURLSession sharedSession];
            
            NSURLSessionDownloadTask * task = [session downloadTaskWithURL:urlImage
                                                         completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                             
                                                             NSData * imageData = [[NSData alloc] initWithContentsOfURL:location];
                                                             UIImage *img = [UIImage imageWithData:imageData];
                                                             
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 _imgbg.image = img;
                                                             });
                                                         }];
            [task resume];
            
            _categoria.text = [[detalheNoticia objectAtIndex:0] objectForKey:@"categoria"];
            _detalhe2.text = [[detalheNoticia objectAtIndex:0] objectForKey:@"olho"];
            _descricao.text = [[detalheNoticia objectAtIndex:0] objectForKey:@"titulo"];
            _publicadopor.text = [[detalheNoticia objectAtIndex:0] objectForKey:@"nome"];
            
            
//            NSString *htmlString = [[detalheNoticia objectAtIndex:0] objectForKey:@"noticia"];
//            NSAttributedString *attributedString = [[NSAttributedString alloc]
//                                                    initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
//                                                    options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
//                                                    documentAttributes: nil
//                                                    error: nil
//                                                    ];
//            _textoMateria.attributedText = attributedString;
            
            _textoMateria.text = [[detalheNoticia objectAtIndex:0] objectForKey:@"noticia"];
            
            NSString * dateStr = [[detalheNoticia objectAtIndex:0] objectForKey:@"alteracao"];
            NSLog(@"dateStr Fisrt: %@", dateStr);
            
            //Identefica qual o formato do objeto da data//
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate * date = [dateFormat dateFromString:dateStr];
            
            //Converte para qual modelo eu deseja que converta//
            [dateFormat setDateFormat:@"dd/mm/YY - HH:mm'h'"];
            dateStr = [dateFormat stringFromDate:date];
            
            // Passa o paramentro para data //
            NSLog(@"dateStr second: %@", dateStr);
            
            _dataHora.text = dateStr;
            
        });
        
    }];
    [task resume];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

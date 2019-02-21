//
//  VideosCell.h
//  AppsAgronomo
//
//  Created by Fabricio Padua on 27/07/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YTPlayerView.h>

@interface VideosCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbVideo;

@property (nonatomic, weak) IBOutlet YTPlayerView *Video;
@end

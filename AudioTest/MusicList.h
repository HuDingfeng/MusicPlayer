//
//  MusicList.h
//  AudioTest
//
//  Created by hdf on 14-8-22.
//  Copyright (c) 2014年 胡定锋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicList : UITableView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSArray *arr;
@end

//
//  MusicList.m
//  AudioTest
//
//  Created by hdf on 14-8-22.
//  Copyright (c) 2014年 胡定锋. All rights reserved.
//

#import "MusicList.h"

@implementation MusicList

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.bounds = CGRectMake(0, 0, 200, 200);
        self.alpha = 0.5;
        [self layout];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

-(void)layout
{    
    _arr = [NSArray arrayWithObjects:@"只凝视着你",@"偏爱",@"时间长了受不了",@"真的爱你",@"离不开你", nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [_arr count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellTableIdentifier = @"CellTableIdentifier ";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             CellTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:CellTableIdentifier];
        cell.textLabel.text = [_arr objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    return cell;
    
}



@end
